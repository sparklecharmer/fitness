import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';

class AddExerciseScreen extends StatefulWidget {
  AddExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  TextEditingController activityController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController userWeightController = TextEditingController();

  final apiCalls = ApiCalls();
  List<String> exercises = [];


  _loadExercises(String activityInput) async {
    if (activityInput.isEmpty) {
      print("Please enter an activity.");
      return;
    }

    try {
      List<String> fetchedExercises = await apiCalls.fetchExercises(activityInput);
      print("Fetched Exercises: $fetchedExercises");
      setState(() {
        exercises = fetchedExercises;
      });
    } catch (error) {
      print("Failed to load exercises: $error");
    }
  }
  @override


  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fitnessUsersCollection
            .where('userid', isEqualTo: auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              QueryDocumentSnapshot doc = snapshot.data!.docs[0];
              userWeightController.text = doc.get('weight').toString();
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Exercise',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12), // Adjust padding if needed
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Add border to match TextField style
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Autocomplete<String>(
                  optionsBuilder: (value) {
                    _loadExercises(value.text);
                    return exercises.where(
                          (item) => item.toLowerCase().contains(value.text.toLowerCase()),
                    );
                  },
                  onSelected: (value) {
                    setState(() {
                      activityController.text = value;
                    });
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onSubmitted: (value) => onFieldSubmitted(),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Activity', // Label text
                        hintText: 'Enter an activity',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey,  // Placeholder text color
                        ),
                        border: InputBorder.none, // Removes double border from InputDecorator
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20,),

              TextField(
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Duration', // Label text
                  hintText: 'Enter duration in minutes',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    color: Colors.grey,  // Placeholder text color
                  ),
                  border: OutlineInputBorder(), // Optional: Adds a border around the text field
                ),
                controller: durationController,
                keyboardType: TextInputType.number,
              ),

              ElevatedButton(
                child: const Text('Add'),
                onPressed: () async {
                  exercise = Exercise(
                    activity: activityController.text,
                    duration: int.parse(durationController.text),
                  );
                  await FirebaseCalls().addExercise(exercise);
                  Navigator.pop(context);
                },
              ),

            ],
          );
        },
      ),
    );
  }
}

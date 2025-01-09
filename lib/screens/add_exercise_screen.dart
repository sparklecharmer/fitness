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

  // Fetch exercises based on the user's input
  _loadExercises(String activityInput) async {
    if (activityInput.isEmpty) {
      print("Please enter an activity.");
      return; // Do not make the API call if input is empty
    }

    try {
      List<String> fetchedExercises = await apiCalls.fetchExercises(activityInput);
      print("Fetched Exercises: $fetchedExercises");
      setState(() {
        exercises = fetchedExercises;  // Update the list of exercises
      });
    } catch (error) {
      print("Failed to load exercises: $error");
    }
  }
  @override

  // Fetch exercises from the API

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
              Autocomplete<String>(
                optionsBuilder: (value) {
                  _loadExercises(value.text);

                  return exercises.where(
                        (item) => item.toLowerCase().contains(value.text.toLowerCase()),
                  );
                },
                onSelected: (value) {
                  setState(() {
                    activityController.text = value; // Update the activityController with selected value
                  });
                },
              ),
              //dunno how add decoration onto autocomplete
              TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Duration'),
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

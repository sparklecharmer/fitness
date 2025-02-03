import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
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
    return Consumer<AppMode>(
      builder: (context, mode, child) {
        return Container(
          color: mode.isDarkMode ? Color(0xFF2F2F2F) : Colors.white,
          child: Padding(
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
                    SizedBox(height: 10,),
                    Text(
                      'Add New Exercise',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        color: mode.isDarkMode ? Colors.white : null,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(

                      child: Autocomplete<String>(
                        optionsBuilder: (value) {
                          _loadExercises(value.text);
                          return exercises.where(
                                (item) =>
                                item.toLowerCase().contains(
                                    value.text.toLowerCase()),
                          );
                        },
                        onSelected: (value) {
                          setState(() {
                            activityController.text = value;
                          });
                        },
                        fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) {
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onSubmitted: (value) => onFieldSubmitted(),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .never,
                              labelText: 'Activity',
                              hintText: 'Enter an activity',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder( // Makes it match the normal TextField
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 14,
                                  horizontal: 12), // Ensuring text is centered properly
                            ),
                          );
                        },
                      ),
                    ),


                    SizedBox(height: 20,),

                    TextField(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Duration',
                        // Label text
                        hintText: 'Enter duration in minutes',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Colors.grey, // Placeholder text color
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ), // Optional: Adds a border around the text field
                      ),
                      controller: durationController,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEC704B),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          )
                      ),
                      child: const Text('Add',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
          ),
        );
      }
    );
  }
}

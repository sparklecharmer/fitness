import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../widgets/navigation_bar.dart';
import '../screens/add_exercise_screen.dart';
import '../utilities/firebase_calls.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');


  void _addExercise(String addActivity, int addDuration) {
    setState(() {
      exerciseList.add(Exercise(activity: addActivity, duration: addDuration));
    });
  }

  List<Exercise> exerciseList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: SafeArea(
        child: Column(
          children: [
            //TODO StreamBuilder to show documents in exercises collection
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddExerciseScreen(addTaskCallback: _addExercise),
                      ),
                    );
                  },
                );
              },
              child: Text('Add Exercise'),
            ),
            // TODO: Edit and delete exercises
          ],
        ),
      ),
    );
  }
}

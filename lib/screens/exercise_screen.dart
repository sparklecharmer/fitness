import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
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

  // Method to remove an exercise from Firebase
  void _removeExercise(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('exercises')  // Replace with your collection name
          .doc(docId)
          .delete();
      print("Exercise deleted successfully.");
    } catch (e) {
      print("Error deleting exercise: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AppMode>(
      builder: (context, mode, child) {
        return Scaffold(
          backgroundColor: mode.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: mode.isDarkMode ? Colors.black : Colors.white,
            title: Text(
              'Exercises',
              style: TextStyle(
                fontSize: 27,
                fontFamily: 'Poppins',
                color: mode.isDarkMode ? Colors.white : null,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                color: mode.isDarkMode ? Colors.white : null,
                onPressed: () {
                  auth.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
          body: SafeArea(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(
                      'exercises') // Replace with your collection name
                      .where('userid',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final exercises = snapshot.data!.docs.map((doc) {
                        return {
                          'id': doc.id, // Keep the document ID
                          'activity': doc['activity'],
                          'duration': doc['duration'],
                          'burnedCalories': doc['burnedCalories'],
                        };
                      }).toList();

                      return Expanded(
                        child: ListView.builder(
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = exercises[index];
                            return Dismissible(
                              key: UniqueKey(),
                              // Unique key for each item
                              direction: DismissDirection.startToEnd,
                              // Swipe direction
                              onDismissed: (direction) {
                                // Remove the exercise from Firestore
                                _removeExercise(exercise['id']);
                                setState(() {
                                  exercises.removeAt(index); // Update the list
                                });
                              },
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Icon(
                                        Icons.delete, color: Colors.white),
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(exercise['activity'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Poppins',
                                    color: mode.isDarkMode ? Colors.white : null,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                    'Duration: ${exercise['duration']} mins',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    color: mode.isDarkMode ? Colors.grey : null,
                                  ),
                                ),
                                trailing: Text(
                                    '${exercise['burnedCalories']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery
                                      .of(context)
                                      .viewInsets
                                      .bottom),
                              child: AddExerciseScreen(),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Removes the border radius
                      ),
                    ),
                    child: Text('Add Exercise',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),),
                  ),
                ),
              ],
            ),
          ),
        );

      }
    );
  }
}

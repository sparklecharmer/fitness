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


  void _removeExercise(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('exercises')
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
          backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F) : Colors.white,
          appBar: AppBar(
            toolbarHeight: 75,
            backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F): Colors.white,
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
                      'exercises')
                      .where('userid',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final exercises = snapshot.data!.docs.map((doc) {
                        return {
                          'id': doc.id,
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
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                _removeExercise(exercise['id']);
                                setState(() {
                                  exercises.removeAt(index);
                                });
                              },
                              background: Container(
                                color: Color(0xFFEC704B),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Icon(
                                        Icons.delete, color: Colors.white),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,0,20.0),
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
                                      '${exercise['burnedCalories']} cal',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      color: Color(0xFFEC704B),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
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
                      backgroundColor: Color(0xFFEC704B),
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

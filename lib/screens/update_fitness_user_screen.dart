import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/fitness_user.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/firebase_calls.dart';

class UpdateFitnessUserScreen extends StatefulWidget {
  const UpdateFitnessUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateFitnessUserScreen> createState() =>
      _UpdateFitnessUserScreenState();
}

class _UpdateFitnessUserScreenState extends State<UpdateFitnessUserScreen> {
  //TODO add gender, age, exercise throughout this screen
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController exerciseController = TextEditingController();
  TextEditingController neckController = TextEditingController();
  TextEditingController waistController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController deficitController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppMode>(
      builder: (context, mode, child) {
        return Scaffold(
          backgroundColor: mode.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: mode.isDarkMode ? Colors.black : Colors.white,
            title: Text(
              'Update',
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
          bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 2),
          body: SafeArea(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: fitnessUsersCollection
                    .where('userid', isEqualTo: auth.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      QueryDocumentSnapshot doc = snapshot.data!.docs[0];
                      weightController.text = doc.get('weight').toString();
                      heightController.text = doc.get('height').toString();
                      genderController.text = doc.get('gender');
                      ageController.text = doc.get('age').toString();
                      exerciseController.text = doc.get('exercise');
                      neckController.text = doc.get('neck').toString();
                      waistController.text = doc.get('waist').toString();
                      goalController.text = doc.get('goal');
                      deficitController.text = doc.get('deficit').toString();
                      goalWeightController.text = doc.get('goalWeight').toString();
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //hello
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,10,20,0),
                        child: Column(
                          children: [
                            TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(labelText: 'Weight', labelStyle: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                                fontWeight: FontWeight.w700,)
                              ),
                              controller: weightController, style: TextStyle(fontSize: 15,
                              fontFamily: 'Poppins',
                              color: mode.isDarkMode ? Colors.white : null,
                             ),
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(labelText: 'Height', labelStyle: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                                fontWeight: FontWeight.w700,)),
                              controller: heightController, style: TextStyle(fontSize: 15,
                              fontFamily: 'Poppins',
                              color: mode.isDarkMode ? Colors.white : null,
                            ),
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(labelText: 'Gender', labelStyle: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                                fontWeight: FontWeight.w700,)),
                              controller: genderController, style: TextStyle(fontSize: 15,
                              fontFamily: 'Poppins',
                              color: mode.isDarkMode ? Colors.white : null,
                            ),
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(labelText: 'Age', labelStyle: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                                fontWeight: FontWeight.w700,)),
                              controller: ageController, style: TextStyle(fontSize: 15,
                              fontFamily: 'Poppins',
                              color: mode.isDarkMode ? Colors.white : null,
                            ),
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelText: 'Exercise', labelStyle: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                                fontWeight: FontWeight.w700,)),
                              controller: exerciseController, style: TextStyle(fontSize: 15,
                              fontFamily: 'Poppins',
                              color: mode.isDarkMode ? Colors.white : null,
                            ),
                            ),

                          ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,30,0,30),
                        child: Text("Optional",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: mode.isDarkMode ? Colors.white : null,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),



                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,0,20,0),
                        child: Column(
                            children: [
                              TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(labelText: 'Neck', labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  color: mode.isDarkMode ? Colors.white : null,
                                  fontWeight: FontWeight.w700,)
                                ),
                                controller: neckController, style: TextStyle(fontSize: 15,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                              ),
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(labelText: 'Waist', labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  color: mode.isDarkMode ? Colors.white : null,
                                  fontWeight: FontWeight.w700,)),
                                controller: waistController, style: TextStyle(fontSize: 15,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                              ),
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(labelText: 'Goal', labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  color: mode.isDarkMode ? Colors.white : null,
                                  fontWeight: FontWeight.w700,)),
                                controller: goalController, style: TextStyle(fontSize: 15,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                              ),
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(labelText: 'Deficit', labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  color: mode.isDarkMode ? Colors.white : null,
                                  fontWeight: FontWeight.w700,)),
                                controller: deficitController, style: TextStyle(fontSize: 15,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                              ),
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    labelText: 'Goal Weight', labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  color: mode.isDarkMode ? Colors.white : null,
                                  fontWeight: FontWeight.w700,)),
                                controller: goalWeightController, style: TextStyle(fontSize: 15,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                              ),
                              ),

                            ]
                        ),
                      ),

                      // TODO: allow OPTIONAL stats as defined in fitness_user.dart
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,20,0,0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // Removes the border radius
                            ),
                          ),
                          child: const Text('Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),),
                          onPressed: () async {
                            fitnessUser = FitnessUser(
                                weight: int.parse(weightController.text),
                                height: int.parse(heightController.text),
                                gender: genderController.text,
                                age: int.parse(ageController.text),
                                exercise: exerciseController.text,
                              neck: int.parse(neckController.text),
                              waist: int.parse(waistController.text),
                              goal: goalController.text,
                              deficit: int.parse(deficitController.text),
                              goalWeight: int.parse(goalWeightController.text)

                            );
                            await FirebaseCalls().updateFitnessUser(fitnessUser);
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

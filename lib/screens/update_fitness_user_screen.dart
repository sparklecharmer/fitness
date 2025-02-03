import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F) : Colors.white,
          appBar: AppBar(
            toolbarHeight: 75,
            backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F) : Colors.white,
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
                            TextFieldWidget(controller: weightController, keyboard: TextInputType.number, placeholder: "Enter your weight in kg", color: mode.isDarkMode, title: "Weight",),
                            TextFieldWidget(controller: heightController, keyboard: TextInputType.number, placeholder: "Enter your height in cm", color: mode.isDarkMode, title: "Height",),
                            TextFieldWidget(controller: genderController, keyboard: TextInputType.text ,placeholder: "Enter your gender (Male/Female)", color: mode.isDarkMode, title: "Gender",),
                            TextFieldWidget(controller: ageController, keyboard: TextInputType.number,placeholder: "Enter your age in years", color: mode.isDarkMode, title: "Age",),
                            TextFieldWidget(controller: exerciseController, keyboard: TextInputType.text,placeholder: "Enter exercise level (e.g., little)", color: mode.isDarkMode, title: "Exercise",),
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
                              TextFieldWidget(controller: neckController, keyboard: TextInputType.number, placeholder: "Enter neck circumference in cm", color: mode.isDarkMode, title: "Neck",),
                              TextFieldWidget(controller: waistController, keyboard: TextInputType.number, placeholder: "Enter waist circumference in cm", color: mode.isDarkMode, title: "Waist",),
                              TextFieldWidget(controller: goalController,keyboard: TextInputType.text, placeholder: "Enter goal (e.g., maintenance)", color: mode.isDarkMode, title: "Goal",),
                              TextFieldWidget(controller: goalWeightController,keyboard: TextInputType.number, placeholder: "Enter your target weight in kg", color: mode.isDarkMode, title: "Goal Weight",),
                              TextFieldWidget(controller: deficitController,keyboard: TextInputType.number, placeholder: "Enter daily calorie deficit", color: mode.isDarkMode, title: "Deficit",),

                            ]
                        ),
                      ),


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
                              neck: neckController.text.isEmpty ? 0 : int.parse(neckController.text),
                              waist: waistController.text.isEmpty ? 0 : int.parse(waistController.text),
                              deficit: deficitController.text.isEmpty ? 0 : int.parse(deficitController.text),
                              goalWeight: goalWeightController.text.isEmpty ? 0 : int.parse(goalWeightController.text),
                              goal: goalController.text.isEmpty ? "maintenance" : goalController.text,

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

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.color,
    required this.title,
    required this.placeholder,
    required this.keyboard,
  });



  final String placeholder;
  final bool color;
  final TextInputType keyboard;
  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(labelText: title, labelStyle: TextStyle(
        fontSize: 17,
        fontFamily: 'Poppins',
        color: color ? Colors.white : null,
        fontWeight: FontWeight.w700,),
        hintText: placeholder,  // <-- Placeholder text
        hintStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Poppins',
          color: Colors.grey,  // Placeholder text color
        ),
      ),
      keyboardType: keyboard,
      controller: controller, style: TextStyle(fontSize: 15,
      fontFamily: 'Poppins',
      color: color ? Colors.white : null,
     ),
    );
  }
}

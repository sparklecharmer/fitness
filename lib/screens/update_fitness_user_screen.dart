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

  String? _validateInputs() {
    if (weightController.text.isEmpty ||
        heightController.text.isEmpty ||
        genderController.text.isEmpty ||
        ageController.text.isEmpty ||
        exerciseController.text.isEmpty) {
      return "All required fields must be filled.";
    }

    int? weight = int.tryParse(weightController.text);
    if (weight == null || weight < 50 || weight > 500) {
      return "Weight must be a number between 50 and 500 kg.";
    }

    int? height = int.tryParse(heightController.text);
    if (height == null || height <= 0) {
      return "Height must be a valid number.";
    }

    int? age = int.tryParse(ageController.text);
    if (age == null || age <= 0) {
      return "Age must be a valid number.";
    }

    return null;
  }

  final List<String> exerciseLevels = [
    "little",
    "light",
    "moderate",
    "heavy",
  ];

  final List<String> genderOptions = [
    "male",
    "female",
  ];

  final List<String> goalOptions = [
    "fatloss_moderate",
    "fatloss_aggressive",
    "fatloss_reckless",
    "maintenance",
    "bulking_slow",
    "bulking_normal",
    "bulking_aggressive",
  ];


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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldWidget(controller: weightController, keyboard: TextInputType.number, placeholder: "Enter your weight in kg", color: mode.isDarkMode, title: "Weight",),
                            TextFieldWidget(controller: heightController, keyboard: TextInputType.number, placeholder: "Enter your height in cm", color: mode.isDarkMode, title: "Height",),
                            Text("Gender", style: TextStyle(color: mode.isDarkMode ? Colors.white : null),),
                            SizedBox(height: 5,),
                            DropdownWidget(
                                list: genderOptions,
                                txtcontroller: genderController,
                                color: mode.isDarkMode,
                                prompt: "Select Gender"
                            ),
                            // AutocompleteWidget(list: genderOptions, txtcontroller: genderController, color: mode.isDarkMode, prompt: 'Enter your gender',),
                            TextFieldWidget(controller: ageController, keyboard: TextInputType.number,placeholder: "Enter your age in years", color: mode.isDarkMode, title: "Age",),
                            Text("Exercise", style: TextStyle(color: mode.isDarkMode ? Colors.white : null),),
                            SizedBox(height: 5,),
                            DropdownWidget(
                                list: exerciseLevels,
                                txtcontroller: exerciseController,
                                color: mode.isDarkMode,
                                prompt: "Select Exercise Level"
                            ),
                          //   AutocompleteWidget(list: exerciseLevels, txtcontroller: exerciseController, color: mode.isDarkMode, prompt: 'Enter exercise level',),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldWidget(controller: neckController, keyboard: TextInputType.number, placeholder: "Enter neck circumference in cm", color: mode.isDarkMode, title: "Neck",),
                              TextFieldWidget(controller: waistController, keyboard: TextInputType.number, placeholder: "Enter waist circumference in cm", color: mode.isDarkMode, title: "Waist",),
                              Text("Goal", style: TextStyle(color: mode.isDarkMode ? Colors.white : null),),
                              SizedBox(height: 5,),
                              DropdownWidget(
                                  list: goalOptions,
                                  txtcontroller: goalController,
                                  color: mode.isDarkMode,
                                  prompt: "Select Goal"
                              ),
                              // AutocompleteWidget(list: goalOptions, txtcontroller: goalController, color: mode.isDarkMode, prompt: 'Enter a goal',),
                              TextFieldWidget(controller: goalWeightController,keyboard: TextInputType.number, placeholder: "Enter your target weight in kg", color: mode.isDarkMode, title: "Goal Weight",),
                              TextFieldWidget(controller: deficitController, keyboard: TextInputType.number, placeholder: "Enter daily calorie deficit", color: mode.isDarkMode, title: "Deficit",),

                            ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: Color(0xFFEC704B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () async {

                            String? errorMessage = _validateInputs();

                            if (errorMessage != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Invalid Input"),
                                    content: Text(errorMessage),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }

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



class DropdownWidget extends StatelessWidget {
  const DropdownWidget({
    super.key,
    required this.list,
    required this.txtcontroller,
    required this.color,
    required this.prompt
  });

  final List<String> list;
  final TextEditingController txtcontroller;
  final bool color;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: DropdownButtonFormField<String>(
        value: list.contains(txtcontroller.text) ? txtcontroller.text : null,
        items: list.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                textAlign: TextAlign.center,
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: color ? Colors.white : null,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            txtcontroller.text = newValue;
          }
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
            fontSize: 17,
            fontFamily: 'Poppins',
            color: color ? Colors.white : null,
            fontWeight: FontWeight.w700,
          ),
          hintText: prompt,
          hintStyle: TextStyle(
            fontSize: 15,
            fontFamily: 'Poppins',
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
        dropdownColor: color ? Color(0xFF2F2F2F) : Colors.white,
        alignment: Alignment.center,
      ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color ? Colors.white : null),),
          SizedBox(height: 5,),
          TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.never, labelStyle: TextStyle(
            fontSize: 17,
            fontFamily: 'Poppins',
            color: color ? Colors.white : null,
            fontWeight: FontWeight.w700,),
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              )
          ),
          keyboardType: keyboard,
          controller: controller, style: TextStyle(fontSize: 15,
          fontFamily: 'Poppins',
          color: color ? Colors.white : null,
        ),
        )
        ],
      ),
    );
  }
}


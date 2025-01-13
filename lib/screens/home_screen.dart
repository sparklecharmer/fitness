import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/bmi.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final apiCalls = ApiCalls();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppMode>(
      builder: (context, mode, child) {
        return Scaffold(
          backgroundColor: mode.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: mode.isDarkMode ? Colors.black : Colors.white,
            title: Text(
              'Planet Fitness',
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
          bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
          body: SafeArea(
            child: FutureBuilder<Bmi>(
              future: apiCalls.fetchBmi(fitnessUser),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final Bmi bmi = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${auth.currentUser?.displayName}',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            color: mode.isDarkMode ? Colors.white : null,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Body Metrics",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: mode.isDarkMode ? Colors.white : null,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Card(
                                color: mode.isDarkMode
                                    ? Color(0xFFD9D7C0)
                                    : Color(0xFFF5F5DC),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(60, 60, 60, 60),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${bmi.bmi}',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'BMI',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: mode.isDarkMode
                                    ? Color(0xFF87D7E1)
                                    : Color(0xFFB3EBF2),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(50, 60, 50, 60),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${bmi.bmiConclusion}',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Weight',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: mode.isDarkMode
                                    ? Color(0xFF988CC3)
                                    : Color(0xFFC3B1E1),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(50, 60, 50, 60),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${bmi.bodyFatPercent}%',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Body Fat',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Health & Goals",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: mode.isDarkMode ? Colors.white : null,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Card(
                                color: mode.isDarkMode
                                    ? Color(0xFFE3E378)
                                    : Color(0xFFFDFD96),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(50, 60, 50, 60),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${bmi.idealBodyWt} kg',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Ideal Body Weight',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: mode.isDarkMode
                                    ? Color(0xFFF4A6B2)
                                    : Color(0xFFFFD1DC),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(50, 60, 50, 60),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${bmi.totalDailyEE}',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Total Daily EE',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        );
      },
    );
  }
}

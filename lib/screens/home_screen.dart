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
          backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F) : Colors.white,
          appBar: AppBar(
            backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F) : Colors.white,
            title: Text(
              'Planet Fitness',
              style: TextStyle(
                fontSize: 30,
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
          body: SingleChildScrollView(
            child: SafeArea(
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
                              fontSize: 36,
                              color: mode.isDarkMode ? Colors.white : null,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          Text(
                            '${auth.currentUser?.displayName}',
                            style: TextStyle(
                              fontSize: 36,
                              fontFamily: 'Poppins',
                              color: mode.isDarkMode ? Colors.white : null,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 30),

                          Text(
                            "Body Metrics",
                            style: TextStyle(
                              fontSize: 28,
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
                                CardWidget(stat: bmi.bmi.toString(), unit: "kg/m²", title: 'BMI', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                                CardWidget(stat: bmi.bmiConclusion, unit: "", title: 'Conclusion', color: mode.isDarkMode, lightColor: Color(0xFFDDC1FF), darkColor: Color(0xFFDDC1FF)),
                                CardWidget(stat: bmi.bodyFatPercent.toString(), unit: "%", title: 'Body Fat', color: mode.isDarkMode, lightColor: Color(0xFFEC704B), darkColor: Color(0xFFEC704B))
                                ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Energy Expenditure",
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: mode.isDarkMode ? Colors.white : null,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CardWidget(stat: bmi.totalDailyEE.toString(), unit: "kcal/day", title: 'Total Daily', color: mode.isDarkMode, lightColor: Color(0xFFDDC1FF), darkColor: Color(0xFFDDC1FF)),
                                CardWidget(stat: bmi.restingDailyEE.toString(), unit: "kcal/day", title: 'Resting Daily', color: mode.isDarkMode, lightColor: Color(0xFFEC704B), darkColor: Color(0xFFEC704B)),
            
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Health & Goals",
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: mode.isDarkMode ? Colors.white : null,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CardWidget(stat: bmi.idealBodyWt.toString(), unit: "kg", title: 'Ideal Body Weight', color: mode.isDarkMode, lightColor: Color(0xFFEC704B), darkColor: Color(0xFFEC704B)),
                                CardWidget(stat: bmi.leanBodyMass.toString(), unit: "kg", title: 'Lean Body Mass', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
            
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
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
          ),
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.stat,
    required this.color,
    required this.lightColor,
    required this.darkColor,
    required this.title,
    required this.unit,

  });

  final String unit;
  final String title;
  final String stat;
  final bool color;
  final Color lightColor;
  final Color darkColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ? darkColor : lightColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: 170,
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Spread items out
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${stat} ${unit}',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
             // Fills space between title and stat
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF1A1A1A),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

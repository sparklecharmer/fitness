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
            toolbarHeight: 75,
            backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F) : Colors.white,
            title: Row(
              children: [
                Image.asset('images/ball2.png',width: 50,  // Set the width
                  height: 50, // Set the height
                  fit: BoxFit.cover,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(13.0,0,0,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Planet",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 2.0,
                            fontFamily: 'logik',
                            color: mode.isDarkMode ? Colors.white : null,
                            fontWeight: FontWeight.w700,

                          ),
                      ),
                      Text("Fitness",
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2.0,
                          fontFamily: 'logik',
                          color: mode.isDarkMode ? Colors.white : null,
                          fontWeight: FontWeight.w700,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // title: Text(
            //   'Planet Fitness',
            //   style: TextStyle(
            //     fontSize: 32,
            //     letterSpacing: 2.0,
            //     fontFamily: 'logik',
            //     color: mode.isDarkMode ? Colors.white : null,
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),

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
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),  // Adjust left padding as needed
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,  // Aligns the text to the left
                              children: [
                                SizedBox(height: 15,),
                                Text(
                                  "Hello,",
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: mode.isDarkMode ? Colors.white : null,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0.8,
                                  ),
                                ),
                                Text(
                                  '${auth.currentUser?.displayName}',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFDDC1FF),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                            child: Text(
                              "Body Metrics",
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'Poppins',
                                color: mode.isDarkMode ? Colors.white : null,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CardWidget(stat: bmi.bmi.toString(), unit: "kg/m²", fontSize: 40, title: 'BMI', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                                CardWidget(stat: bmi.bmiConclusion, unit: "", fontSize: 27, title: 'Conclusion', color: mode.isDarkMode, lightColor: Color(0xFFDDC1FF), darkColor: Color(0xFFDDC1FF)),
                                CardWidget(stat: bmi.bodyFatPercent.toString(), fontSize: 40, unit: "%", title: 'Body Fat', color: mode.isDarkMode, lightColor: Color(0xFFEC704B), darkColor: Color(0xFFEC704B))
                                ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                            child: Text(
                              "Energy Expenditure",
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: mode.isDarkMode ? Colors.white : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CardWidget(stat: bmi.totalDailyEE.toString(), fontSize: 40, unit: "kcal/day", title: 'Total Daily', color: mode.isDarkMode, lightColor: Color(0xFFDDC1FF), darkColor: Color(0xFFDDC1FF)),
                                CardWidget(stat: bmi.restingDailyEE.toString(), fontSize: 40, unit: "kcal/day", title: 'Resting Daily', color: mode.isDarkMode, lightColor: Color(0xFFEC704B), darkColor: Color(0xFFEC704B)),
            
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                            child: Text(
                              "Health & Goals",
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: mode.isDarkMode ? Colors.white : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CardWidget(stat: bmi.idealBodyWt.toString(), fontSize: 40, unit: "kg", title: 'Ideal Body Weight', color: mode.isDarkMode, lightColor: Color(0xFFEC704B), darkColor: Color(0xFFEC704B)),
                                CardWidget(stat: bmi.leanBodyMass.toString(), fontSize: 40, unit: "kg", title: 'Lean Body Mass', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
            
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
    required this.fontSize,

  });

  final double fontSize;
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
          width: 210,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Spread items out
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${stat}',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF292B2D),

                    ),
                  ),
                  Text('${unit}',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      height: 0.8,
                    ),
                  ),

                ],
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

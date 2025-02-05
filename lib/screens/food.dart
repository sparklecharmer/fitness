import 'package:fitness/models/nutrition.dart';
import 'package:fitness/screens/add_food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';

class FoodNutrition extends StatefulWidget {
  const FoodNutrition({super.key});

  @override
  State<FoodNutrition> createState() => _FoodNutritionState();
}

class _FoodNutritionState extends State<FoodNutrition> {

  final apiCalls = ApiCalls();
  String food = 'chicken rice';


  @override
  Widget build(BuildContext context) {
    return Consumer<AppMode>(
      builder: (context, mode, child){
        return Scaffold(
          backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F) : Colors.white,
          appBar: AppBar(
            toolbarHeight: 75,
            backgroundColor: mode.isDarkMode ? Color(0xFF2F2F2F): Colors.white,
            title: Text(
              'Food',
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
          bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 3),
          body: SingleChildScrollView(
            child: SafeArea(
                child: FutureBuilder(
                    future: apiCalls.fetchNutrition(food),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final Nutrition nutrition = snapshot.data!;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(28.0,0,0,0),
                              child: Text(nutrition.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 36,
                                  color: mode.isDarkMode ? Colors.white : null,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  height: 0.8,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(28,0,0,0),
                              child: Text(
                                "Macronutrients",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: 'Poppins',
                                  color: mode.isDarkMode ? Colors.white : null,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),

                            CardWidget(icon: Icons.water_drop, stat: nutrition.totalFat.toString(), unit: "gram", fontSize: 20, title: 'Total Fat', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                            CardWidget(icon: Icons.oil_barrel, stat: nutrition.saturatedFat.toString(), unit: "gram", fontSize: 20, title: 'Saturated Fat', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                            CardWidget(icon: Icons.bakery_dining, stat: nutrition.totalCarbohydrates.toString(), unit: "gram", fontSize: 20, title: 'Total Carbohydrates', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                            CardWidget(icon: Icons.icecream, stat: nutrition.sugar.toString(), unit: "gram", fontSize: 20, title: 'Sugar', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                            CardWidget(icon: Icons.grass, stat: nutrition.fiber.toString(), unit: "gram", fontSize: 20, title: 'Fiber', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),

                            SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(28,0,0,0),
                              child: Text(
                                "Electrolytes & Minerals",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: 'Poppins',
                                  color: mode.isDarkMode ? Colors.white : null,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            CardWidget(icon: Icons.favorite, stat: nutrition.cholesterol.toString(), unit: "miligram", fontSize: 20, title: 'Cholesterol', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                            CardWidget(icon: Icons.eco, stat: nutrition.potassium.toString(), unit: "miligram", fontSize: 20, title: 'Potassium', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                            CardWidget(icon: Icons.scatter_plot, stat: nutrition.sodium.toString(), unit: "miligram", fontSize: 20, title: 'Sodium', color: mode.isDarkMode, lightColor: Color(0xFFF5F378), darkColor: Color(0xFFF5F378)),
                            SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final String? typedName = await showModalBottomSheet<String>(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: AddFoodScreen(),
                                        ),
                                      );
                                    },
                                  );

                                  if (typedName != null && typedName.isNotEmpty) {
                                    setState(() {
                                      food = typedName;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  backgroundColor: Color(0xFFEC704B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Removes the border radius
                                  ),
                                ),
                                child: Text("Check Food",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    }

                )
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
    required this.icon,

  });
  final IconData icon;
  final double fontSize;
  final String unit;
  final String title;
  final String stat;
  final bool color;
  final Color lightColor;
  final Color darkColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ? Colors.white : null, size: 30,),
      title: Text(title, style: TextStyle(fontSize: fontSize, fontFamily: "Poppins", color: color ? Colors.white : null),),
      subtitle: Text(stat, style: TextStyle(fontFamily: "Poppins", fontSize: fontSize, color: color ? Colors.white : null),),
      trailing: Text(unit, style: TextStyle(fontFamily: "Poppins", fontSize: fontSize, color: color ? Colors.white : null),),
    );

  }
}

import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness'),
        actions: [
          IconButton(
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
        child: Column(
          children: [
            FutureBuilder<Bmi>(
              future: apiCalls.fetchBmi(fitnessUser),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final Bmi bmi = snapshot.data!;
                  return Column(
                    children: [
                      Text('Welcome ${auth.currentUser?.displayName}'),
                      Text('Your BMI is ${bmi.bmi}'),
                      Text('You are ${bmi.bmiConclusion}'),
                      Text('Ideal body weight is ${bmi.idealBodyWt}'),
                      Text('Body fat is ${bmi.bodyFatPercent}'),
                      Text('Total daily energy expenditure is who knows? you are fat'),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
              },
            ),

            //TODO widget to show show bmi, bmiConclusion, ideal body weight, body fat and daily energy expenditure
          ],
        ),
      ),
    );
  }
}

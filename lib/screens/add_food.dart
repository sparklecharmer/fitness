import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/api_calls.dart';
import '../main.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  TextEditingController foodController = TextEditingController();
  final apiCalls = ApiCalls();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppMode>(
      builder: (context, mode, child) {
        return Container(
          color: mode.isDarkMode ? const Color(0xFF2F2F2F) : Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                'Check New Food',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: mode.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Text("Food", style: TextStyle(color: mode.isDarkMode ? Colors.white : null),),
              SizedBox(height: 5,),
              TextField(
                style: TextStyle(color: mode.isDarkMode ? Colors.white : null),
                textAlign: TextAlign.center,
                controller: foodController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: 'Enter food (e.g., Egg)',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC704B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'Check',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () async {
                  String foodName = foodController.text.trim();

                  if (foodName.isEmpty) {
                    setState(() {
                      errorMessage = 'Please enter a food name';
                    });
                    return;
                  }

                  final foodData = await apiCalls.fetchNutrition(foodName);

                  if (foodData == null) {
                    setState(() {
                      errorMessage = 'Food not found. Try again.';
                    });
                  } else {
                    setState(() {
                      errorMessage = null;
                    });
                    Navigator.pop(context, foodName);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

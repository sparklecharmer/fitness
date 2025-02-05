import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/api_calls.dart'; // Import API calls
import '../main.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  TextEditingController foodController = TextEditingController();
  final apiCalls = ApiCalls(); // Initialize API call instance
  String? errorMessage; // Store error message for invalid input

  @override
  Widget build(BuildContext context) {
    return Consumer<AppMode>(
      builder: (context, mode, child) {
        return Container(
          color: mode.isDarkMode ? const Color(0xFF2F2F2F) : Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // Adjusts height to content
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
              TextField(
                controller: foodController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Food',
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

              // Error message text (only visible when errorMessage is not null)
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

                  // Check if the food exists using API
                  final foodData = await apiCalls.fetchNutrition(foodName);

                  if (foodData == null) {
                    setState(() {
                      errorMessage = 'Food not found. Try again.';
                    });
                  } else {
                    setState(() {
                      errorMessage = null; // Clear error if food is found
                    });
                    Navigator.pop(context, foodName); // Return valid food name
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

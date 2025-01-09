import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppMode>(
      builder: (context, AppMode mode, child) {
        return Scaffold(
          backgroundColor: mode.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: mode.isDarkMode ? Colors.black : Colors.white,
            title: Text(
              'Settings',
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
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Row(
                children: [
                  Text("Toggle Theme: ", style: TextStyle(
                    color: mode.isDarkMode ? Colors.white : null,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  ),
                  Switch(
                    value: mode.isDarkMode,
                    onChanged: (newValue) {
                      mode.toggleMode(); // Call the method to toggle the mode
                    },
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

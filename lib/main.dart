import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import '../screens/settings_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/exercise_screen.dart';
import '../screens/update_fitness_user_screen.dart';

// Your AppMode class (state management for theme)
class AppMode extends ChangeNotifier {
  bool _isDarkMode = false;

  // Getter for the current mode
  bool get isDarkMode => _isDarkMode;

  // Method to toggle the mode
  void toggleMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners when the mode changes
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppMode(), // Provide AppMode here
      child: Builder(
        builder: (context) {
          // Wrap MaterialApp inside Builder to access AppMode context for theme switching

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/exercise': (context) => const ExerciseScreen(),
              '/user': (context) => const UpdateFitnessUserScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}

import 'package:fitness/screens/food.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import '../screens/settings_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/exercise_screen.dart';
import '../screens/update_fitness_user_screen.dart';


class AppMode extends ChangeNotifier {

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
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
      create: (context) => AppMode(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/exercise': (context) => const ExerciseScreen(),
              '/user': (context) => const UpdateFitnessUserScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/nutrition': (context) => const FoodNutrition(),
            },
          );
        },
      ),
    );
  }
}

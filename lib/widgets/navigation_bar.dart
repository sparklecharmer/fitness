import 'package:fitness/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({Key? key, required this.selectedIndexNavBar})
      : super(key: key);
  int selectedIndexNavBar;

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  void _onTap(int index) {
    widget.selectedIndexNavBar = index;
    setState(() {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/exercise');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/user');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/settings');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppMode>(
      builder: (context, mode, child) {
        return BottomNavigationBar(
          backgroundColor: mode.isDarkMode ? Color(0xFF1a1a1a) : Colors.white,
          selectedItemColor: mode.isDarkMode ? Colors.white : Colors.black,
          unselectedItemColor: mode.isDarkMode ? Colors.grey : Colors.black54,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Exercise',
              icon: Icon(Icons.directions_run),
            ),
            BottomNavigationBarItem(
              label: 'User',
              icon: Icon(Icons.person),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
          currentIndex: widget.selectedIndexNavBar,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
        );
      }
    );
  }
}
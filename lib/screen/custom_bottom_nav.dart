import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'explore.dart';
import 'analytics.dart';
import 'schedule.dart';
import 'settings.dart';
import 'profile.dart';



class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int, Widget) onTap; // ✅ required parameter

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
      backgroundColor: Colors.black.withAlpha(100),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        Widget page;
        switch (index) {
          case 0:
            page = const HomeScreen();
            break;
          case 1:
            page = const DevicesTab();
            break;
          case 2:
            page = const AnalyticsScreen();
            break;
          case 3:
            page = const EnergySchedulingScreen();
            break;
          case 4:
            page = const EnergySettingScreen();
            break;
          case 5:
            page = const EnergyProfileScreen();
            break;
          default:
            page = const HomeScreen();
        }
        onTap(index, page); // ✅ calls back
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Energy'),
        BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Devices'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Analytics'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

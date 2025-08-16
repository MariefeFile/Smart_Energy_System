import 'package:flutter/material.dart';
import '../main.dart'; // For AnimatedBackground & BackgroundShapes
import 'admin_home.dart';
import 'explore.dart';
import 'analytics.dart';
import 'schedule.dart';
import 'profile.dart';

class EnergySettingScreen extends StatefulWidget {
  const EnergySettingScreen({super.key});

  @override
  State<EnergySettingScreen> createState() => _EnergySchedulingScreenState();
}

class _EnergySchedulingScreenState extends State<EnergySettingScreen> {
  bool _isDarkMode = false;
  int _currentIndex = 4; // Current tab: Schedule

  void _onTabTapped(int index) {
  if (index == _currentIndex) return; // ✅ Prevents reloading the same tab

  setState(() => _currentIndex = index);

  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  } else if (index == 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ExploreTab()),
    );
  } else if (index == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
    );
  } else if (index == 3) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EnergySchedulingScreen()),
    );
  }else if (index == 4) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EnergySettingScreen()),
    );
  } else if (index == 5) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EnergyProfileScreen()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          const Positioned.fill(child: BackgroundShapes()),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.white.withAlpha((255 * 0.8).toInt()),
                elevation: 0,
                title: const Text(
                  'Setting Update',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.add, color: Colors.teal),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.teal),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Colors.teal,
                    ),
                    onPressed: () {
                      setState(() {
                        _isDarkMode = !_isDarkMode;
                      });
                    },
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      summaryCard('Next Scheduled Task', '10:30 AM', 'Today'),
                      const SizedBox(height: 16),
                      breakdownTile(Icons.bolt, 'Lighting', '3.5 kWh', 0.7),
                      breakdownTile(Icons.kitchen, 'Kitchen', '2.1 kWh', 0.4),
                      breakdownTile(Icons.ac_unit, 'Air Conditioning', '5.0 kWh', 0.9),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black.withAlpha((255 * 0.4).toInt()),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Energy'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget summaryCard(String title, String value, String change) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(change, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  Widget breakdownTile(
    IconData icon,
    String label,
    String value,
    double percent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                LinearProgressIndicator(
                  value: percent,
                  color: Colors.greenAccent,
                  backgroundColor: Colors.white.withAlpha((0.3 * 255).toInt()),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

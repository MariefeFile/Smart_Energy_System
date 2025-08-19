import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'explore.dart';
import 'analytics.dart';
import 'schedule.dart';
import 'settings.dart';

class EnergyProfileScreen extends StatefulWidget {
  const EnergyProfileScreen({super.key});

  @override
  State<EnergyProfileScreen> createState() => _EnergyProfileScreenState();
}

class _EnergyProfileScreenState extends State<EnergyProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isDarkMode = false;
  int _currentIndex = 5; // Profile tab
  final List<String> energyTips = [
    "Turn off lights when not in use.",
    "Use energy-efficient appliances.",
    "Reduce standby power consumption.",
    "Schedule high-energy tasks at night.",
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ExploreTab()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const EnergySchedulingScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const EnergySettingScreen()));
        break;
      case 5:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _isDarkMode ? Colors.grey[900] : const Color(0xFF1a2332);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: backgroundColor,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _profileHeader(),
                    const SizedBox(height: 20),
                    _energySummaryCards(),
                    const SizedBox(height: 20),
                    _quickActions(),
                    const SizedBox(height: 20),
                    _achievements(),
                    const SizedBox(height: 20),
                    _energyTips(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black.withAlpha((255 * 0.4).toInt()),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Energy'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha((255 * 0.8).toInt()),
      elevation: 0,
      title: const Text(
        'Profile',
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      leading: const Icon(Icons.menu, color: Colors.teal),
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
    );
  }

  // Unified box style function
  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: boxDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.teal,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Marie Fe Tapales",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text("Energy Saver Level: 3",
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.6,
                  color: Colors.greenAccent,
                  backgroundColor: Colors.white24,
                  minHeight: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _energySummaryCards() {
    return Column(
      children: [
        _energyCard("Lighting", "3.5 kWh", 0.7, Colors.yellow),
        const SizedBox(height: 12),
        _energyCard("Kitchen", "2.1 kWh", 0.4, Colors.orange),
        const SizedBox(height: 12),
        _energyCard("Air Conditioning", "5.0 kWh", 0.9, Colors.blue),
      ],
    );
  }

  Widget _energyCard(String label, String value, double percent, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.3),
            child: Icon(Icons.bolt, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percent,
                  color: color,
                  backgroundColor: Colors.white24,
                  minHeight: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionButton(Icons.lightbulb, 'Lights', Colors.yellow),
        _actionButton(Icons.schedule, 'Schedule', Colors.blue),
        _actionButton(Icons.power, 'All Off', Colors.red),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: boxDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _achievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Achievements",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _badge(Icons.star, "Eco Star"),
            _badge(Icons.emoji_events, "Energy Hero"),
            _badge(Icons.leaderboard, "Top Saver"),
          ],
        )
      ],
    );
  }

  Widget _badge(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: boxDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Icon(icon, color: Colors.yellowAccent, size: 28),
          ),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _energyTips() {
    final tip = (energyTips..shuffle()).first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration(),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.yellow),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

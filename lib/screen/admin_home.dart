import 'package:flutter/material.dart';
import 'analytics.dart';
import 'explore.dart';
import 'schedule.dart';
import 'settings.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1a2332),
                  Color(0xFF0f1419),
                ],
              ),
            ),
          ),

          // ✅ Main content
          Column(
            children: [
              // Custom Top AppBar
              SafeArea(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((255 * 0.8).toInt()),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((255 * 0.1).toInt()),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.add, color: Colors.teal),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Smart Energy System',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
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
                ),
              ),

              // Dashboard content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _currentEnergyCard()),
                          const SizedBox(width: 12),
                          _solarProductionCard(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _energyConsumptionChart(),
                      const SizedBox(height: 16),
                      _connectedDevicesSection(),
                      const SizedBox(height: 16),
                      _energyTipsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // 🔹 Bottom Navigation
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
      backgroundColor: Colors.black.withAlpha((255 * 0.4).toInt()),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        Widget page;
        switch (index) {
          case 0:
            page = const HomeScreen();
            break;
          case 1:
            page = const ExploreTab();
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Energy'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Analytics'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  // 🔹 Dashboard Cards & Sections
  Widget _currentEnergyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Current Energy Usage', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 8),
                Text('24.8 kWh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                Text('+2.5% less than yesterday', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  value: 0.7,
                  color: Colors.greenAccent,
                  backgroundColor: Colors.white24,
                  strokeWidth: 6,
                ),
              ),
              const Text('70%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _solarProductionCard() {
  return Container(
    width: 130,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Consumption',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70, // text color for dark background
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '8.2 kWh',
          style: TextStyle(
            fontSize: 18,
            color: Colors.tealAccent, // brighter text on dark background
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: 0.7,
          backgroundColor: Colors.white24, // subtle background
          color: Colors.orangeAccent, // stands out on dark background
        ),
        const SizedBox(height: 4),
        const Text(
          'Consume hours: 5.2 hrs',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}

  // 🔹 Updated Energy Consumption Chart
// 🔹 Updated Energy Consumption Chart (Dark Gradient Style)
Widget _energyConsumptionChart() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Energy Consumption',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
            ),
            Row(
              children: [
                _filterButton('Today', isActive: true),
                const SizedBox(width: 6),
                _filterButton('Week'),
                const SizedBox(width: 6),
                _filterButton('Month'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white24, // lighter overlay for chart area
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
              child: Text(
            'Graph Placeholder',
            style: TextStyle(color: Colors.white70),
          )),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('12 AM', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('3 AM', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('6 AM', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('9 AM', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('12 PM', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('3 PM', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('6 PM', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('9 PM', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('12 AM', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Peak Usage',
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('3.8 kWh at 3:15 PM',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Lowest Usage',
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('0.8 kWh at 4:00 AM',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


// 🔹 Filter Button for Energy Chart (Dark Gradient Style)
Widget _filterButton(String label, {bool isActive = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      gradient: isActive
          ? const LinearGradient(
              colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : const LinearGradient(
              colors: [Color(0xFF2c3e50), Color(0xFF1c2833)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: isActive ? Colors.white : Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}
// 🔹 Connected Devices Section
Widget _connectedDevicesSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Connected Devices',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _deviceTile(Icons.lightbulb, 'Smart Light', 'Living Room - Online'),
      const SizedBox(height: 8),
      _deviceTile(Icons.ac_unit, 'Air Conditioner', 'Bedroom - Offline'),
      const SizedBox(height: 8),
      _deviceTile(Icons.tv, 'Smart TV', 'Living Room - Online'),
    ],
  );
}

Widget _deviceTile(IconData icon, String title, String status) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.tealAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              Text(status,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white70)),
            ],
          ),
        ),
      ],
    ),
  );
}

// 🔹 Energy Tips Section
Widget _energyTipsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Energy Savings Tips',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _tipTile(Icons.check_circle, 'Optimize AC Usage', 'Set to 24°C could save 15%'),
      const SizedBox(height: 8),
      _tipTile(Icons.schedule, 'Solar Power Hours', 'Use heavy appliances 10AM - 2PM'),
    ],
  );
}

Widget _tipTile(IconData icon, String title, String subtitle) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.tealAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white70)),
            ],
          ),
        ),
      ],
    ),
  );
}

}

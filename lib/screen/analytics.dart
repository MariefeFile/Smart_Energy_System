import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartenergy_app/screen/explore.dart';
import 'package:smartenergy_app/screen/schedule.dart';
import 'package:smartenergy_app/screen/settings.dart';
import 'package:smartenergy_app/screen/profile.dart';
import 'package:smartenergy_app/screen/admin_home.dart';
import 'package:smartenergy_app/main.dart'; // For AnimatedBackground & BackgroundShapes

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isDarkMode = false;

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
                  'Smart Energy System',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Analytics',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: summaryCard(
                              'Total Consumption',
                              '167.9 kWh',
                              '+4.2%',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: summaryCard('Cost', '\$31.58', '+16.5%'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Energy Usage',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(height: 200, child: lineChart()),
                      const SizedBox(height: 24),
                      const Text(
                        'Usage Breakdown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      breakdownTile(Icons.ac_unit, 'Cooling', '78.1 kWh', 0.46),
                      breakdownTile(
                        Icons.lightbulb_outline,
                        'Lighting',
                        '58.7 kWh',
                        0.34,
                      ),
                      breakdownTile(Icons.power, 'Other', '33.8 kWh', 0.20),
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
        currentIndex: 2, // Analytics
       onTap: (index) {
  if (index == 2) return; // Already on Analytics

  Widget page;

  switch (index) {
    case 0:
      page = const HomeScreen();
      break;
    case 1:
      page = const ExploreTab();
      break;
    case 3:
      page = const EnergySchedulingScreen(); // ✅ removed "return"
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
    MaterialPageRoute(builder: (context) => page),
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

  Widget lineChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    days[value.toInt() % 7],
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 20),
              FlSpot(1, 18),
              FlSpot(2, 30),
              FlSpot(3, 28),
              FlSpot(4, 40),
              FlSpot(5, 25),
              FlSpot(6, 30),
            ],
            isCurved: true,
            color: Colors.white,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.white.withAlpha((0.25 * 255).toInt()),
            ),
          ),
        ],
      ),
    );
  }
}

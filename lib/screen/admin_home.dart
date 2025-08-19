import 'package:flutter/material.dart';
import 'analytics.dart';
import 'explore.dart'; 
import 'schedule.dart'; 
import 'settings.dart'; 
import 'profile.dart';
import '../main.dart'; // Assuming AnimatedBackground & BackgroundShapes are in main.dart

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
              Expanded(child: _getBody()),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _getBody() {
    if (_currentIndex == 0) {
      return _dashboardBody();
    } else {
      return Center(
        child: Text(
          _tabTitle(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  String _tabTitle() {
    switch (_currentIndex) {
      case 1:
        return 'Explore';
      case 3:
        return 'Schedule';
      case 4:
        return 'Settings';
      case 5:
        return 'Profile';
      default:
        return 'Energy';
    }
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
      backgroundColor: Colors.black.withAlpha((255 * 0.4).toInt()),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
       onTap: (index) {
        if (index == 1) {
          Navigator.pushReplacement(
            context,
           MaterialPageRoute(builder: (_) =>const ExploreTab())
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
          );
        }else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EnergySchedulingScreen()),
          );
          } else if (index == 4) {
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
          else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Energy'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget _dashboardBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
    );
  }

  Widget _currentEnergyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Current Energy Usage',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 8),
                Text(
                  '24.8 kWh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '+2.5% less than yesterday',
                  style: TextStyle(color: Colors.white70),
                ),
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
              const Text(
                '70%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Montly Consumption',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '8.2 kWh',
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey,
            color: Colors.orange,
          ),
          const SizedBox(height: 4),
          const Text(
            'Consume hours: 5.2 hrs',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _energyConsumptionChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              color: const Color(0xFFF7F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Graph Placeholder')),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '12 AM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                '3 AM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                '6 AM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                '9 AM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                '12 PM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                '3 PM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                '6 PM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                '9 PM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                '12 AM',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Peak Usage',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '3.8 kWh at 3:15 PM',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Lowest Usage',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '0.8 kWh at 4:00 AM',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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

  Widget _filterButton(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _connectedDevicesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connected Devices',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _deviceTile(
            Icons.lightbulb,
            'Smart Light',
            'Living Room - Online',
            Colors.yellow.shade100,
          ),
          const SizedBox(height: 8),
          _deviceTile(
            Icons.ac_unit,
            'Air Conditioner',
            'Bedroom - Offline',
            Colors.blue.shade100,
          ),
          const SizedBox(height: 8),
          _deviceTile(
            Icons.tv,
            'Smart TV',
            'Living Room - Online',
            Colors.green.shade100,
          ),
        ],
      ),
    );
  }

  Widget _deviceTile(
    IconData icon,
    String title,
    String status,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  status,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _energyTipsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Energy Savings Tips',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _tipTile(
            Icons.check_circle,
            'Optimize AC Usage',
            'Set to 24°C could save 15%',
            Colors.green.shade100,
          ),
          const SizedBox(height: 8),
          _tipTile(
            Icons.schedule,
            'Solar Power Hours',
            'Use heavy appliances 10AM - 2PM',
            Colors.blue.shade100,
          ),
        ],
      ),
    );
  }

  Widget _tipTile(IconData icon, String title, String subtitle, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

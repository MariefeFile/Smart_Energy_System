import 'package:flutter/material.dart';
import 'connected_devices.dart';
import 'custom_bottom_nav.dart';
import 'custom_header.dart';
import 'energy_chart.dart';

enum EnergyPeriod { daily, weekly, monthly }


class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late int _currentIndex;
  bool _isDarkMode = false;

  late AnimationController _sidebarController;
  late AnimationController _overlayController;
  late AnimationController _profileController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _sidebarController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOut));

    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeInOut),
    );

    _profileController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    _overlayController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  // Sidebar controls
  void _closeFeatures() {
    _overlayController.reverse();
    _sidebarController.reverse();
  }

  // Profile dropdown controls
  
  void _closeProfile() => _profileController.reverse();
  

  // Navigate from features
  void selectFeature(String featureName, Widget screen) {
    _closeFeatures();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a2332), Color(0xFF0f1419)],
              ),
            ),
          ),

          Column(
            children: [
              // ✅ Use CustomHeader
              CustomHeader(
                isDarkMode: _isDarkMode,
                isSidebarOpen: _sidebarController.isCompleted,
                onToggleDarkMode: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                },
               
              ),

              // Dashboard Content
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

          // Sidebar overlay
          IgnorePointer(
            ignoring: _sidebarController.status != AnimationStatus.completed,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onTap: _closeFeatures,
                child: Container(color: Colors.black.withAlpha(100)),
              ),
            ),
          ),

          // Sidebar slide-in (empty now)
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 250,
                height: double.infinity,
                color: const Color(0xFF1e293b),
                child: const SafeArea(
                  child: Center(
                    child: Text(
                      "Sidebar",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Profile dropdown
          Align(
            alignment: Alignment.topRight,
            child: FadeTransition(
              opacity: _profileController,
              child: ScaleTransition(
                scale: _profileController,
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 70, right: 12),
                  width: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(150),
                        blurRadius: 10,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Marie Fe Tapales',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('marie@example.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _closeProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: const Size.fromHeight(36),
                        ),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index, page) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }

  // ---------------------- Dashboard Cards & Sections ----------------------
  Widget _currentEnergyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
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
                Text('24.8 kWh', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
              const Text('70%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Monthly Consumption', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
          SizedBox(height: 8),
          Text('8.2 kWh', style: TextStyle(fontSize: 18, color: Colors.tealAccent, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          LinearProgressIndicator(value: 0.7, backgroundColor: Colors.white24, color: Colors.orangeAccent),
          SizedBox(height: 4),
          Text('Consume hours: 5.2 hrs', style: TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

 
 // ---------------------- Energy Consumption Chart ----------------------
Widget _energyConsumptionChart() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ align left
      children: const [
        Text(
          "Energy Consumption",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12), // spacing before chart
        EnergyConsumptionChart(),
      ],
    ),
  );
}

  
  // ---------------------- Helper Widgets ----------------------
 
  Widget _connectedDevicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Connected Devices', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...connectedDevices.map((device) => _deviceTile(device.icon, device.name, device.status)),
      ],
    );
  }

 Widget _deviceTile(IconData icon, String title, String status) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.teal, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: status == 'Active' ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget _tipTile(IconData icon, String title, String subtitle) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF1e293b),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



 Widget _energyTipsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Smart Energy Tips',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _tipTile(Icons.battery_charging_full, 'Unplug Chargers',
          'Unplug devices once fully charged to avoid phantom load.'),
      const SizedBox(height: 8),
      _tipTile(Icons.ac_unit, 'Efficient AC Use',
          'Set air conditioners between 24–25°C for efficiency.'),
      const SizedBox(height: 8),
      _tipTile(Icons.lightbulb, 'Switch to LED',
          'LED bulbs use up to 80% less energy than incandescent bulbs.'),
      const SizedBox(height: 8),
      _tipTile(Icons.local_laundry_service, 'Run Full Loads',
          'Washers and dishwashers are most efficient when fully loaded.'),
      const SizedBox(height: 8),
      _tipTile(Icons.power, 'Use Smart Plugs',
          'Monitor and control appliances remotely with smart plugs.'),
    ],
  );
}

}

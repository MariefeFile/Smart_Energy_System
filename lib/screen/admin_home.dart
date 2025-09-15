import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'analytics.dart';
import 'explore.dart';
import 'schedule.dart';
import 'settings.dart';
import 'profile.dart';
import 'connected_devices.dart';


enum EnergyPeriod { daily, weekly, monthly }
EnergyPeriod _selectedPeriod = EnergyPeriod.daily;

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late int _currentIndex;
  bool _isDarkMode = false;
  bool _showGuidelines = false;
  late AnimationController _sidebarController;
  late AnimationController _overlayController;
  late AnimationController _profileController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Sidebar animation
    _sidebarController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // off-screen right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOut));

    // Overlay fade animation
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeInOut),
    );

    // Profile pop-out animation
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

  void _openFeatures() {
    _overlayController.forward();
    _sidebarController.forward();
  }

  void _closeFeatures() {
    _overlayController.reverse();
    _sidebarController.reverse();
  }

  void _toggleFeatures() {
    if (_sidebarController.isCompleted) {
      _closeFeatures();
    } else {
      _openFeatures();
    }
  }

  void _openProfile() {
    _profileController.forward();
  }

  void _closeProfile() {
    _profileController.reverse();
  }

  void _toggleProfile() {
    if (_profileController.isCompleted) {
      _closeProfile();
    } else {
      _openProfile();
    }
  }

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
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a2332), Color(0xFF0f1419)],
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              SafeArea(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
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
                        icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.teal),
                        onPressed: () {
                          setState(() {
                            _isDarkMode = !_isDarkMode;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: _toggleFeatures,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _sidebarController.isCompleted
                                ? [
                                    BoxShadow(
                                      color: Colors.tealAccent.withAlpha((0.7 * 255).round()),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withAlpha((0.2 * 255).round()),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(3, (j) {
                                  return Container(
                                    margin: const EdgeInsets.all(1.5),
                                    width: 3,
                                    height: 3,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleProfile,
                        child: const CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
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
          // Overlay for sidebar
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
          // Sidebar
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 250,
                height: double.infinity,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        Expanded(child: ListView(children: _buildFeaturesList())),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Profile Panel
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
                            backgroundColor: Colors.teal, minimumSize: const Size.fromHeight(36)),
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ---------------------- Bottom Nav Bar ----------------------
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
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
  double screenWidth = MediaQuery.of(context).size.width;

  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(screenWidth * 0.04),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Energy Consumption',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                    color: Colors.white)),
            Row(
              children: [
                _timePeriodButton('Daily', EnergyPeriod.daily, screenWidth),
                SizedBox(width: screenWidth * 0.02),
                _timePeriodButton('Weekly', EnergyPeriod.weekly, screenWidth),
                SizedBox(width: screenWidth * 0.02),
                _timePeriodButton('Monthly', EnergyPeriod.monthly, screenWidth),
              ],
            )
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: screenWidth * 0.5, // chart height relative to width
          child: _buildEnergyChart(),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Peak Usage',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth * 0.03)),
                    SizedBox(height: 4),
                    Text('3.8 kWh at 3:15 PM',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035)),
                  ],
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lowest Usage',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth * 0.03)),
                    SizedBox(height: 4),
                    Text('0.8 kWh at 4:00 AM',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035)),
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


Widget _buildEnergyChart() {
  List<FlSpot> spots = [];
  List<String> labels = [];

  switch (_selectedPeriod) {
    case EnergyPeriod.daily:
      spots = List.generate(24, (h) => FlSpot((h + 1).toDouble(), 5 + (h % 6) * 3));
      labels = List.generate(24, (h) => '${h + 1}'); // 1 to 24 hours
      break;

    case EnergyPeriod.weekly:
      List<String> weekDays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
      spots = List.generate(7, (i) => FlSpot((i + 1).toDouble(), 10 + (i % 5) * 2));
      labels = weekDays;
      break;

    case EnergyPeriod.monthly:
      int daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
      spots = List.generate(daysInMonth, (i) => FlSpot((i + 1).toDouble(), 8 + (i % 10)));
      labels = List.generate(daysInMonth, (i) => '${i + 1}');
      break;
  }

  return LineChart(
    LineChartData(
      minX: 1,
      maxX: spots.last.x,
      minY: 0,
      maxY: (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _selectedPeriod == EnergyPeriod.daily ? 3 : 1,
            getTitlesWidget: (value, _) {
              int index = value.toInt() - 1; // subtract 1 to match labels
              if (index >= 0 && index < labels.length) {
                return Text(labels[index], style: const TextStyle(color: Colors.white70, fontSize: 10));
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            getTitlesWidget: (value, _) => Text('${value.toInt()}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: 5,
        verticalInterval: _selectedPeriod == EnergyPeriod.daily ? 3 : 1,
        getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withValues(alpha: 0.1), strokeWidth: 1),
        getDrawingVerticalLine: (value) => FlLine(color: Colors.white.withValues(alpha: 0.1), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.teal,
          barWidth: 3,
          belowBarData: BarAreaData(show: true, color: Colors.teal.withValues(alpha: 0.2)),
          dotData: FlDotData(show: true),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.teal,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((t) {
              int index = t.x.toInt() - 1; // match labels
              String label = labels[index];
              return LineTooltipItem('$label\n${t.y.toStringAsFixed(1)} kWh', const TextStyle(color: Colors.white, fontSize: 12));
            }).toList();
          },
        ),
      ),
    ),
  );
}


  // ---------------------- Helper Widgets ----------------------
Widget _timePeriodButton(String label, EnergyPeriod period, double screenWidth) {
  final bool isSelected = _selectedPeriod == period;
  return SizedBox(
    width: screenWidth * 0.15, // responsive width
    height: screenWidth * 0.08, // responsive height
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: () => setState(() => _selectedPeriod = period),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: screenWidth * 0.03),
      ),
    ),
  );
}


  Widget _connectedDevicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Connected Devices', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...connectedDevices.map((device) => _deviceTile(device.icon, device.name, device.status)).toList(),
      ],
    );
  }

  Widget _deviceTile(IconData icon, String title, String status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text(status, style: const TextStyle(fontSize: 12, color: Colors.white70)),
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
        const Text('Energy Savings Tips', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeaturesList() {
    final features = [
      {"icon": Icons.devices, "title": "Devices", "screen": const DevicesTab()},
      {"icon": Icons.show_chart, "title": "Analytics", "screen": const AnalyticsScreen()},
      {"icon": Icons.schedule, "title": "Scheduling", "screen": const EnergySchedulingScreen()},
      {"icon": Icons.settings, "title": "Settings", "screen": const EnergySettingScreen()},
      {"icon": Icons.menu_book, "title": "Guidelines"}, // no screen, toggle dropdown
    ];

    return [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 31, 94, 196).withValues(alpha: 0.6),
                Color.fromARGB(255, 41, 40, 75).withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Explore More",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (feature["title"] == "Guidelines") {
                            setState(() {
                              _showGuidelines = !_showGuidelines;
                            });
                          } else {
                            selectFeature(feature["title"] as String, feature["screen"] as Widget);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(feature["icon"] as IconData, color: Colors.tealAccent, size: 24),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(feature["title"] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  );
                },
              ),
              if (_showGuidelines)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("⚡ Save energy by turning off unused appliances.",
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text("🌞 Use natural light during daytime.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text("❄️ Optimize air conditioning usage.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text("🔌 Unplug chargers when not in use.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    ];
  }
}

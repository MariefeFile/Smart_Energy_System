import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartenergy_app/screen/explore.dart';
import 'package:smartenergy_app/screen/schedule.dart';
import 'package:smartenergy_app/screen/settings.dart';
import 'package:smartenergy_app/screen/profile.dart';
import 'package:smartenergy_app/screen/admin_home.dart';
import 'connected_devices.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  bool _isDarkMode = false;
  int? _selectedDayIndex;
  late AnimationController _profileController;
  late Animation<Offset> _profileSlideAnimation;
  late Animation<double> _profileScaleAnimation;
  late Animation<double> _profileFadeAnimation;

  @override
  void initState() {
    super.initState();

    _profileController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _profileSlideAnimation = Tween<Offset>(
      begin: const Offset(0.2, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _profileController, curve: Curves.easeOutBack));

    _profileScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack));

    _profileFadeAnimation = CurvedAnimation(
      parent: _profileController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  void _toggleProfile() {
    if (_profileController.status == AnimationStatus.dismissed) {
      _profileController.forward();
    } else {
      _profileController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Calculate total usage dynamically
    double totalUsage = connectedDevices.fold(0, (sum, d) => sum + d.usage);

    return Scaffold(
      body: Stack(
        children: [
          // Background
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

          Column(
            children: [
              // Top Bar
              SafeArea(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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
                        icon:
                            const Icon(Icons.notifications, color: Colors.teal),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                            _isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: Colors.teal),
                        onPressed: () {
                          setState(() => _isDarkMode = !_isDarkMode);
                        },
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

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text('Analytics',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                                child: summaryCard(
                                    'Total Consumption',
                                    '${totalUsage.toStringAsFixed(1)} kWh',
                                    '+4.2%')),
                            const SizedBox(width: 12),
                            Expanded(
                                child: summaryCard(
                                    'Cost',
                                    '₱${(totalUsage * 0.188).toStringAsFixed(2)}',
                                    '+16.5%')),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Text('Energy Usage',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 12),
                        SizedBox(height: 200, child: lineChart()),
                        const SizedBox(height: 24),

                        // ✅ Only show breakdown when a day is tapped
                        if (_selectedDayIndex != null) ...[
                          Text(
                            'Devices on ${['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][_selectedDayIndex!]}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 12),

                          Column(
                            children: connectedDevices.map((device) {
                              // Fake variation per day for demo
                              double adjustedUsage = device.usage *
                                  (0.6 + (_selectedDayIndex! * 0.1));
                              double percent = totalUsage == 0
                                  ? 0
                                  : adjustedUsage / totalUsage;

                              return breakdownTile(
                                device.icon,
                                device.name,
                                "${adjustedUsage.toStringAsFixed(1)} kWh",
                                percent,
                              );
                            }).toList(),
                          ),
                        ],
                      ]),
                ),
              ),
            ],
          ),

          // Profile Popover
          Positioned(
            top: 70,
            right: 12,
            child: FadeTransition(
              opacity: _profileFadeAnimation,
              child: SlideTransition(
                position: _profileSlideAnimation,
                child: ScaleTransition(
                  scale: _profileScaleAnimation,
                  alignment: Alignment.topRight,
                  child: Container(
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
                        const Text('Profile',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        const SizedBox(height: 12),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.person,
                              size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text('Marie Fe Tapales',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('marie@example.com',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            _profileController.reverse();
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            if (!mounted) return;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const EnergyProfileScreen()));
                          },
                          child: const Text('View Profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _profileController.reverse,
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
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
        backgroundColor: Colors.black.withValues(alpha: 0.4),
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          Widget page;
          switch (index) {
            case 0:
              page = const HomeScreen();
              break;
            case 1:
              page = const ExploreTab();
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
              context, MaterialPageRoute(builder: (_) => page));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Energy'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // --- UI Components ---
  Widget summaryCard(String title, String value, String change) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:
            const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        const SizedBox(height: 6),
        Text(change,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF10b981),
                fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget breakdownTile(
      IconData icon, String label, String value, double percent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:
            const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(children: [
        Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.teal, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 22)),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            LinearProgressIndicator(
                value: percent,
                color: const Color(0xFF10b981),
                backgroundColor: Colors.white.withValues(alpha: 0.2)),
          ]),
        ),
        const SizedBox(width: 16),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget lineChart() {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.lineBarSpots == null) return;

            final spot = response.lineBarSpots!.first;
            final dayIndex = spot.x.toInt();

            setState(() {
              _selectedDayIndex = dayIndex;
            });
          },
        ),
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
                    child: Text(days[value.toInt() % 7],
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white)));
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
              FlSpot(6, 30)
            ],
            isCurved: true,
            color: Colors.white,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
                show: true, color: Colors.white.withValues(alpha: 0.25)),
          ),
        ],
      ),
    );
  }
}

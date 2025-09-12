import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartenergy_app/screen/explore.dart';
import 'package:smartenergy_app/screen/schedule.dart';
import 'package:smartenergy_app/screen/settings.dart';
import 'package:smartenergy_app/screen/profile.dart';
import 'package:smartenergy_app/screen/admin_home.dart';
import 'connected_devices.dart';

enum EnergyRange { daily, weekly, monthly }

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  bool _isDarkMode = false;
  int? _selectedDayIndex;
  EnergyRange _selectedRange = EnergyRange.daily;

  late AnimationController _profileController;
  late Animation<Offset> _profileSlideAnimation;
  late Animation<double> _profileScaleAnimation;
  late Animation<double> _profileFadeAnimation;

  // Selected month for dropdown
  int _selectedMonth = DateTime.now().month;

  // --- New date selection
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

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
    ).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack),
    );
    _profileScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack),
    );
    _profileFadeAnimation =
        CurvedAnimation(parent: _profileController, curve: Curves.easeInOut);
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

  // --- Month names (for daily/weekly/monthly)
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  /// Header widget with date/week/month picker
  Widget _headerWidget() {
    switch (_selectedRange) {
      case EnergyRange.daily:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            )
          ],
        );

      case EnergyRange.weekly:
        final end = _selectedWeekStart.add(const Duration(days: 6));
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_monthNames[_selectedWeekStart.month - 1]} ${_selectedWeekStart.day}'
              ' – ${_monthNames[end.month - 1]} ${end.day}, ${end.year}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Colors.white, size: 20),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedWeekStart,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  final monday = picked.subtract(Duration(days: picked.weekday - 1));
                  setState(() => _selectedWeekStart = monday);
                }
              },
            )
          ],
        );

      case EnergyRange.monthly:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_monthNames[_selectedMonth - 1]}, ${DateTime.now().year}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.calendar_view_month, color: Colors.white, size: 20),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(DateTime.now().year, _selectedMonth, 1),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _selectedMonth = picked.month);
                }
              },
            )
          ],
        );
    }
  }

  /// Data for chart
  List<FlSpot> _getUsageData() {
    switch (_selectedRange) {
      case EnergyRange.daily:
        return List.generate(
          24,
          (h) => FlSpot(h.toDouble(), 10 + (h % 6) * 3),
        );

      case EnergyRange.weekly:
        return List.generate(
          7,
          (d) => FlSpot(d.toDouble(), 20 + (d % 3) * 5),
        );

      case EnergyRange.monthly:
        final daysInMonth = DateTime(DateTime.now().year, _selectedMonth + 1, 0).day;
        return List.generate(
          daysInMonth,
          (i) => FlSpot((i + 1).toDouble(), 30 + (i % 5) * 4),
        );
    }
  }

  Widget _rangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _rangeButton(EnergyRange.daily, 'Daily'),
        const SizedBox(width: 8),
        _rangeButton(EnergyRange.weekly, 'Weekly'),
        const SizedBox(width: 8),
        _rangeButton(EnergyRange.monthly, 'Monthly'),
      ],
    );
  }

  Widget _rangeButton(EnergyRange r, String label) {
    final sel = _selectedRange == r;
    return GestureDetector(
      onTap: () => setState(() => _selectedRange = r),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? Colors.teal : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: sel ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // --- Keep the rest of your original code (build, summaryCard, breakdownTile, lineChart, etc.) untouched
  @override
  Widget build(BuildContext context) {
    double totalUsage = connectedDevices.fold(0, (sum, d) => sum + d.usage);

    return Scaffold(
      body: Stack(
        children: [
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
                          _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: Colors.teal,
                        ),
                        onPressed: () =>
                            setState(() => _isDarkMode = !_isDarkMode),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
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
                              '${totalUsage.toStringAsFixed(1)} kWh',
                              '+4.2%',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: summaryCard(
                              'Cost',
                              '₱${(totalUsage * 0.188).toStringAsFixed(2)}',
                              '+16.5%',
                            ),
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
                      const SizedBox(height: 8),
                      _rangeSelector(),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _headerWidget(),
                          ),
                          SizedBox(height: 200, child: lineChart()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_selectedDayIndex != null) ...[
                        Text(
                          'Devices on ${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][_selectedDayIndex! % 7]}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: connectedDevices.map((device) {
                            double adjustedUsage =
                                device.usage * (0.6 + (_selectedDayIndex! * 0.1));
                            double percent = totalUsage == 0
                                ? 0
                                : adjustedUsage / totalUsage;

                            return breakdownTile(
                              device.icon,
                              device.name,
                              '${adjustedUsage.toStringAsFixed(1)} kWh',
                              percent,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.teal,
                          child:
                              Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Marie Fe Tapales',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'marie@example.com',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
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
                                builder: (_) => const EnergyProfileScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'View Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
              page = const DevicesTab();
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
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Devices'),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:
            const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            change,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF10b981),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget breakdownTile(IconData icon, String label, String value, double percent) {
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
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percent,
                  color: const Color(0xFF10b981),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget lineChart() {
    final data = _getUsageData();
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.lineBarSpots == null) return;
            setState(() {
              _selectedDayIndex = response.lineBarSpots!.first.x.toInt();
            });
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (_selectedRange == EnergyRange.daily) {
                  return value % 1 == 0 && value >= 0 && value <= 23
                      ? Text('${value.toInt()}h',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white))
                      : const SizedBox.shrink();
                }
                if (_selectedRange == EnergyRange.weekly) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];
                  final i = value.toInt();
                  return i >= 0 && i < days.length
                      ? Text(days[i],
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white))
                      : const SizedBox.shrink();
                }
                // Monthly labels
                // Monthly labels
final int day = value.toInt();
final lastDay =
    DateTime(DateTime.now().year, _selectedMonth + 1, 0).day;
if (day >= 1 && day <= lastDay) {
  return Text('$day',
      style: const TextStyle(fontSize: 10, color: Colors.white));
}
return const SizedBox.shrink();

              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            color: Colors.white,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData:
                BarAreaData(show: true, color: Colors.white.withValues(alpha: 0.25)),
          ),
        ],
      ),
    );
  }
}

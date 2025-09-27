import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartenergy_app/screen/profile.dart';
import 'connected_devices.dart';
import 'custom_bottom_nav.dart';
import 'custom_header.dart';

enum EnergyRange { daily, weekly, monthly }

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  bool _isDarkMode = false;
  EnergyRange _selectedRange = EnergyRange.daily;
  DateTime? _selectedDateFromChart;

  late AnimationController _profileController;
  late Animation<Offset> _profileSlideAnimation;
  late Animation<double> _profileScaleAnimation;
  late Animation<double> _profileFadeAnimation;

  int _selectedMonth = DateTime.now().month;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

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

  static const List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

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

  List<FlSpot> _getUsageData() {
    switch (_selectedRange) {
      case EnergyRange.daily:
        return List.generate(24, (h) => FlSpot(h.toDouble(), 10 + (h % 6) * 3));
      case EnergyRange.weekly:
        return List.generate(7, (d) => FlSpot(d.toDouble(), 20 + (d % 3) * 5));
      case EnergyRange.monthly:
        final daysInMonth = DateTime(DateTime.now().year, _selectedMonth + 1, 0).day;
        return List.generate(daysInMonth, (i) => FlSpot((i + 1).toDouble(), 30 + (i % 5) * 4));
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
             CustomHeader(
  isDarkMode: _isDarkMode,
  isSidebarOpen: false, // you can adjust if you add sidebar
  onToggleDarkMode: () {
    setState(() => _isDarkMode = !_isDarkMode);
  },
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
                      if (_selectedDateFromChart != null) ...[
                        Text(
                          'Devices on ${_monthNames[_selectedDateFromChart!.month - 1]} '
                          '${_selectedDateFromChart!.day}, ${_selectedDateFromChart!.year}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: connectedDevices.map((device) {
                            double adjustedUsage = device.usage;
                            if (_selectedRange == EnergyRange.weekly) {
                              int dayIndex = _selectedDateFromChart!.difference(_selectedWeekStart).inDays;
                              adjustedUsage *= (0.6 + (dayIndex * 0.1));
                            } else if (_selectedRange == EnergyRange.monthly) {
                              int dayIndex = _selectedDateFromChart!.day - 1;
                              adjustedUsage *= (0.5 + (dayIndex * 0.05));
                            } else if (_selectedRange == EnergyRange.daily) {
                              int hour = _selectedDateFromChart!.hour;
                              adjustedUsage *= (0.5 + (hour * 0.05));
                            }
                            double totalForSelected = connectedDevices.fold(0, (sum, d) => sum + d.usage);
                            double percent = totalForSelected == 0 ? 0 : adjustedUsage / totalForSelected;

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
                          child: Icon(Icons.person, size: 30, color: Colors.white),
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
                            await Future.delayed(const Duration(milliseconds: 300));
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
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index, page) {
          if (index != 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          }
        },
      ),
    );
  }

  Widget summaryCard(String title, String value, String change) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
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
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 6),
          Text(change,
              style: const TextStyle(
                  fontSize: 14, color: Color(0xFF10b981), fontWeight: FontWeight.w500)),
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
        gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
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
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percent,
                  color: const Color(0xFF10b981),
                  backgroundColor: Colors.grey,
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget lineChart() {
    final spots = _getUsageData();

    double minX = 0;
    double maxX = spots.length.toDouble() - 1;

    if (_selectedRange == EnergyRange.monthly) {
      minX = 1;
      maxX = spots.length.toDouble();
    } else if (_selectedRange == EnergyRange.daily) {
      minX = 0;
      maxX = 23;
    } else if (_selectedRange == EnergyRange.weekly) {
      minX = 0;
      maxX = 6;
    }

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: 0,
        maxY: 50,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                if (_selectedRange == EnergyRange.weekly) {
                  int idx = value.toInt();
                  if (idx >= 0 && idx < 7) {
                    return Text(
                      _weekDays[idx],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  }
                } else if (_selectedRange == EnergyRange.monthly) {
                  int day = value.toInt();
                  if (day >= 1 && day <= spots.length) {
                    return Text(
                      day.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    );
                  }
                } else {
                  int hour = value.toInt();
                  if (hour >= 0 && hour <= 23) {
                    return Text(
                      hour.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.teal,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.teal.withValues(alpha: 0.2),
            ),
            dotData: FlDotData(show: true),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.teal,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                String label = '';
                switch (_selectedRange) {
                  case EnergyRange.daily:
                    label = '${touchedSpot.x.toInt()}:00';
                    break;
                  case EnergyRange.weekly:
                    DateTime date =
                        _selectedWeekStart.add(Duration(days: touchedSpot.x.toInt()));
                    label =
                        '${_weekDays[date.weekday - 1]}, ${_monthNames[date.month - 1]} ${date.day}';
                    break;
                  case EnergyRange.monthly:
                    DateTime date =
                        DateTime(DateTime.now().year, _selectedMonth, touchedSpot.x.toInt());
                    label = '${_monthNames[date.month - 1]} ${date.day}';
                    break;
                }
                return LineTooltipItem(label, const TextStyle(color: Colors.white));
              }).toList();
            },
          ),
          touchCallback: (event, response) {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.lineBarSpots == null) return;

            setState(() {
              final spot = response.lineBarSpots!.first;
              if (_selectedRange == EnergyRange.monthly) {
                _selectedDateFromChart =
                    DateTime(DateTime.now().year, _selectedMonth, spot.x.toInt());
              } else if (_selectedRange == EnergyRange.weekly) {
                _selectedDateFromChart =
                    _selectedWeekStart.add(Duration(days: spot.x.toInt()));
              } else {
                _selectedDateFromChart = DateTime(
                    _selectedDate.year, _selectedDate.month, _selectedDate.day, spot.x.toInt());
              }
            });
          },
        ),
      ),
    );
  }
}

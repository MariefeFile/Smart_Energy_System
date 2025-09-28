import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'connected_devices.dart';

enum EnergyRange { daily, weekly, monthly }

class EnergyChart extends StatefulWidget {
  const EnergyChart({super.key});

  @override
  State<EnergyChart> createState() => _EnergyChartState();
}

class _EnergyChartState extends State<EnergyChart> {
  EnergyRange _selectedRange = EnergyRange.daily;
  final DateTime _selectedDate = DateTime.now();
  final DateTime _selectedWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  final int _selectedMonth = DateTime.now().month;
  DateTime? _selectedDateFromChart;

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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

  @override
  Widget build(BuildContext context) {
    double totalUsage = connectedDevices.fold(0, (sum, d) => sum + d.usage);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _rangeButton(EnergyRange.daily, 'Daily'),
              const SizedBox(width: 8),
              _rangeButton(EnergyRange.weekly, 'Weekly'),
              const SizedBox(width: 8),
              _rangeButton(EnergyRange.monthly, 'Monthly'),
            ],
          ),
          const SizedBox(height: 12),
          _headerWidget(),
          const SizedBox(height: 12),
          SizedBox(height: 200, child: lineChart()),
          const SizedBox(height: 24),
          if (_selectedDateFromChart != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Devices on ${_monthNames[_selectedDateFromChart!.month - 1]} ${_selectedDateFromChart!.day}, ${_selectedDateFromChart!.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Column(
                  children: connectedDevices.map((device) {
                    double adjustedUsage = device.usage;
                    bool isOnline = true;
                    String status = adjustedUsage > 5 ? "GOOD" : "BAD";

                    return breakdownTile(
                      device.icon,
                      device.name,
                      '${adjustedUsage.toStringAsFixed(1)} kWh',
                      adjustedUsage / (totalUsage == 0 ? 1 : totalUsage),
                      isOnline,
                      status,
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _rangeButton(EnergyRange r, String label) {
    final sel = _selectedRange == r;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedRange = r;
        _selectedDateFromChart = null;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? Colors.teal : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: sel ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _headerWidget() {
    switch (_selectedRange) {
      case EnergyRange.daily:
        return Text(
          '${_monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        );
      case EnergyRange.weekly:
        final end = _selectedWeekStart.add(const Duration(days: 6));
        return Text(
          '${_monthNames[_selectedWeekStart.month - 1]} ${_selectedWeekStart.day} – ${_monthNames[end.month - 1]} ${end.day}, ${end.year}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        );
      case EnergyRange.monthly:
        return Text(
          '${_monthNames[_selectedMonth - 1]}, ${DateTime.now().year}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        );
    }
  }

  Widget lineChart() {
    final spots = _getUsageData();
    double minX = 0;
    double maxX = spots.length.toDouble();

    switch (_selectedRange) {
      case EnergyRange.daily:
        maxX = 23;
        break;
      case EnergyRange.weekly:
        maxX = 6;
        break;
      case EnergyRange.monthly:
        maxX = spots.length.toDouble();
        break;
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
                    return Text(_weekDays[idx], style: const TextStyle(color: Colors.white, fontSize: 12));
                  }
                } else if (_selectedRange == EnergyRange.monthly) {
                  int day = value.toInt();
                  if (day >= 1 && day <= spots.length) {
                    return Text(day.toString(), style: const TextStyle(color: Colors.white, fontSize: 10));
                  }
                } else {
                  int hour = value.toInt();
                  if (hour >= 0 && hour <= 23) {
                    return Text(hour.toString(), style: const TextStyle(color: Colors.white, fontSize: 10));
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
            belowBarData: BarAreaData(show: true, color: Colors.teal.withValues(alpha: 0.2)),
            dotData: FlDotData(show: true),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchCallback: (event, response) {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.lineBarSpots == null ||
                response.lineBarSpots!.isEmpty) {
              return;
            }

            final spot = response.lineBarSpots!.first;
            setState(() {
              if (_selectedRange == EnergyRange.monthly) {
                _selectedDateFromChart = DateTime(DateTime.now().year, _selectedMonth, spot.x.toInt());
              } else if (_selectedRange == EnergyRange.weekly) {
                _selectedDateFromChart = _selectedWeekStart.add(Duration(days: spot.x.toInt()));
              } else {
                _selectedDateFromChart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, spot.x.toInt());
              }
            });
          },
        ),
      ),
    );
  }

  Widget breakdownTile(IconData icon, String label, String value, double percent, bool isOnline, String status) {
    double baseUsage = double.parse(value.replaceAll(' kWh', ''));
    double ratePerKwh = 11.50;
    double dailyCost = baseUsage * ratePerKwh;
    double weeklyCost = dailyCost * 7;
    double monthlyCost = dailyCost * 30;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF0f172a)]),
        border: Border.all(color: isOnline ? Colors.teal.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: isOnline ? Colors.teal : Colors.grey[700], borderRadius: BorderRadius.circular(15)),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: isOnline ? Colors.green : Colors.red, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text(status, style: TextStyle(color: isOnline ? Colors.green[300] : Colors.red[300], fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.teal.withValues(alpha: 0.3))),
                child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Usage Progress', style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500)),
            Text('${(percent * 100).toStringAsFixed(1)}%', style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: percent, color: Colors.teal, backgroundColor: Colors.grey[700], minHeight: 8),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _costItem('Daily', '₱${dailyCost.toStringAsFixed(2)}', '${baseUsage.toStringAsFixed(1)} kWh'),
              _costItem('Weekly', '₱${weeklyCost.toStringAsFixed(2)}', '${(baseUsage * 7).toStringAsFixed(1)} kWh'),
              _costItem('Monthly', '₱${monthlyCost.toStringAsFixed(2)}', '${(baseUsage * 30).toStringAsFixed(1)} kWh'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _costItem(String period, String cost, String kwh) {
    return Column(
      children: [
        Text(period, style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(cost, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(kwh, style: TextStyle(color: Colors.teal[300], fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

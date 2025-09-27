import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum EnergyRange { daily, weekly, monthly }

class EnergyConsumptionChart extends StatefulWidget {
  const EnergyConsumptionChart({super.key});

  @override
  State<EnergyConsumptionChart> createState() =>
      _EnergyConsumptionChartState();
}

class _EnergyConsumptionChartState extends State<EnergyConsumptionChart> {
  EnergyRange _selectedRange = EnergyRange.daily;

  static const List<String> _weekDays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
  static const List<String> _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  int _selectedMonth = DateTime.now().month;

  /// ✅ Generate chart data based on selected range
  List<FlSpot> _getUsageData() {
    switch (_selectedRange) {
      case EnergyRange.daily:
        return List.generate(
            24, (h) => FlSpot(h.toDouble(), 10 + (h % 6) * 3));
      case EnergyRange.weekly:
        return List.generate(
            7, (d) => FlSpot(d.toDouble(), 20 + (d % 3) * 5));
      case EnergyRange.monthly:
        final daysInMonth =
            DateTime(DateTime.now().year, _selectedMonth + 1, 0).day;
        return List.generate(
            daysInMonth,
            (i) =>
                FlSpot((i + 1).toDouble(), 30 + (i % 5) * 4));
    }
  }

  /// ✅ Get label text for header
  String _getDateLabel() {
    switch (_selectedRange) {
      case EnergyRange.daily:
        return '${_monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';
      case EnergyRange.weekly:
        final end = _selectedWeekStart.add(const Duration(days: 6));
        return '${_monthNames[_selectedWeekStart.month - 1]} ${_selectedWeekStart.day} – '
            '${_monthNames[end.month - 1]} ${end.day}, ${end.year}';
      case EnergyRange.monthly:
        return '${_monthNames[_selectedMonth - 1]}, ${DateTime.now().year}';
    }
  }

  /// ✅ Interactive header with calendar picker
  Widget _headerWidget() {
    return GestureDetector(
      onTap: () async {
        if (_selectedRange == EnergyRange.daily) {
          // Pick specific date
          final picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() => _selectedDate = picked);
          }
        } else if (_selectedRange == EnergyRange.weekly) {
          // Pick start of the week
          final picked = await showDatePicker(
            context: context,
            initialDate: _selectedWeekStart,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() {
              _selectedWeekStart =
                  picked.subtract(Duration(days: picked.weekday - 1));
            });
          }
        } else if (_selectedRange == EnergyRange.monthly) {
          // Pick a month (using date picker hack)
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(DateTime.now().year, _selectedMonth, 1),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            initialDatePickerMode: DatePickerMode.year, // start in year view
          );
          if (picked != null) {
            setState(() => _selectedMonth = picked.month);
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today,
              size: 16, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            _getDateLabel(),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// ✅ Range selector buttons
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

  Widget _rangeButton(EnergyRange range, String label) {
    final selected = _selectedRange == range;
    return GestureDetector(
      onTap: () => setState(() => _selectedRange = range),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.teal : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// ✅ Line chart
  Widget _lineChart() {
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
                    return Text(_weekDays[idx],
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10));
                  }
                } else if (_selectedRange == EnergyRange.monthly) {
                  int day = value.toInt();
                  if (day >= 1 && day <= spots.length) {
                    return Text(day.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 9));
                  }
                } else {
                  int hour = value.toInt();
                  if (hour >= 0 && hour <= 23) {
                    return Text(hour.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 9));
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
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.teal.withAlpha(50),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _rangeSelector(),
        const SizedBox(height: 6),
        _headerWidget(), // ✅ clickable with calendar
        const SizedBox(height: 12),
        SizedBox(height: 200, child: _lineChart()),
      ],
    );
  }
}

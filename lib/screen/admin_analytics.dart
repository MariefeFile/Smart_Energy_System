// screen/admin_analytics.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Gradient background (same as admin_home.dart)
      body: Stack(
        children: [
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
              // ✅ Top AppBar style (same as HomeScreen)
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
                  child: const Center(
                    child: Text(
                      "System Analytics",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ Charts Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Top Row (Pie chart + Bar chart)
                        Row(
                          children: [
                            Expanded(child: _buildEnergySourcePie()),
                            const SizedBox(width: 16),
                            Expanded(child: _buildUsageBarChart()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Bottom Row (Trends chart)
                        _buildConsumptionTrend(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Energy Source Pie Chart
  Widget _buildEnergySourcePie() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Energy Source Breakdown",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 45, title: "Solar", color: Colors.orange, radius: 60),
                  PieChartSectionData(value: 30, title: "Wind", color: Colors.blue, radius: 60),
                  PieChartSectionData(value: 25, title: "Grid", color: Colors.green, radius: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Usage Bar Chart
  Widget _buildUsageBarChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top Consumers (kW)",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text("Building A", style: TextStyle(color: Colors.white70, fontSize: 10));
                          case 1:
                            return const Text("Building B", style: TextStyle(color: Colors.white70, fontSize: 10));
                          case 2:
                            return const Text("Lab", style: TextStyle(color: Colors.white70, fontSize: 10));
                          case 3:
                            return const Text("Office", style: TextStyle(color: Colors.white70, fontSize: 10));
                        }
                        return const Text("");
                      },
                    ),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45, color: Colors.blue)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 32, color: Colors.green)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 55, color: Colors.orange)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 28, color: Colors.purple)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Consumption Trend Line Chart
  Widget _buildConsumptionTrend() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Consumption Trend (7 days)",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 50),
                      FlSpot(1, 42),
                      FlSpot(2, 60),
                      FlSpot(3, 55),
                      FlSpot(4, 70),
                      FlSpot(5, 65),
                      FlSpot(6, 80),
                    ],
                    isCurved: true,
                    color: Colors.tealAccent,
                    barWidth: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable card style (dark gradient like HomeScreen)
  BoxDecoration _cardStyle() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((255 * 0.2).toInt()),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

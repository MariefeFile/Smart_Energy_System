import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartenergy_app/main.dart';
import 'package:smartenergy_app/screen/admin_home.dart';
import 'package:smartenergy_app/screen/analytics.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  bool _isDarkMode = false;

  final List<Map<String, dynamic>> features = const [
    {
      'title': '📢 Latest Industry News',
      'details': [
        'Smart grid and energy updates from IEEE and Smart Energy International.',
        'Global developments in renewables and smart systems.',
      ]
    },
    {
      'title': '⚙️ Smart Energy Technologies',
      'details': [
        'IoT-based energy monitoring systems.',
        'AI for demand forecasting and load balancing.',
        'Smart meters and microgrid integration.'
      ]
    },
    // Add other features here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          const Positioned.fill(child: BackgroundShapes()),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.white.withValues(alpha: 0.8),
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return FeatureCard(
                      title: feature['title'] as String,
                      details: List<String>.from(feature['details'] as List),
                    );
                  },
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
        backgroundColor: Colors.black.withValues(alpha: 0.4),
        currentIndex: 1, // Explore
        onTap: (index) {
          Widget page;
          switch (index) {
            case 0:
              page = const HomeScreen();
              break;
            case 1:
              return; // Already in Explore
            case 2:
              page = const AnalyticsScreen();
              break;
            case 3:
            case 4:
            case 5:
              return; // Not implemented
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

  // ---------- Helper Widgets ----------

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

  Widget breakdownTile(IconData icon, String label, String value, double percent) {
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
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
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
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Feature Card ----------
class FeatureCard extends StatelessWidget {
  final String title;
  final List<String> details;

  const FeatureCard({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.85),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        iconColor: Colors.blueAccent,
        collapsedIconColor: Colors.black54,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: details
            .map(
              (detail) => ListTile(
                title: Text(detail),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            )
            .toList(),
      ),
    );
  }
}

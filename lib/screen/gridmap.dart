import 'package:flutter/material.dart';

class SmartEnergyGrid extends StatelessWidget {
  const SmartEnergyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Gradient Background (same as admin_analytics.dart)
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
              // ✅ Custom Top AppBar (same style as AdminAnalytics)
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
                      "Smart Energy Grid Map",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ Grid Section
              Expanded(
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: GridView.count(
      crossAxisCount: 3, // ✅ Changed from 2 → 3
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _gridItem("Breaker 1", true, Icons.power, Colors.green),
        _gridItem("Breaker 2", false, Icons.power_off, Colors.red),
        _gridItem("Sensor A", true, Icons.sensors, Colors.blue),
        _gridItem("Sensor B", false, Icons.warning, Colors.orange),
        _gridItem("Main Line", true, Icons.bolt, Colors.yellow),
        _gridItem("Backup Line", false, Icons.electric_bolt, Colors.grey),
      ],
    ),
  ),
),
            ],
          ),
        ],
      ),

      // ✅ Bottom Legend (kept same style, but matches dark background)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0f1419).withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LegendItem(color: Colors.green, label: "Active"),
            LegendItem(color: Colors.red, label: "Off / Fault"),
            LegendItem(color: Colors.blue, label: "Sensor OK"),
            LegendItem(color: Colors.orange, label: "Sensor Warning"),
          ],
        ),
      ),
    );
  }

  // ✅ Updated card style (same as AdminAnalytics dark gradient cards)
  static Widget _gridItem(String title, bool status, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.2).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              status ? "Online" : "Offline",
              style: TextStyle(color: status ? Colors.greenAccent : Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

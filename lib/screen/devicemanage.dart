// screen/devicemanage.dart
import 'package:flutter/material.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final List<Map<String, dynamic>> devices = [
    {"name": "Smart Home", "status": true, "icon": Icons.home},
    {"name": "Energy Meter", "status": false, "icon": Icons.flash_on},
    {"name": "Solar Panel", "status": true, "icon": Icons.wb_sunny},
    {"name": "Battery Storage", "status": false, "icon": Icons.battery_charging_full},
    {"name": "EV Charger", "status": true, "icon": Icons.ev_station},
    {"name": "Wind Turbine", "status": false, "icon": Icons.wind_power},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Use gradient background (same as admin_home.dart)
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
              // ✅ Top AppBar style (similar to admin_home.dart)
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
                      "Device Management",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ Device List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.teal.withAlpha(50),
                            child: Icon(device["icon"],
                                color: Colors.tealAccent, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  device["status"] ? "Online" : "Offline",
                                  style: TextStyle(
                                    color: device["status"]
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: device["status"],
                            onChanged: (value) {
                              setState(() {
                                devices[index]["status"] = value;
                              });
                            },
                            activeColor: Colors.greenAccent,
                            inactiveThumbColor: Colors.redAccent,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      // ✅ Floating Action Button styled
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          // Add new device logic here
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Device", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

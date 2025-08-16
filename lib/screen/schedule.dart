import 'package:flutter/material.dart';
 import '../main.dart'; 
import 'admin_home.dart';
import 'explore.dart';
import 'analytics.dart';
import 'settings.dart';
import 'profile.dart';

class EnergySchedulingScreen extends StatefulWidget {
  const EnergySchedulingScreen({super.key});

  @override
  State<EnergySchedulingScreen> createState() =>
      _EnergySchedulingScreenState();
}

class _EnergySchedulingScreenState extends State<EnergySchedulingScreen> {
  bool _isDarkMode = false;
  int _currentIndex = 3;

  // 🔹 Store scheduled tasks
  final List<Map<String, dynamic>> _scheduledTasks = [
    {
      "device": "Air Conditioner",
      "time": "2:00 PM - 4:00 PM",
      "energy": "2.4 kWh",
      "cost": "₱18.50",
      "icon": Icons.ac_unit
    },
    {
      "device": "Washing Machine",
      "time": "6:00 PM - 7:30 PM",
      "energy": "1.8 kWh",
      "cost": "₱14.20",
      "icon": Icons.local_laundry_service
    },
    {
      "device": "Lights",
      "time": "7:00 PM - 10:00 PM",
      "energy": "0.9 kWh",
      "cost": "₱6.70",
      "icon": Icons.lightbulb
    },
  ];

  // 🔹 Dropdown values for new task
  String? selectedHour;
  String? selectedMinute;
  String? selectedDevice;

  final List<String> hours =
      List.generate(24, (index) => index.toString().padLeft(2, '0'));
  final List<String> minutes =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));
  final List<String> devices = [
    "Air Conditioner",
    "Washing Machine",
    "Lights",
    "Fan"
  ];

  // 🔹 Navigation
  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ExploreTab()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
    } else if (index == 3) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const EnergySchedulingScreen()));
    } else if (index == 4) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const EnergySettingScreen()));
    } else if (index == 5) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const EnergyProfileScreen()));
    }
  }

  // 🔹 Add new task dialog
  void _addTask() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Schedule New Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                hint: const Text("Select Device"),
                value: selectedDevice,
                items: devices
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) => setState(() => selectedDevice = val),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    hint: const Text("Hour"),
                    value: selectedHour,
                    items: hours
                        .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedHour = val),
                  ),
                  DropdownButton<String>(
                    hint: const Text("Minute"),
                    value: selectedMinute,
                    items: minutes
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedMinute = val),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (selectedDevice != null &&
                    selectedHour != null &&
                    selectedMinute != null) {
                  setState(() {
                    _scheduledTasks.add({
                      "device": selectedDevice!,
                      "time": "$selectedHour:$selectedMinute",
                      "energy": "0.5 kWh",
                      "cost": "₱5.00",
                      "icon": Icons.devices_other
                    });
                  });
                  Navigator.pop(context);

                  // Reset for next input
                  selectedDevice = null;
                  selectedHour = null;
                  selectedMinute = null;
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Remove task
  void _removeTask(int index) {
    setState(() {
      _scheduledTasks.removeAt(index);
    });
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          const Positioned.fill(child: BackgroundShapes()),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.white.withAlpha((255 * 0.8).toInt()),
                elevation: 0,
                title: const Text(
                  'Energy Scheduling',
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
        ],
      ),
        

        // 🔹 Foreground content
        Padding(
  padding: EdgeInsets.fromLTRB(
      16, kToolbarHeight + MediaQuery.of(context).padding.top + 16, 16, 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Eco Tip Banner
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50..withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Tip: Running the Washing Machine at 10 PM could save ₱5 (off-peak rate).",
                        style: TextStyle(
                            color: Colors.teal.shade900,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),

              // Next Scheduled Task
              if (_scheduledTasks.isNotEmpty) ...[
                Text("Next Scheduled Task",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600])),
                const SizedBox(height: 8),
                _buildTaskCard(_scheduledTasks[0], 0),
              ],

              const SizedBox(height: 24),

              // Upcoming Tasks
              const Text("Upcoming Tasks",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: _scheduledTasks.length > 1
                    ? ListView.builder(
                        itemCount: _scheduledTasks.length - 1,
                        itemBuilder: (context, index) {
                          return _buildTaskCard(
                              _scheduledTasks[index + 1], index + 1);
                        },
                      )
                    : const Center(
                        child: Text("No upcoming tasks."),
                      ),
              ),

              // Add Task Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _addTask,
                  child: const Text("Add Task",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black.withAlpha((255 * 0.4).toInt()),
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: "Energy"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analytics"),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Schedule"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    ),
  );
}
  // 🔹 Task Card Widget (screenshot style)
Widget _buildTaskCard(Map<String, dynamic> task, int index) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16), // increased margin
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16), // increased padding
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16), // slightly larger border radius
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha((255 * 0.15).toInt()),
          blurRadius: 8, // increased blur
          offset: const Offset(0, 4), // increased offset
        )
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 32, // increased from 24 to 32
          backgroundColor: Colors.blue.shade50,
          child: Icon(task["icon"], size: 32, color: Colors.blue), // increased icon size
        ),
        const SizedBox(width: 16), // increased spacing
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task["device"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)), // increased from 14 to 16
              const SizedBox(height: 4), // increased spacing
              Text(task["time"],
                  style: const TextStyle(color: Colors.grey, fontSize: 14)), // increased from 12 to 14
              const SizedBox(height: 6), // increased spacing
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // increased padding
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8), // increased border radius
                ),
                child: Text("Estimated energy: ${task["energy"]}",
                    style: const TextStyle(fontSize: 12, color: Colors.green)), // increased from 10 to 12
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(task["cost"],
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)), // increased from 14 to 16
            const SizedBox(height: 8), // added spacing between cost and delete button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 22), // increased from 18 to 22
              onPressed: () => _removeTask(index),
              padding: const EdgeInsets.all(4), // added some padding
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32), // minimum touch target
            ),
          ],
        )
      ],
    ),
  );
}}
import 'package:flutter/material.dart';
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

class _EnergySchedulingScreenState extends State<EnergySchedulingScreen>
    with TickerProviderStateMixin {
  bool _isDarkMode = false;
  int _currentIndex = 3;

  late AnimationController _profileController;
  late Animation<Offset> _profileSlideAnimation;
  late Animation<double> _profileScaleAnimation;

  @override
  void initState() {
    super.initState();

    _profileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _profileSlideAnimation = Tween<Offset>(
      begin: const Offset(0.2, -0.2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack));

    _profileScaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
        CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack));
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

  // Scheduled tasks
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

  String? selectedHour;
  String? selectedMinute;
  String? selectedDevice;

  final List<String> hours =
      List.generate(24, (index) => index.toString().padLeft(2, '0'));
  final List<String> minutes =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));
  final List<String> devices = ["Air Conditioner", "Washing Machine", "Lights", "Fan"];

  // Bottom nav
  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);

    Widget page;
    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const ExploreTab();
        break;
      case 2:
        page = const AnalyticsScreen();
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  // Add task
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
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
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

  void _editTask(int index) {
    final task = _scheduledTasks[index];

    String editedDevice = task["device"];
    String editedTime = task["time"];
    String editedEnergy = task["energy"];
    String editedCost = task["cost"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Device"),
                controller: TextEditingController(text: editedDevice),
                onChanged: (value) => editedDevice = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Time"),
                controller: TextEditingController(text: editedTime),
                onChanged: (value) => editedTime = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Energy"),
                controller: TextEditingController(text: editedEnergy),
                onChanged: (value) => editedEnergy = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Cost"),
                controller: TextEditingController(text: editedCost),
                onChanged: (value) => editedCost = value,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _scheduledTasks[index] = {
                    "device": editedDevice,
                    "time": editedTime,
                    "energy": editedEnergy,
                    "cost": editedCost,
                    "icon": task["icon"]
                  };
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

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
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a2332), Color(0xFF0f1419)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tip
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withAlpha(50),
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
                        ),
                      ],
                    ),
                  ),
                  if (_scheduledTasks.isNotEmpty) ...[
                    Text("Next Scheduled Task",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[400])),
                    const SizedBox(height: 8),
                    _buildTaskCard(_scheduledTasks[0], 0),
                  ],
                  const SizedBox(height: 24),
                  const Text("Upcoming Tasks",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 5),
                  Column(
                    children: _scheduledTasks.length > 1
                        ? _scheduledTasks
                            .sublist(1)
                            .asMap()
                            .entries
                            .map((entry) =>
                                _buildTaskCard(entry.value, entry.key + 1))
                            .toList()
                        : [
                            const Text(
                              "No upcoming tasks.",
                              style: TextStyle(color: Colors.white70),
                            )
                          ],
                  ),
                  const SizedBox(height: 20),
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
                  ),
                ],
              ),
            ),
          ),

          // Top AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(200),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 2)),
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
          ),

          // Profile Popover
          Positioned(
            top: 70,
            right: 12,
            child: FadeTransition(
              opacity: _profileController,
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
                          child: Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text('Marie Fe Tapales',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('marie@example.com',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            _profileController.reverse();
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (!mounted) return;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const EnergyProfileScreen()));
                            });
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
        backgroundColor: Colors.black.withAlpha(100),
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

  // Task card
  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withAlpha(25),
            child: Icon(task["icon"], size: 22, color: Colors.tealAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task["device"],
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 2),
                Text(task["time"],
                    style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text("Energy: ${task["energy"]}",
                      style: const TextStyle(fontSize: 11, color: Colors.white)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(task["cost"],
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
                    onPressed: () => _editTask(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _removeTask(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

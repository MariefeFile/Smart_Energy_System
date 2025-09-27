import 'package:flutter/material.dart';
import 'profile.dart';
import 'custom_bottom_nav.dart';

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

  // Add task
  void _addTask() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Schedule New Task", style: TextStyle(fontSize: 14)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                hint: const Text("Select Device", style: TextStyle(fontSize: 12)),
                value: selectedDevice,
                items: devices
                    .map((d) => DropdownMenuItem(
                        value: d, child: Text(d, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) => setState(() => selectedDevice = val),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    hint: const Text("Hour", style: TextStyle(fontSize: 12)),
                    value: selectedHour,
                    items: hours
                        .map((h) => DropdownMenuItem(
                            value: h, child: Text(h, style: const TextStyle(fontSize: 12))))
                        .toList(),
                    onChanged: (val) => setState(() => selectedHour = val),
                  ),
                  DropdownButton<String>(
                    hint: const Text("Minute", style: TextStyle(fontSize: 12)),
                    value: selectedMinute,
                    items: minutes
                        .map((m) => DropdownMenuItem(
                            value: m, child: Text(m, style: const TextStyle(fontSize: 12))))
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
                child: const Text("Cancel", style: TextStyle(fontSize: 12))),
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
              child: const Text("Save", style: TextStyle(fontSize: 12)),
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
          title: const Text("Edit Task", style: TextStyle(fontSize: 14)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Device"),
                style: const TextStyle(fontSize: 12),
                controller: TextEditingController(text: editedDevice),
                onChanged: (value) => editedDevice = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Time"),
                style: const TextStyle(fontSize: 12),
                controller: TextEditingController(text: editedTime),
                onChanged: (value) => editedTime = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Energy"),
                style: const TextStyle(fontSize: 12),
                controller: TextEditingController(text: editedEnergy),
                onChanged: (value) => editedEnergy = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Cost"),
                style: const TextStyle(fontSize: 12),
                controller: TextEditingController(text: editedCost),
                onChanged: (value) => editedCost = value,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(fontSize: 12))),
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
              child: const Text("Save", style: TextStyle(fontSize: 12)),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tip
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.teal, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Tip: Running the Washing Machine at 10 PM could save ₱5 (off-peak rate).",
                            style: TextStyle(
                                fontSize: 11,
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
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[400])),
                    const SizedBox(height: 6),
                    _buildTaskCard(_scheduledTasks[0], 0),
                  ],
                  const SizedBox(height: 16),
                  const Text("Upcoming Tasks",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
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
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            )
                          ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _addTask,
                      child: const Text("Add Task",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
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
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(200),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.add, color: Colors.teal, size: 18),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Smart Energy System',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.teal, size: 18),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: Colors.teal,
                        size: 18,
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
                        radius: 14,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),

          // Profile Popover
          Positioned(
            top: 60,
            right: 8,
            child: FadeTransition(
              opacity: _profileController,
              child: SlideTransition(
                position: _profileSlideAnimation,
                child: ScaleTransition(
                  scale: _profileScaleAnimation,
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(150),
                          blurRadius: 8,
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
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        const SizedBox(height: 8),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.person, size: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Text('Marie Fe Tapales',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        const Text('marie@example.com',
                            style: TextStyle(color: Colors.white70, fontSize: 10)),
                        const SizedBox(height: 8),
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
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: _profileController.reverse,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            minimumSize: const Size.fromHeight(28),
                          ),
                          child: const Text('Close', style: TextStyle(fontSize: 12)),
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
        currentIndex: _currentIndex,
        onTap: (index, page) {
          setState(() {
            _currentIndex = index;
          });
          if (index != 3) { // prevent reloading the same page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          }
        },
      ),
    );
  }

  // Task card
  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withAlpha(25),
            child: Icon(task["icon"], size: 16, color: Colors.tealAccent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task["device"],
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 2),
                Text(task["time"],
                    style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("Energy: ${task["energy"]}",
                      style: const TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(task["cost"],
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange, size: 16),
                    onPressed: () => _editTask(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 16),
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

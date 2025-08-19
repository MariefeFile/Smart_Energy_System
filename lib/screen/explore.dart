import 'package:flutter/material.dart';
import 'package:smartenergy_app/screen/analytics.dart';
import 'package:smartenergy_app/screen/schedule.dart';
import 'package:smartenergy_app/screen/settings.dart';
import 'package:smartenergy_app/screen/profile.dart';
import 'package:smartenergy_app/screen/admin_home.dart';
import 'chatbot.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> with TickerProviderStateMixin {
  bool _isDarkMode = false;
  String _searchQuery = '';

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> features = [
    {
      "icon": Icons.bolt,
      "color": Colors.orange,
      "title": "Energy Usage",
      "description":
          "Monitor your real-time electricity consumption, identify high-usage devices, and track trends.",
      "screen": const HomeScreen(),
    },
    {
      "icon": Icons.analytics,
      "color": Colors.teal,
      "title": "Energy Analytics",
      "description":
          "View insights, detect trends, and generate reports to optimize energy efficiency.",
      "screen": const AnalyticsScreen(),
    },
    {
      "icon": Icons.schedule,
      "color": Colors.blue,
      "title": "Energy Scheduling",
      "description":
          "Plan and automate appliance usage to save energy and reduce costs.",
      "screen": const EnergySchedulingScreen(),
    },
    {
      "icon": Icons.settings,
      "color": Colors.orange,
      "title": "Energy Settings",
      "description":
          "Customize preferences, adjust schedules, and manage connected devices.",
      "screen": const EnergySettingScreen(),
    },
    {
      "icon": Icons.person,
      "color": Colors.blue,
      "title": "Profile",
      "description":
          "Manage account details, update personal info, and set preferences.",
      "screen": const EnergyProfileScreen(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFeatures = features.where((feature) {
      final title = feature['title'] as String;
      final details = feature['description'] as String;
      final query = _searchQuery.toLowerCase();
      return title.toLowerCase().contains(query) ||
          details.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
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

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // AppBar
                  Container(
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
                    child: Row(
  children: [
    const SizedBox(width: 16),
    const Icon(Icons.add, color: Colors.teal), // <- changed here
    const SizedBox(width: 16),
    const Expanded(
      child: Text(
        'Explore More',
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
    const CircleAvatar(
      backgroundColor: Colors.teal,
      child: Icon(Icons.person, color: Colors.white),
    ),
    const SizedBox(width: 12),
  ],
),

                  ),

                  const SizedBox(height: 16),

                  // Body as Expanded ListView
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      children: [
                        // Search + Chatbot
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search features...',
                                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                                  filled: true,
                                  fillColor: Colors.white.withAlpha(200),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.chat, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ChatbotScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Quick Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _quickActionButton(
                              icon: Icons.info,
                              label: "Guidance",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Guidance: Smart Energy System'),
                                    content: const Text(
                                      'The Smart Energy System monitors, analyzes, '
                                      'and optimizes electricity consumption with real-time '
                                      'data, analytics, scheduling, and customizable settings.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            _quickActionButton(
                              icon: Icons.picture_as_pdf,
                              label: "Paper Works",
                              onPressed: () {},
                            ),
                            const SizedBox(width: 12),
                            _quickActionButton(
                              icon: Icons.star,
                              label: "Features",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Features: Smart Energy System'),
                                    content: const Text(
                                      '• Real-time electricity monitoring\n'
                                      '• Usage analytics & reports\n'
                                      '• Automated appliance scheduling\n'
                                      '• Customizable energy-saving modes\n'
                                      '• Mobile app control and notifications',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Feature Cards
                        ...filteredFeatures.map((feature) => _buildFeatureCard(feature)),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
        backgroundColor: Colors.black.withAlpha(100),
        showUnselectedLabels: true,
        currentIndex: 1,
        onTap: (index) {
          Widget page;
          switch (index) {
            case 0:
              page = const HomeScreen();
              break;
            case 1:
              return;
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

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF1f2937),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: feature['color'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(feature['icon'], color: Colors.white, size: 28),
        ),
        title: Text(
          feature['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          feature['description'],
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => feature['screen']),
          );
        },
      ),
    );
  }


  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
    );
  }
}

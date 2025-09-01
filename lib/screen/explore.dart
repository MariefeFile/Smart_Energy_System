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
  

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  

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
                                  hintText: 'Search devices....',
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
                            
                            
                           
                          ],
                        ),

                        

                        // Feature Cards
                        

                        
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

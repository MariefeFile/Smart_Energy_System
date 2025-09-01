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

  late AnimationController _profileController;
  late Animation<Offset> _profileSlideAnimation;
  late Animation<double> _profileScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation for main content
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    // Profile popover animation
    _profileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _profileSlideAnimation = Tween<Offset>(
      begin: const Offset(0.2, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack));

    _profileScaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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

                const SizedBox(height: 16),

                // Main Body
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      children: [
                        const Text(
                          'Explore More',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Search and Chat
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 12),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text('Marie Fe Tapales',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('marie@example.com',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            _profileController.reverse();
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (!mounted) return;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const EnergyProfileScreen()));
                            });
                          },
                          child: const Text('View Profile',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
        backgroundColor: Colors.black.withAlpha(100),
        showUnselectedLabels: true,
        currentIndex: 1, // Explore tab
        onTap: (index) {
          if (index == 1) return; // Stay on Explore
          Widget page;
          switch (index) {
            case 0:
              page = const HomeScreen();
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

import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'explore.dart';
import 'analytics.dart';
import 'schedule.dart';
import 'settings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login.dart';

class EnergyProfileScreen extends StatefulWidget {
  const EnergyProfileScreen({super.key});

  @override
  State<EnergyProfileScreen> createState() => _EnergyProfileScreenState();
}

class _EnergyProfileScreenState extends State<EnergyProfileScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 5; // Profile tab
  late AnimationController _animationController;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ExploreTab()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const EnergySchedulingScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const EnergySettingScreen()));
        break;
      case 5:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Gradient background matching admin_home.dart
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
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildProfileCard(),
                        const SizedBox(height: 20),
                        _buildMenuOptions(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
        backgroundColor: Colors.black.withAlpha((255 * 0.4).toInt()),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Energy'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _isDarkMode
          ? Colors.grey[850]?.withValues(alpha: 0.8)
          : Colors.white.withValues(alpha: 0.8),
      elevation: 0,
      title: const Text(
        'Smart Energy System',
        style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildProfileCard() {
    return Container(
      
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.3 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            
            // Profile Header
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF4ECDC4), width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile_avatar.jpg', // Add your image asset
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const CircleAvatar(
                          backgroundColor: Color(0xFF4ECDC4),
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      
                      const Text(
                        'Marie Fe Tapales',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Home Owner',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey[400]),
                  onPressed: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Energy Stats Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Energy Stats',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                   children: [
          _buildStatItem('Current Energy Usage', '350'),
          const SizedBox(height: 15),
          _buildStatItem('Monthly Savings', '₱25'), // ✅ Peso sign here
          const SizedBox(height: 15),
          _buildStatItem('Carbon Reduction', '120'),
        ],
                  ),
                ),
                const SizedBox(width: 30),
                // Circular Progress Indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: 0.7,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withAlpha((0.2 * 255).toInt()),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF10b981),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          '120',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'kg CO₂',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOptions() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.3 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.person_outline, 'Personal Info', () {}),
          _buildDivider(),
          _buildMenuItem(Icons.security, 'Security', () {}),
          _buildDivider(),
          _buildMenuItem(Icons.notifications_outlined, 'Notifications', () {}),
          _buildDivider(),
          _buildMenuItem(Icons.devices, 'Connected Devices', () {}),
          _buildDivider(),
          _buildMenuItem(Icons.bar_chart, 'View Energy History', () {}),
          _buildDivider(),
          _buildMenuItem(Icons.settings, 'Manage Smart Devices', () {}),
          
          const SizedBox(height: 20),
          
          // Help & Support and Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Help & Support',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, 
        color: Colors.grey[400], size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Divider(color: Colors.white.withAlpha((0.2 * 255).toInt()), height: 1),
    );
  }

  void _showLogoutDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1e293b),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog first

              // ✅ If using Google Sign-In
              try {
                final googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
              } catch (e) {
                debugPrint("Google sign out error: $e");
              }

              // ✅ Navigate to AuthPage and clear back stack
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthPage()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

}
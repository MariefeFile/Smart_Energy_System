import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'explore.dart';
import 'analytics.dart';
import 'schedule.dart';
import 'profile.dart';

class EnergySettingScreen extends StatefulWidget {
  const EnergySettingScreen({super.key});

  @override
  State<EnergySettingScreen> createState() => _EnergySettingScreenState();
}

class _EnergySettingScreenState extends State<EnergySettingScreen>
    with TickerProviderStateMixin {
  bool smartScheduling = true;
  bool peakHourAlerts = true;
  double powerSavingLevel = 0.6;
  bool _isDarkMode = false;
  int _currentIndex = 4; // Settings tab index

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _profileController;
  late Animation<Offset> _profileSlideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _profileController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _profileSlideAnimation = Tween<Offset>(
      begin: const Offset(0.2, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  void _toggleProfile() {
    if (_profileController.isCompleted) {
      _profileController.reverse();
    } else {
      _profileController.forward();
    }
  }

  String get powerSavingText {
    if (powerSavingLevel < 0.33) return 'Low';
    if (powerSavingLevel > 0.66) return 'High';
    return 'Medium';
  }

  void _navigateToConnectedDevices() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _navigateToAddDevice() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExploreTab()),
    );
  }

  void _navigateToThemeSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
    );
  }

  void _navigateToProfileSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EnergyProfileScreen()),
    );
  }

  void _navigateToSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EnergySchedulingScreen()),
    );
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: const Color.fromARGB(255, 53, 44, 44),
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const ExploreTab()));
        } else if (index == 2) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
        } else if (index == 3) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const EnergySchedulingScreen()));
        } else if (index == 4) {
          setState(() {
            _currentIndex = index;
          });
        } else if (index == 5) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const EnergyProfileScreen()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Energy'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Analytics'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background & main content
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a2332), Color(0xFF0f1419)],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildEnergyUsage(),
                      const SizedBox(height: 40),
                      _buildEnergyManagement(),
                      const SizedBox(height: 40),
                      _buildDeviceManagement(),
                      const SizedBox(height: 40),
                      _buildPreferences(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
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
                  color: Colors.white.withValues(alpha: 0.8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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
                  scale: _profileController,
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
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Marie Fe Tapales',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'marie@example.com',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: const Text(
        'Settings',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEnergyUsage() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  "Today's Energy Usage",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '7.4 kWh',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _navigateToSchedule,
                  child: Text(
                    'Next Task: 10:30 AM',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildCircularProgress(),
        ],
      ),
    );
  }

  Widget _buildCircularProgress() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                startAngle: 0,
                endAngle: 1.2,
                colors: [Color(0xFFf59e0b), Color(0xFF1e293b)],
                stops: [0.2, 0.2],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('ENERGY MANAGEMENT'),
        const SizedBox(height: 20),
        _buildSettingItem(
          icon: Icons.schedule,
          iconColor: const Color(0xFF10b981),
          title: 'Smart Scheduling',
          trailing: Switch(
            value: smartScheduling,
            onChanged: (value) {
              setState(() {
                smartScheduling = value;
              });
              if (value) {
                _navigateToSchedule();
              }
            },
            activeColor: const Color(0xFF10b981),
          ),
        ),
        _buildSettingItem(
          icon: Icons.notifications,
          iconColor: const Color(0xFFf59e0b),
          title: 'Peak Hour Alerts',
          trailing: Switch(
            value: peakHourAlerts,
            onChanged: (value) {
              setState(() {
                peakHourAlerts = value;
              });
            },
            activeColor: const Color(0xFF10b981),
          ),
        ),
        _buildSettingItem(
          icon: Icons.power_settings_new,
          iconColor: const Color(0xFF10b981),
          title: 'Power Saving Mode',
        ),
        const SizedBox(height: 15),
        _buildPowerSlider(),
      ],
    );
  }

  Widget _buildPowerSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF10b981),
            inactiveTrackColor: const Color(0xFF1e293b),
            thumbColor: const Color(0xFF10b981),
            overlayColor: const Color(0xFF10b981).withValues(alpha: 0.32),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: powerSavingLevel,
            onChanged: (value) {
              setState(() {
                powerSavingLevel = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Low', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
              Text('High', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          powerSavingText,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF10b981),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('DEVICE MANAGEMENT'),
        const SizedBox(height: 20),
        _buildSettingItem(
          icon: Icons.devices,
          iconColor: const Color(0xFF3b82f6),
          title: 'Connected Devices',
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
          onTap: _navigateToConnectedDevices,
        ),
        _buildSettingItem(
          icon: Icons.add,
          iconColor: const Color(0xFF10b981),
          title: 'Add New Device',
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
          onTap: _navigateToAddDevice,
        ),
      ],
    );
  }

  Widget _buildPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('PREFERENCES & ACCOUNT'),
        const SizedBox(height: 20),
        _buildSettingItem(
          icon: Icons.palette,
          iconColor: const Color(0xFF06b6d4),
          title: 'Theme & Units',
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
          onTap: _navigateToThemeSettings,
        ),
        _buildSettingItem(
          icon: Icons.person,
          iconColor: const Color(0xFF8b5cf6),
          title: 'Profile Settings',
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
          onTap: _navigateToProfileSettings,
        ),
        _buildSettingItem(
          icon: Icons.home,
          iconColor: const Color(0xFF10b981),
          title: 'Back to Home',
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
          onTap: _navigateToMain,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[400],
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF1e293b), width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: iconColor,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}

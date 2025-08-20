// screen/admin_setting.dart
import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<AdminSettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _autoUpdate = true;
  double _alertThreshold = 75;

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
              // ✅ Top AppBar style (semi-transparent like Analytics)
              SafeArea(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((255 * 0.85).toInt()),
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
                      "Admin Settings",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ Settings Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("General Settings"),
                      _cardWrapper(
                        Column(
                          children: [
                            SwitchListTile(
                              value: _darkMode,
                              title: const Text("Dark Mode", style: TextStyle(color: Colors.white)),
                              subtitle: const Text("Enable dark theme for dashboard",
                                  style: TextStyle(color: Colors.white70)),
                              secondary: const Icon(Icons.dark_mode, color: Colors.white70),
                              onChanged: (val) {
                                setState(() => _darkMode = val);
                              },
                            ),
                            SwitchListTile(
                              value: _notifications,
                              title: const Text("System Notifications", style: TextStyle(color: Colors.white)),
                              subtitle: const Text("Receive alerts about energy usage",
                                  style: TextStyle(color: Colors.white70)),
                              secondary: const Icon(Icons.notifications_active, color: Colors.white70),
                              onChanged: (val) {
                                setState(() => _notifications = val);
                              },
                            ),
                            SwitchListTile(
                              value: _autoUpdate,
                              title: const Text("Auto Updates", style: TextStyle(color: Colors.white)),
                              subtitle: const Text("Enable automatic system updates",
                                  style: TextStyle(color: Colors.white70)),
                              secondary: const Icon(Icons.system_update, color: Colors.white70),
                              onChanged: (val) {
                                setState(() => _autoUpdate = val);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildSectionTitle("Energy Monitoring"),
                      _cardWrapper(
                        Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.bolt, color: Colors.orange),
                              title: const Text("Alert Threshold",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              subtitle: Text("Set energy usage alert: ${_alertThreshold.toInt()}%",
                                  style: const TextStyle(color: Colors.white70)),
                            ),
                            Slider(
                              value: _alertThreshold,
                              min: 0,
                              max: 100,
                              divisions: 10,
                              activeColor: Colors.orange,
                              label: "${_alertThreshold.toInt()}%",
                              onChanged: (val) {
                                setState(() => _alertThreshold = val);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildSectionTitle("Account & Security"),
                      _cardWrapper(
                        Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.lock, color: Colors.red),
                              title: const Text("Change Admin Password",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
                              onTap: () {
                                // TODO: Navigate to change password screen
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.security, color: Colors.green),
                              title: const Text("Two-Factor Authentication",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              trailing: Switch(
                                value: true,
                                activeColor: Colors.green,
                                onChanged: (val) {
                                  // TODO: Implement toggle
                                },
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.exit_to_app, color: Colors.red),
                              title: const Text("Logout",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              onTap: () {
                                // TODO: Handle logout
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  // Wrapper Card with gradient style (same as Analytics)
  Widget _cardWrapper(Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1e293b), Color(0xFF0f172a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.2).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

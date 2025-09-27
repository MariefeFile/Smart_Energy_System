import 'package:flutter/material.dart';
import 'profile.dart'; // ✅ make sure this path is correct

class CustomHeader extends StatelessWidget {
  final bool isDarkMode;
  final bool isSidebarOpen;
  final VoidCallback onToggleDarkMode;

  const CustomHeader({
    super.key,
    required this.isDarkMode,
    required this.isSidebarOpen,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
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
              onPressed: () {
                // Optional: Add notifications page navigation here
              },
            ),
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.teal,
              ),
              onPressed: onToggleDarkMode,
            ),
            GestureDetector(
              onTap: () {
                // ✅ Navigate to profile.dart directly
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EnergyProfileScreen()),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

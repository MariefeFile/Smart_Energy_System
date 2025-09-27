import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final bool isDarkMode;
  final bool isSidebarOpen; 
  final VoidCallback onToggleDarkMode;
  final VoidCallback onToggleFeatures;
  final VoidCallback onToggleProfile;

  const CustomHeader({
    super.key,
    required this.isDarkMode,
     required this.isSidebarOpen, 
    required this.onToggleDarkMode,
    required this.onToggleFeatures,
    required this.onToggleProfile,
     
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
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.teal,
              ),
              onPressed: onToggleDarkMode,
            ),
            GestureDetector(
              onTap: onToggleFeatures,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.2 * 255).round()),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (j) {
                        return Container(
                          margin: const EdgeInsets.all(1.5),
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
            GestureDetector(
              onTap: onToggleProfile,
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

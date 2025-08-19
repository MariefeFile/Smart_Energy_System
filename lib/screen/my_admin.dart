import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<String> users = ['Alice', 'Bob', 'Charlie'];

  void _addUser() {
    setState(() {
      users.add('User ${users.length + 1}');
    });
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a2332), Color(0xFF0f1419)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Feature Cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(12),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _featureCard(
                      icon: Icons.history,
                      title: 'History',
                      color: Colors.orange,
                      iconSize: 30,
                      textSize: 14,
                      onTap: () {
                        _showMessage('Showing History...');
                      },
                    ),
                    _featureCard(
                      icon: Icons.update,
                      title: 'Updates',
                      color: Colors.blue,
                      iconSize: 30,
                      textSize: 14,
                      onTap: () {
                        _showMessage('Checking for Updates...');
                      },
                    ),
                    _featureCard(
                      icon: Icons.person_add,
                      title: 'Add User',
                      color: Colors.green,
                      iconSize: 30,
                      textSize: 14,
                      onTap: _addUser,
                    ),
                    _featureCard(
                      icon: Icons.person_remove,
                      title: 'Delete User',
                      color: Colors.red,
                      iconSize: 30,
                      textSize: 14,
                      onTap: () {
                        if (users.isNotEmpty) {
                          _deleteUser(users.length - 1);
                        } else {
                          _showMessage('No users to delete!');
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Users List
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Users',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                            leading: const Icon(Icons.person, color: Colors.white70, size: 20),
                            title: Text(users[index],
                                style: const TextStyle(color: Colors.white, fontSize: 14)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Feature Card Widget
  Widget _featureCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    double iconSize = 40,
    double textSize = 16,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.white),
            const SizedBox(height: 6),
            Text(title,
                style: TextStyle(
                    color: Colors.white, fontSize: textSize, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

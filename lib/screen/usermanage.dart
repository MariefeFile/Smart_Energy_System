import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {"name": "Alice Johnson", "role": "Admin", "status": "Active", "lastLogin": "2h ago"},
      {"name": "Bob Smith", "role": "User", "status": "Inactive", "lastLogin": "3 days ago"},
      {"name": "Charlie Lee", "role": "User", "status": "Suspended", "lastLogin": "1 week ago"},
      {"name": "Diana Prince", "role": "Moderator", "status": "Active", "lastLogin": "5h ago"},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // ✅ Gradient background (same as admin_analytics.dart)
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
              // ✅ Top AppBar style (like admin_analytics.dart)
              SafeArea(
                child: Container(
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
                  child: const Center(
                    child: Text(
                      "User Management",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary cards
                      Row(
                        children: [
                          _buildSummaryCard("Total Users", "120", Colors.blue),
                          const SizedBox(width: 16),
                          _buildSummaryCard("Active", "98", Colors.green),
                          const SizedBox(width: 16),
                          _buildSummaryCard("Inactive", "15", Colors.orange),
                          const SizedBox(width: 16),
                          _buildSummaryCard("Suspended", "7", Colors.red),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search bar
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search users...",
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.search, color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF1e293b).withValues(alpha: 0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User list
                      Expanded(
                        child: Container(
                          decoration: _cardStyle(),
                          child: ListView.separated(
                            itemCount: users.length,
                            separatorBuilder: (_, __) => Divider(color: Colors.white12),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              Color statusColor;
                              switch (user["status"]) {
                                case "Active":
                                  statusColor = Colors.green;
                                  break;
                                case "Inactive":
                                  statusColor = Colors.orange;
                                  break;
                                default:
                                  statusColor = Colors.red;
                              }
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.tealAccent,
                                  child: Text(user["name"]![0],
                                      style: const TextStyle(
                                          color: Colors.black, fontWeight: FontWeight.bold)),
                                ),
                                title: Text(user["name"]!, style: const TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  "Role: ${user["role"]} • Last Login: ${user["lastLogin"]}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(user["status"]!,
                                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.block, color: Colors.red),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
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

  // ✅ Reusable card style (same as admin_analytics.dart)
  BoxDecoration _cardStyle() {
    return BoxDecoration(
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
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardStyle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

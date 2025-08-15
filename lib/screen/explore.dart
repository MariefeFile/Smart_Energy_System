import 'package:flutter/material.dart';
//import 'package:smartenergy_app/screen/chatbot.dart';
import 'package:smartenergy_app/main.dart';
import 'package:smartenergy_app/screen/admin_home.dart';
import 'package:smartenergy_app/screen/analytics.dart';
import 'package:smartenergy_app/screen/schedule.dart';
import 'package:smartenergy_app/screen/settings.dart';
import 'package:smartenergy_app/screen/profile.dart';


class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}


class EnergyMenuScreen extends StatelessWidget {
  const EnergyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Energy Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2, // Two per row
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9, // Card height vs width ratio
          children: [
            _buildMenuCard(
              context,
              icon: Icons.bolt,
              color: Colors.orange,
              title: 'Energy Usage',
              description:
                  'Monitor your real-time electricity consumption, identify high-usage devices, and track trends.',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.analytics,
              color: Colors.teal,
              title: 'Energy Analytics',
              description:
                  'View insights, detect trends, and generate reports to optimize energy efficiency.',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AnalyticsScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.schedule,
              color: Colors.blue,
              title: 'Energy Scheduling',
              description:
                  'Plan and automate appliance usage to save energy and reduce costs.',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const EnergySchedulingScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.settings,
              color: Colors.orange,
              title: 'Energy Settings',
              description:
                  'Customize preferences, adjust schedules, and manage connected devices.',
              onTap: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EnergySettingScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.person,
              color: Colors.blue,
              title: 'Profile',
              description:
                  'Manage account details, update personal info, and set preferences.',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EnergyProfileScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
             color: Colors.white.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withAlpha(200),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreTabState extends State<ExploreTab> {
  bool _isDarkMode = false;
  String _searchQuery = '';

  final List<Map<String, dynamic>> features = const [
    
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFeatures = features.where((feature) {
      final title = feature['title'] as String;
      final details = (feature['details'] as List).join(' ');
      final query = _searchQuery.toLowerCase();
      return title.toLowerCase().contains(query) ||
          details.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          const Positioned.fill(child: BackgroundShapes()),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.white.withAlpha(204),
                elevation: 0,
                title: const Text(
                  'Smart Energy System',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
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
              ),

              // Search Bar with Chatbot
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search features...',
                          prefixIcon: const Icon(Icons.search, color: Colors.teal),
                          filled: true,
                          fillColor: Colors.white.withAlpha(200),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
              ),

// 🔹 Guidance Feature Box
// 🔹 Guidance Button
Center(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
    children: [
      // 🔹 Guidance Button
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.info, size: 24),
        label: const Text(
          'Guidance',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Guidance: Smart Energy System'),
              content: const Text(
                'The Smart Energy System is designed to monitor, analyze, '
                'and optimize electricity consumption. It provides real-time '
                'usage data, detailed analytics, automated scheduling, and '
                'customizable settings to help users save energy and reduce costs.',
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

      const SizedBox(width: 16), // Space between buttons

      // 🔹 Paper Works Button
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.picture_as_pdf, size: 24), // PDF icon
        label: const Text(
          'Paper Works',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          // TODO: Add code to open PDF
        },
      ),

      const SizedBox(width: 16), // Space between buttons

      // 🔹 Features Button
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.star, size: 24), // Star icon for features
        label: const Text(
          'Features',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
),

              // 🔹 Feature Box (Added here)
              InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()), // Update to your screen
    );
  },
  borderRadius: BorderRadius.circular(12), // ripple effect shape
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Container(
          width: 100,
          height: 80, // fixed height so the container is visible
          decoration: BoxDecoration(
            color: Colors.orange.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
          ),
         child: const Icon(Icons.analytics, color: Colors.white, size: 50),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Energy Usage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Monitor your real-time electricity consumption, identify high-usage devices, '
                'and receive insights on how to reduce energy waste. '
                'Track daily, weekly, and monthly trends for better efficiency.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),


             InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
    );
  },
  borderRadius: BorderRadius.circular(12), // for ripple effect
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Container(
          width: 100,
         height: 80,
          decoration: BoxDecoration(
            color: Colors.teal.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.analytics, color: Colors.white, size: 50),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Energy Analytics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'View detailed insights about your energy consumption, detect trends, '
                'and identify opportunities for saving costs.'
                'Track real-time energy usage and performance trends.'
        'Identify peak consumption periods and cost-saving opportunities.'
        'Generate reports to optimize energy efficiency and planning.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EnergySchedulingScreen()), // Replace with your actual screen
    );
  },
  borderRadius: BorderRadius.circular(12), // for ripple effect
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.schedule, color: Colors.white, size: 50),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Energy Scheduling',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Plan and automate when your appliances run to save energy and reduce costs. '
                'Set custom schedules for peak and off-peak hours to optimize usage.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
InkWell(
  onTap: () {
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const EnergySettingScreen()), // navigate to Energy Settings
  );
  },
  borderRadius: BorderRadius.circular(12), // ripple effect shape
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.orange.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.settings, color: Colors.white, size: 50),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Energy Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Configure and customize your energy system preferences. '
                'Adjust schedules, set power-saving modes, and manage connected devices '
                'to optimize performance and reduce energy costs.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
InkWell(
  onTap: () {
   Navigator.push(
    context,
      MaterialPageRoute(builder: (context) => const EnergyProfileScreen()), // navigate to Profile screen
    );
  },
  borderRadius: BorderRadius.circular(12), // ripple effect shape
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Container(
          width: 100,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 40),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage account details, update personal information, and set preferences.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),



              const SizedBox(height: 12),

              // Feature List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredFeatures.length,
                  itemBuilder: (context, index) {
                    final feature = filteredFeatures[index];
                    return FeatureCard(
                      title: feature['title'] as String,
                      details: List<String>.from(feature['details'] as List),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black.withAlpha(102),
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
}

// Feature Card
class FeatureCard extends StatelessWidget {
  final String title;
  final List<String> details;

  const FeatureCard({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withAlpha(217),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        iconColor: Colors.blueAccent,
        collapsedIconColor: Colors.black54,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: details
            .map(
              (detail) => ListTile(
                title: Text(detail),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            )
            .toList(),
      ),
    );
  }
}

// Chatbot Screen
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'message': text});
      _messages.add({
        'role': 'bot',
        'message': 'You said: "$text". I am your Smart Energy Assistant!'
      });
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Energy Chatbot'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

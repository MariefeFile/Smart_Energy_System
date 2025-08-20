// screen/my_admin.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SmartEnergyDashboard extends StatefulWidget {
  const SmartEnergyDashboard({super.key});

  @override
  State<SmartEnergyDashboard> createState() => _SmartEnergyDashboardState();
}

class _SmartEnergyDashboardState extends State<SmartEnergyDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1e293b),
                  Color(0xFF0f172a),
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: const [
                      Icon(Icons.flash_on, color: Colors.amber, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'EnergyOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildNavItem(0, Icons.dashboard, 'Overview'),
                      _buildNavItem(1, Icons.devices, 'Device Management'),
                      _buildNavItem(2, Icons.analytics, 'Analytics'),
                      _buildNavItem(3, Icons.people, 'User Management'),
                      _buildNavItem(4, Icons.settings, 'Settings'),
                      _buildNavItem(5, Icons.map, 'Grid Map'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a2332),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.2 * 255).toInt()),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Energy Dashboard',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Real-time monitoring and control',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications, size: 28, color: Colors.white),
                                onPressed: () {},
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          const CircleAvatar(
                            backgroundColor: Colors.tealAccent,
                            child: Text('A', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Metric Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                'Total Generation', '47.3 kW', Colors.green, Icons.wb_sunny, '+12.5%', true
                              )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                'Current Consumption', '38.9 kW', Colors.blue, Icons.home, '-3.2%', false
                              )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                'Battery Level', '84%', Colors.purple, Icons.battery_charging_full, 'Charging', null
                              )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                'Cost Savings', '\$1,247', Colors.amber, Icons.attach_money, 'This month', null
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Dashboard Grid
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildEnergyChart()),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _buildDeviceStatus(),
                                  const SizedBox(height: 24),
                                  _buildAlerts(),
                                ],
                              ),
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
        ],
      ),
    );
  }

  // NAVIGATION
  Widget _buildNavItem(int index, IconData icon, String title) {
    bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => _selectedIndex = index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // METRIC CARD
  Widget _buildMetricCard(String title, String value, Color color, IconData icon, String trend, bool? isPositive) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2332),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
              if (trend.isNotEmpty && isPositive != null)
                Row(
                  children: [
                    Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 16, color: isPositive ? Colors.green : Colors.red),
                    const SizedBox(width: 4),
                    Text(trend, style: TextStyle(color: isPositive ? Colors.green : Colors.red)),
                  ],
                )
              else
                Text(trend, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  // ENERGY CHART
  Widget _buildEnergyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2332),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Energy Flow (24H)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['0', '4', '8', '12', '16', '20', '24'];
                        return Text(labels[value.toInt() % labels.length], style: const TextStyle(color: Colors.white70, fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(), style: const TextStyle(color: Colors.white70, fontSize: 10));
                    }),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 45), FlSpot(1, 35), FlSpot(2, 80), FlSpot(3, 95), FlSpot(4, 75), FlSpot(5, 65), FlSpot(6, 50)],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: const [FlSpot(0, 30), FlSpot(1, 25), FlSpot(2, 65), FlSpot(3, 120), FlSpot(4, 90), FlSpot(5, 40), FlSpot(6, 35)],
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DEVICE STATUS
  Widget _buildDeviceStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2332),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Device Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildDeviceItem('Solar Panel Array A', 'Active', '12.4 kW', Colors.green, Icons.wb_sunny),
          _buildDeviceItem('Wind Turbine Unit 1', 'Inactive', '0 kW', Colors.red, Icons.air),
          _buildDeviceItem('Battery Storage', 'Charging', '84%', Colors.purple, Icons.battery_charging_full),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(String name, String status, String value, Color statusColor, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(status, style: TextStyle(color: statusColor)),
              ],
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // ALERTS
  Widget _buildAlerts() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2332),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 16),
          Text('⚠ Solar Panel A disconnected', style: TextStyle(color: Colors.redAccent)),
          SizedBox(height: 8),
          Text('⚠ High battery temperature detected', style: TextStyle(color: Colors.redAccent)),
        ],
      ),
    );
  }
}

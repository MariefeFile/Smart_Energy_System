import 'package:flutter/material.dart';

class ConnectedDevice {
  final String name;
  final IconData icon;
  final String status;
  double usage; // ✅ usage (kWh) for analytics
  double percent; // ✅ percent for breakdown bar

  ConnectedDevice({
    required this.name,
    required this.icon,
    required this.status,
    required this.usage,
    required this.percent,
  });
}

// ✅ Shared device list
List<ConnectedDevice> connectedDevices = [
  ConnectedDevice(
      name: "Rice Cooker",
      icon: Icons.kitchen,
      status: "On",
      usage: 78.1,
      percent: 0.46),
  ConnectedDevice(
      name: "Washing Machine",
      icon: Icons.local_laundry_service,
      status: "Off",
      usage: 20.5,
      percent: 0.15),
  ConnectedDevice(
      name: "TV",
      icon: Icons.tv,
      status: "On",
      usage: 15.2,
      percent: 0.12),
  ConnectedDevice(
      name: "Security Camera",
      icon: Icons.videocam,
      status: "Active",
      usage: 8.3,
      percent: 0.06),
  ConnectedDevice(
      name: "Smart Light",
      icon: Icons.lightbulb,
      status: "Off",
      usage: 12.7,
      percent: 0.09),
  ConnectedDevice(
      name: "Thermostat",
      icon: Icons.thermostat,
      status: "22°C",
      usage: 5.4,
      percent: 0.04),
  ConnectedDevice(
      name: "Cellphone",
      icon: Icons.phone_android,
      status: "Charging",
      usage: 2.1,
      percent: 0.02),
  ConnectedDevice(
      name: "Electric Fan",
      icon: Icons.toys,
      status: "On",
      usage: 10.0,
      percent: 0.07),
  ConnectedDevice(
      name: "Laptop",
      icon: Icons.laptop,
      status: "Idle",
      usage: 18.6,
      percent: 0.14),
];

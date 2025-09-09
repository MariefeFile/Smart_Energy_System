import 'package:flutter/material.dart';

class ConnectedDevice {
  final String name;
  final IconData icon;
  final String status;

  ConnectedDevice({required this.name, required this.icon, required this.status});
}

// Shared device list
List<ConnectedDevice> connectedDevices = [
  ConnectedDevice(name: "Rice Cooker", icon: Icons.kitchen, status: "On"),
  ConnectedDevice(name: "Washing Machine", icon: Icons.local_laundry_service, status: "Off"),
  ConnectedDevice(name: "TV", icon: Icons.tv, status: "On"),
  ConnectedDevice(name: "Security Camera", icon: Icons.videocam, status: "Active"),
  ConnectedDevice(name: "Smart Light", icon: Icons.lightbulb, status: "Off"),
  ConnectedDevice(name: "Thermostat", icon: Icons.thermostat, status: "22°C"),
  ConnectedDevice(name: "Cellphone", icon: Icons.phone_android, status: "Charging"),
  ConnectedDevice(name: "Electric Fan", icon: Icons.toys, status: "On"),
  ConnectedDevice(name: "Laptop", icon: Icons.laptop, status: "Idle"),
];

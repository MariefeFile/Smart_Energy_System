import 'package:flutter/material.dart';

class ConnectedDevicesList extends ChangeNotifier {
  final List<Map<String, dynamic>> connectedDevices = [
    {"name": "Rice Cooker", "icon": Icons.kitchen, "status": "On"},
    {"name": "Washing Machine", "icon": Icons.local_laundry_service, "status": "Off"},
    {"name": "TV", "icon": Icons.tv, "status": "On"},
    {"name": "Security Camera", "icon": Icons.videocam, "status": "Active"},
    {"name": "Smart Light", "icon": Icons.lightbulb, "status": "Off"},
    {"name": "Thermostat", "icon": Icons.thermostat, "status": "22°C"},
    {"name": "Cellphone", "icon": Icons.phone_android, "status": "Charging"},
    {"name": "Electric Fan", "icon": Icons.toys, "status": "On"},
    {"name": "Laptop", "icon": Icons.laptop, "status": "Idle"},
  ];

  void toggleDevice(int index) {
    if (index < 0 || index >= connectedDevices.length) return;

    String status = connectedDevices[index]["status"].toString().toLowerCase();
    if (status == "on") {
      connectedDevices[index]["status"] = "Off";
    } else if (status == "off") {
      connectedDevices[index]["status"] = "On";
    }
    notifyListeners();
  }

  void updateDeviceStatus(int index, String status) {
    if (index < 0 || index >= connectedDevices.length) return;
    connectedDevices[index]["status"] = status;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class EnergyProfileScreen extends StatelessWidget {
  const EnergyProfileScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Scheduling'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Energy scheduling page content goes here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

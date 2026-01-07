import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('setting'),
      ),
    );
  }
}
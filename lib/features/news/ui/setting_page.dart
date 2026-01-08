import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _debugNetwork = false;      // 通信デバッグON/OFF
  int _pageSize = 10;              // 一度に読み込む件数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const ListTile(
            title: Text(
              '通信',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // 通信デバッグON/OFF
          ListTile(
            title: const Text('Debug Network'),
            trailing: CupertinoSwitch(
              value: _debugNetwork,
              onChanged: (value) {
                setState(() {
                  _debugNetwork = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                _debugNetwork = !_debugNetwork;
              });
            },
          ),
          const Divider(height: 0),

          // pageSize 設定
          ListTile(
            title: const Text('Page Size'),
            trailing: DropdownButton<int>(
              value: _pageSize,
              items: const [
                DropdownMenuItem(
                  value: 5,
                  child: Text('5'),
                ),
                DropdownMenuItem(
                  value: 10,
                  child: Text('10'),
                ),
                DropdownMenuItem(
                  value: 20,
                  child: Text('20'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _pageSize = value;
                });
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

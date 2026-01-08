import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../data/settings_repository.dart';
import '../view_model/settings_view_model.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SettingsRepository>(
      future: SettingsRepository.create(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return ChangeNotifierProvider(
          create: (_) => SettingsViewModel(snap.data!),
          child: const _SettingBody(),
        );
      },
    );
  }
}

class _SettingBody extends StatelessWidget {
  const _SettingBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    if (vm.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          // DebugNetwork
          ListTile(
            title: const Text('Debug Network'),
            trailing: CupertinoSwitch(
              value: vm.debugNetwork,
              onChanged: vm.setDebugNetwork,
            ),
            onTap: () => vm.setDebugNetwork(!vm.debugNetwork),
          ),
          const Divider(height: 0),
          // PageSize
          ListTile(
            title: const Text('Page Size'),
            trailing: DropdownButton<int>(
              value: vm.pageSize,
              items: const [
                DropdownMenuItem(value: 5, child: Text('5')),
                DropdownMenuItem(value: 10, child: Text('10')),
                DropdownMenuItem(value: 20, child: Text('20')),
              ],
              onChanged: (v) {
                if (v != null) vm.setPageSize(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}

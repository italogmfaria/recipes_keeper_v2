import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações')),
      body: Center(child: Text('Configurações do App')),
    );
  }
}

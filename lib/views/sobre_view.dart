import 'package:flutter/material.dart';

class SobreView extends StatefulWidget {
  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre')),
      body: Center(child: Text('Sobre o App de Receitas')),
    );
  }
}

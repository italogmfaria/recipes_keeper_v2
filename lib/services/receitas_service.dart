import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/receita.dart';

class ReceitasService {
  Future<Map<String, dynamic>> _loadDatabase() async {
    final String response = await rootBundle.loadString('assets/db.json');
    return json.decode(response);
  }

  Future<List<Receita>> getReceitasDoces() async {
    final db = await _loadDatabase();
    final List<dynamic> jsonList = db['receitasDoces'];
    return jsonList.map((json) => Receita.fromJson(json)).toList();
  }

  Future<List<Receita>> getReceitasSalgadas() async {
    final db = await _loadDatabase();
    final List<dynamic> jsonList = db['receitasSalgadas'];
    return jsonList.map((json) => Receita.fromJson(json)).toList();
  }

  Future<List<Receita>> getReceitasBebidas() async {
    final db = await _loadDatabase();
    final List<dynamic> jsonList = db['receitasBebidas'];
    return jsonList.map((json) => Receita.fromJson(json)).toList();
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/receita.dart';

class ReceitasService {
  Map<String, List<Receita>> _database = {};

  Future<void> _loadDatabase() async {
    if (_database.isNotEmpty) return;
    final String response = await rootBundle.loadString('assets/db.json');
    final db = json.decode(response);
    _database['receitasDoces'] = (db['receitasDoces'] as List).map((json) => Receita.fromJson(json)).toList();
    _database['receitasSalgadas'] = (db['receitasSalgadas'] as List).map((json) => Receita.fromJson(json)).toList();
    _database['receitasBebidas'] = (db['receitasBebidas'] as List).map((json) => Receita.fromJson(json)).toList();
  }

  Future<List<Receita>> getReceitasDoces() async {
    await _loadDatabase();
    return _database['receitasDoces']!;
  }

  Future<List<Receita>> getReceitasSalgadas() async {
    await _loadDatabase();
    return _database['receitasSalgadas']!;
  }

  Future<List<Receita>> getReceitasBebidas() async {
    await _loadDatabase();
    return _database['receitasBebidas']!;
  }

  Future<void> toggleFavorite(int id, String categoria) async {
    await _loadDatabase();
    String? categoryKey;
    switch (categoria.toLowerCase()) {
      case 'doce':
        categoryKey = 'receitasDoces';
        break;
      case 'salgada':
        categoryKey = 'receitasSalgadas';
        break;
      case 'bebida':
        categoryKey = 'receitasBebidas';
        break;
    }

    if (categoryKey != null) {
      final categoryList = _database[categoryKey];
      if (categoryList != null) {
        final index = categoryList.indexWhere((r) => r.id == id);
        if (index != -1) {
          final oldRecipe = categoryList[index];
          categoryList[index] = oldRecipe.copyWith(isFavorite: !oldRecipe.isFavorite);
        }
      }
    }
  }

  Future<List<Receita>> getFavoriteReceitas() async {
    await _loadDatabase();
    final List<Receita> favorites = [];
    _database.values.forEach((list) {
      favorites.addAll(list.where((recipe) => recipe.isFavorite));
    });
    return favorites;
  }
}

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

    final Map<int, List<MapEntry<String, int>>> occurrences = {};
    int maxId = 0;

    for (var key in _database.keys) {
      for (var i = 0; i < _database[key]!.length; i++) {
        final r = _database[key]![i];
        occurrences.putIfAbsent(r.id, () => []).add(MapEntry(key, i));
        if (r.id > maxId) maxId = r.id;
      }
    }

    for (var entry in occurrences.entries) {
      final locations = entry.value;
      if (locations.length > 1) {
        for (var j = 1; j < locations.length; j++) {
          maxId++;
          final loc = locations[j];
          final old = _database[loc.key]![loc.value];
          _database[loc.key]![loc.value] = old.copyWith(id: maxId);
        }
      }
    }
  }

  String _getCategoryKey(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'doce':
        return 'receitasDoces';
      case 'salgada':
        return 'receitasSalgadas';
      case 'bebida':
        return 'receitasBebidas';
      default:
        throw ArgumentError('Categoria inválida: $categoria');
    }
  }

  Future<List<Receita>> getReceitasDoces() async {
    await _loadDatabase();
    return List.from(_database['receitasDoces']!);
  }

  Future<List<Receita>> getReceitasSalgadas() async {
    await _loadDatabase();
    return List.from(_database['receitasSalgadas']!);
  }

  Future<List<Receita>> getReceitasBebidas() async {
    await _loadDatabase();
    return List.from(_database['receitasBebidas']!);
  }

  Future<void> toggleFavorite(int id, String categoria) async {
    await _loadDatabase();
    final categoryKey = _getCategoryKey(categoria);
    final index = _database[categoryKey]!.indexWhere((r) => r.id == id);
    if (index != -1) {
      final recipe = _database[categoryKey]![index];
      _database[categoryKey]![index] = recipe.copyWith(isFavorite: !recipe.isFavorite);
    }
  }

  Future<List<Receita>> getFavoriteReceitas() async {
    await _loadDatabase();
    final List<Receita> favorites = [];
    for (var recipes in _database.values) {
      favorites.addAll(recipes.where((recipe) => recipe.isFavorite));
    }
    return favorites;
  }

  Future<int> _getNextGlobalId() async {
    await _loadDatabase();
    int maxId = 0;
    for (var recipes in _database.values) {
      if (recipes.isNotEmpty) {
        final categoryMax = recipes.map((r) => r.id).reduce((a, b) => a > b ? a : b);
        if (categoryMax > maxId) maxId = categoryMax;
      }
    }
    return maxId + 1;
  }

  Future<Receita> addReceita(Receita receita) async {
    await _loadDatabase();
    final categoryKey = _getCategoryKey(receita.categoria);
    final newId = await _getNextGlobalId();

    final newReceita = receita.copyWith(id: newId);
    _database[categoryKey]!.add(newReceita);

    return newReceita;
  }

  Future<Receita?> updateReceita(Receita receita) async {
    await _loadDatabase();

    String? oldCategoryKey;
    for (var entry in _database.entries) {
      final index = entry.value.indexWhere((r) => r.id == receita.id);
      if (index != -1) {
        oldCategoryKey = entry.key;
        _database[entry.key]!.removeAt(index);
        break;
      }
    }

    if (oldCategoryKey != null) {
      final newCategoryKey = _getCategoryKey(receita.categoria);

      final collision = _database[newCategoryKey]!.any((r) => r.id == receita.id);
      Receita toAdd = receita;
      if (collision) {
        final newId = await _getNextGlobalId();
        toAdd = receita.copyWith(id: newId);
      }

      _database[newCategoryKey]!.add(toAdd);
      return toAdd;
    }

    return null;
  }

  Future<bool> deleteReceita(Receita receita) async {
    await _loadDatabase();
    final categoryKey = _getCategoryKey(receita.categoria);
    final index = _database[categoryKey]!.indexWhere((r) => r.id == receita.id);
    if (index != -1) {
      _database[categoryKey]!.removeAt(index);
      return true;
    }
    return false;
  }
}

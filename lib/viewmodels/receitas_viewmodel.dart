import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import '../models/receita.dart';
import '../services/receitas_service.dart';

class _PendingDeletion {
  final Receita receita;
  final int? originalOrder;
  _PendingDeletion(this.receita, this.originalOrder);
}

class ReceitasViewModel extends ChangeNotifier {
  final ReceitasService _service = ReceitasService();

  List<Receita> _doces = [];
  List<Receita> _salgadas = [];
  List<Receita> _bebidas = [];
  List<Receita> _favoritas = [];
  bool _isLoading = false;
  String? _error;

  List<Receita> get doces => _doces;
  List<Receita> get salgadas => _salgadas;
  List<Receita> get bebidas => _bebidas;
  List<Receita> get favoritas => _favoritas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<int, int> _orderMap = {};

  void _rebuildOrderMap() {
    int counter = 0;
    _orderMap.clear();
    for (final r in _doces) {
      _orderMap[r.id] = counter++;
    }
    for (final r in _salgadas) {
      _orderMap[r.id] = counter++;
    }
    for (final r in _bebidas) {
      _orderMap[r.id] = counter++;
    }
  }

  Future<void> carregarReceitas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log('Iniciando carregamento das receitas');

      final results = await Future.wait([
        _service.getReceitasDoces(),
        _service.getReceitasSalgadas(),
        _service.getReceitasBebidas(),
      ]);

      _doces = results[0];
      _salgadas = results[1];
      _bebidas = results[2];

      _rebuildOrderMap();

      _atualizarFavoritas();

      developer.log('Receitas carregadas com sucesso: ${_doces.length} doces, ${_salgadas.length} salgadas, ${_bebidas.length} bebidas');

      if (_doces.isEmpty && _salgadas.isEmpty && _bebidas.isEmpty) {
        _error = 'Nenhuma receita foi encontrada';
      }
    } catch (e, stackTrace) {
      developer.log(
        'Erro ao carregar receitas',
        error: e,
        stackTrace: stackTrace,
      );
      _error = 'Erro ao carregar receitas: Verifique se o arquivo db.json está correto';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _atualizarFavoritas() {
    _favoritas = [
      ..._doces.where((r) => r.isFavorite),
      ..._salgadas.where((r) => r.isFavorite),
      ..._bebidas.where((r) => r.isFavorite),
    ];
  }

  Future<void> toggleFavorito(Receita receita) async {
    await _service.toggleFavorite(receita.id, receita.categoria);

    switch (receita.categoria.toLowerCase()) {
      case 'doce':
        _doces = await _service.getReceitasDoces();
        break;
      case 'salgada':
        _salgadas = await _service.getReceitasSalgadas();
        break;
      case 'bebida':
        _bebidas = await _service.getReceitasBebidas();
        break;
    }

    _atualizarFavoritas();
    notifyListeners();
  }

  Future<Receita?> adicionarReceita(Receita receita) async {
    try {
      final novaReceita = await _service.addReceita(receita);
      await _recarregarCategoria(novaReceita.categoria);
      _rebuildOrderMap();
      return novaReceita;
    } catch (e) {
      _error = 'Erro ao adicionar receita: $e';
      notifyListeners();
      return null;
    }
  }

  Future<Receita?> atualizarReceita(Receita receita) async {
    try {
      final updated = await _service.updateReceita(receita);
      if (updated != null) {
        await carregarReceitas();
        _rebuildOrderMap();
        notifyListeners();
        return updated;
      }
      return null;
    } catch (e) {
      _error = 'Erro ao atualizar receita: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> _recarregarCategoria(String categoria) async {
    switch (categoria.toLowerCase()) {
      case 'doce':
        _doces = await _service.getReceitasDoces();
        break;
      case 'salgada':
        _salgadas = await _service.getReceitasSalgadas();
        break;
      case 'bebida':
        _bebidas = await _service.getReceitasBebidas();
        break;
    }
    _rebuildOrderMap();
    _atualizarFavoritas();
    notifyListeners();
  }

  Future<Receita?> atualizarReceitaInternal(Receita receita) async {
    return atualizarReceita(receita);
  }

  Future<bool> deletarReceita(Receita receita) async {
    try {
      final success = await _service.deleteReceita(receita);
      if (success) {
        await _recarregarCategoria(receita.categoria);
      }
      return success;
    } catch (e) {
      _error = 'Erro ao deletar receita: $e';
      notifyListeners();
      return false;
    }
  }

  void removeLocally(Receita receita) {
    _doces.removeWhere((r) => r.id == receita.id);
    _salgadas.removeWhere((r) => r.id == receita.id);
    _bebidas.removeWhere((r) => r.id == receita.id);
    _atualizarFavoritas();
    notifyListeners();
  }

  void restoreLocally(Receita receita, [int? index]) {
    switch (receita.categoria.toLowerCase()) {
      case 'doce':
        if (index != null && index >= 0 && index <= _doces.length) {
          _doces.insert(index, receita);
        } else {
          _doces.add(receita);
        }
        break;
      case 'salgada':
        if (index != null && index >= 0 && index <= _salgadas.length) {
          _salgadas.insert(index, receita);
        } else {
          _salgadas.add(receita);
        }
        break;
      case 'bebida':
        if (index != null && index >= 0 && index <= _bebidas.length) {
          _bebidas.insert(index, receita);
        } else {
          _bebidas.add(receita);
        }
        break;
    }
    _atualizarFavoritas();
    notifyListeners();
  }

  void restoreLocallyAtOrder(Receita receita, int? order) {
    switch (receita.categoria.toLowerCase()) {
      case 'doce':
        final list = _doces;
        if (order != null) {
          int insertIndex = 0;
          for (var i = 0; i < list.length; i++) {
            final id = list[i].id;
            final ord = _orderMap[id];
            if (ord != null && ord < order) insertIndex++;
          }
          if (insertIndex >= 0 && insertIndex <= _doces.length) {
            _doces.insert(insertIndex, receita);
          } else {
            _doces.add(receita);
          }
        } else {
          _doces.add(receita);
        }
        break;
      case 'salgada':
        final list = _salgadas;
        if (order != null) {
          int insertIndex = 0;
          for (var i = 0; i < list.length; i++) {
            final id = list[i].id;
            final ord = _orderMap[id];
            if (ord != null && ord < order) insertIndex++;
          }
          if (insertIndex >= 0 && insertIndex <= _salgadas.length) {
            _salgadas.insert(insertIndex, receita);
          } else {
            _salgadas.add(receita);
          }
        } else {
          _salgadas.add(receita);
        }
        break;
      case 'bebida':
        final list = _bebidas;
        if (order != null) {
          int insertIndex = 0;
          for (var i = 0; i < list.length; i++) {
            final id = list[i].id;
            final ord = _orderMap[id];
            if (ord != null && ord < order) insertIndex++;
          }
          if (insertIndex >= 0 && insertIndex <= _bebidas.length) {
            _bebidas.insert(insertIndex, receita);
          } else {
            _bebidas.add(receita);
          }
        } else {
          _bebidas.add(receita);
        }
        break;
    }
    _atualizarFavoritas();
    notifyListeners();
  }

  final List<_PendingDeletion> _pendingDeletions = [];

  void startPendingDeletion(Receita receita, [int? unused]) {
    final ord = _orderMap[receita.id];
    _pendingDeletions.add(_PendingDeletion(receita, ord));
    removeLocally(receita);
  }

  void undoPendingDeletion(int id) {
    final pIndex = _pendingDeletions.indexWhere((p) => p.receita.id == id);
    if (pIndex == -1) return;
    final p = _pendingDeletions.removeAt(pIndex);
    restoreLocallyAtOrder(p.receita, p.originalOrder);
  }

  Future<void> finalizePendingDeletion(int id) async {
    final pIndex = _pendingDeletions.indexWhere((p) => p.receita.id == id);
    if (pIndex == -1) return;
    final p = _pendingDeletions.removeAt(pIndex);
    await _service.deleteReceita(p.receita);
    await _recarregarCategoria(p.receita.categoria);
  }
}

import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import '../models/receita.dart';
import '../services/receitas_service.dart';

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

    // Recarregar a lista específica para obter a instância atualizadacategory
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
}

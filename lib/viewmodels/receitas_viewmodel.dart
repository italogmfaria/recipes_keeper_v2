import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import '../models/receita.dart';
import '../services/receitas_service.dart';

class ReceitasViewModel extends ChangeNotifier {
  final ReceitasService _service = ReceitasService();

  List<Receita> _doces = [];
  List<Receita> _salgadas = [];
  List<Receita> _bebidas = [];
  bool _isLoading = false;
  String? _error;

  List<Receita> get doces => _doces;
  List<Receita> get salgadas => _salgadas;
  List<Receita> get bebidas => _bebidas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> carregarReceitas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log('Iniciando carregamento das receitas');

      final results = await Future.wait([
        _service.getReceitasDoces().catchError((e) {
          developer.log('Erro ao carregar receitas doces: $e');
          return <Receita>[];
        }),
        _service.getReceitasSalgadas().catchError((e) {
          developer.log('Erro ao carregar receitas salgadas: $e');
          return <Receita>[];
        }),
        _service.getReceitasBebidas().catchError((e) {
          developer.log('Erro ao carregar receitas bebidas: $e');
          return <Receita>[];
        }),
      ]);

      _doces = results[0];
      _salgadas = results[1];
      _bebidas = results[2];

      developer.log('Receitas carregadas com sucesso: ${_doces.length} doces, ${_salgadas.length} salgadas, ${_bebidas.length} bebidas');

      if (_doces.isEmpty && _salgadas.isEmpty && _bebidas.isEmpty) {
        _error = 'Nenhuma receita foi encontrada';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Erro ao carregar receitas',
        error: e,
        stackTrace: stackTrace,
      );
      _error = 'Erro ao carregar receitas: Verifique se o arquivo db.json está correto';
      _isLoading = false;
      notifyListeners();
    }
  }
}

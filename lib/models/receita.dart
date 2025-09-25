import 'dart:convert';

class Receita {
  final int id;
  final String titulo;
  final String descricao;
  final List<String> ingredientes;
  final String modoPreparo;
  final String categoria;
  final bool isFavorite;

  Receita({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ingredientes,
    required this.modoPreparo,
    required this.categoria,
    this.isFavorite = false,
  });

  Receita copyWith({
    int? id,
    String? titulo,
    String? descricao,
    List<String>? ingredientes,
    String? modoPreparo,
    String? categoria,
    bool? isFavorite,
  }) {
    return Receita(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      ingredientes: ingredientes ?? this.ingredientes,
      modoPreparo: modoPreparo ?? this.modoPreparo,
      categoria: categoria ?? this.categoria,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      ingredientes: List<String>.from(json['ingredientes']),
      modoPreparo: json['modoPreparo'],
      categoria: json['categoria'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descricao': descricao,
    'ingredientes': ingredientes,
    'modoPreparo': modoPreparo,
    'categoria': categoria,
    'isFavorite': isFavorite,
  };
}

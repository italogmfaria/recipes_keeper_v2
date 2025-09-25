import 'dart:convert';

class Receita {
  final int id;
  final String titulo;
  final String descricao;
  final List<String> ingredientes;
  final String modoPreparo;
  final String categoria;

  Receita({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ingredientes,
    required this.modoPreparo,
    required this.categoria,
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      ingredientes: List<String>.from(json['ingredientes']),
      modoPreparo: json['modoPreparo'],
      categoria: json['categoria'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descricao': descricao,
    'ingredientes': ingredientes,
    'modoPreparo': modoPreparo,
    'categoria': categoria,
  };
}

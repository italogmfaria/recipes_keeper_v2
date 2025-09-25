import 'package:flutter/material.dart';
import '../models/receita.dart';

class DetalhesView extends StatefulWidget {
  final Receita receita;
  const DetalhesView({super.key, required this.receita});

  @override
  State<DetalhesView> createState() => _DetalhesViewState();
}

class _DetalhesViewState extends State<DetalhesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receita.titulo),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.cyan.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildIngredientes(),
              const SizedBox(height: 24),
              _buildModoPreparo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getCategoryIcon(widget.receita.categoria),
                color: Colors.cyan,
                size: 32,
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.receita.categoria.toUpperCase(),
                  style: TextStyle(
                    color: Colors.cyan.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.receita.descricao,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.cyan.shade700),
              const SizedBox(width: 8),
              Text(
                'Ingredientes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.cyan.shade700,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.receita.ingredientes.map((ingrediente) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.cyan.shade300,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ingrediente,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildModoPreparo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_dining, color: Colors.cyan.shade700),
              const SizedBox(width: 8),
              Text(
                'Modo de Preparo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.cyan.shade700,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.receita.modoPreparo,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'doce':
        return Icons.cake;
      case 'salgada':
        return Icons.lunch_dining;
      case 'bebida':
        return Icons.local_drink;
      default:
        return Icons.fastfood;
    }
  }
}

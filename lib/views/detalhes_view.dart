import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/receita.dart';
import '../viewmodels/receitas_viewmodel.dart';

class DetalhesView extends StatelessWidget {
  final Receita receita;
  const DetalhesView({super.key, required this.receita});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceitasViewModel>(
      builder: (context, viewModel, child) {
        final allRecipes = [...viewModel.doces, ...viewModel.salgadas, ...viewModel.bebidas];
        final currentRecipe = allRecipes.firstWhere(
          (r) => r.id == receita.id && r.categoria == receita.categoria,
          orElse: () => receita, // Fallback to the initial recipe
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes da Receita'),
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
                  _buildHeader(context, currentRecipe, viewModel),
                  const SizedBox(height: 24),
                  _buildIngredientes(context, currentRecipe),
                  const SizedBox(height: 24),
                  _buildModoPreparo(context, currentRecipe),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Receita receita, ReceitasViewModel viewModel) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  receita.titulo,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.cyan.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                icon: Icon(
                  receita.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: receita.isFavorite ? Colors.red.shade400 : Colors.grey,
                ),
                onPressed: () {
                  viewModel.toggleFavorito(receita);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                _getCategoryIcon(receita.categoria),
                color: Colors.cyan,
                size: 22,
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
                  receita.categoria.toUpperCase(),
                  style: TextStyle(
                    color: Colors.cyan.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            receita.descricao,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientes(BuildContext context, Receita receita) {
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
          ...receita.ingredientes.map((ingrediente) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.cyan.shade300,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ingrediente,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildModoPreparo(BuildContext context, Receita receita) {
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
            receita.modoPreparo,
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

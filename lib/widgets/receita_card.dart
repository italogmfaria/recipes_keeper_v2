import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/receita.dart';
import '../viewmodels/receitas_viewmodel.dart';

class ReceitaCard extends StatelessWidget {
  final Receita receita;

  const ReceitaCard({super.key, required this.receita});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ReceitasViewModel>(context);

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detalhes', arguments: receita);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.cyan.shade50,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _getCategoryIcon(receita.categoria),
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          receita.titulo,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.cyan.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
                const SizedBox(height: 12),
                Text(
                  receita.descricao,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 16,
                          color: Colors.cyan.shade300,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${receita.ingredientes.length} ingredientes',
                          style: TextStyle(
                            color: Colors.cyan.shade300,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        receita.categoria.toUpperCase(),
                        style: TextStyle(
                          color: Colors.cyan.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

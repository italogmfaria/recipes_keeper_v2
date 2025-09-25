import 'package:flutter/material.dart';
import '../models/receita.dart';

class ReceitaCard extends StatefulWidget {
  final Receita receita;
  final VoidCallback onTap;

  const ReceitaCard({
    super.key,
    required this.receita,
    required this.onTap,
  });

  @override
  State<ReceitaCard> createState() => _ReceitaCardState();
}

class _ReceitaCardState extends State<ReceitaCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onTap,
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
                  children: [
                    Icon(
                      _getCategoryIcon(widget.receita.categoria),
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.receita.titulo,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.cyan.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.receita.descricao,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                  ),
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
                          '${widget.receita.ingredientes.length} ingredientes',
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
                        widget.receita.categoria.toUpperCase(),
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

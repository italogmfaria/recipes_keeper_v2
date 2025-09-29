import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/receitas_viewmodel.dart';
import '../models/receita.dart';
import 'receita_card.dart';

class CategoriaTabs extends StatelessWidget {
  final int selectedIndex;

  const CategoriaTabs({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceitasViewModel>(
      builder: (context, viewModel, child) {
        final pages = [
          _buildReceitasList(context, viewModel.doces, viewModel),
          _buildReceitasList(context, viewModel.salgadas, viewModel),
          _buildReceitasList(context, viewModel.bebidas, viewModel),
        ];

        return pages[selectedIndex];
      },
    );
  }

  Future<void> _confirmarExclusao(BuildContext context, Receita receita, ReceitasViewModel viewModel, int originalIndex) async {
    viewModel.startPendingDeletion(receita, originalIndex);

    late final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller;

    final snack = SnackBar(
      content: Text('${receita.titulo} excluída'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          viewModel.undoPendingDeletion(receita.id);
          controller.close();
        },
      ),
    );

    controller = ScaffoldMessenger.of(context).showSnackBar(snack);

    controller.closed.then((reason) {
      if (reason != SnackBarClosedReason.action) {
        viewModel.finalizePendingDeletion(receita.id);
      }
    });
  }

  Widget _buildReceitasList(BuildContext context, List<Receita> receitas, ReceitasViewModel viewModel) {
    if (receitas.isEmpty) {
      return const Center(
        child: Text('Nenhuma receita encontrada'),
      );
    }

    return ListView.builder(
      itemCount: receitas.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final receita = receitas[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Dismissible(
            key: Key('receita_${receita.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade700,
              ),
            ),
            confirmDismiss: (direction) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirmar exclusão'),
                  content: Text('Deseja realmente excluir "${receita.titulo}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Excluir'),
                    ),
                  ],
                ),
              );

              if (confirm != true) return false;

              _confirmarExclusao(context, receita, viewModel, index);
              return true;
            },
            child: ReceitaCard(
              receita: receita,
            ),
          ),
        );
      },
    );
  }
}

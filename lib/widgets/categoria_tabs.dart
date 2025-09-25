import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/receitas_viewmodel.dart';
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
          _buildReceitasList(context, viewModel.doces),
          _buildReceitasList(context, viewModel.salgadas),
          _buildReceitasList(context, viewModel.bebidas),
        ];

        return pages[selectedIndex];
      },
    );
  }

  Widget _buildReceitasList(BuildContext context, List<dynamic> receitas) {
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
          child: ReceitaCard(
            receita: receita,
          ),
        );
      },
    );
  }
}

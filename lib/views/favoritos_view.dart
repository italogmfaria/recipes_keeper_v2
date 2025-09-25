import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/receitas_viewmodel.dart';
import '../widgets/receita_card.dart';

class FavoritosView extends StatelessWidget {
  const FavoritosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceitasViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.favoritas.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null && viewModel.favoritas.isEmpty) {
          return Center(child: Text(viewModel.error!));
        }

        if (viewModel.favoritas.isEmpty) {
          return const Center(child: Text('Nenhuma receita favorita ainda.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: viewModel.favoritas.length,
          itemBuilder: (context, index) {
            final receita = viewModel.favoritas[index];
            return ReceitaCard(receita: receita);
          },
        );
      },
    );
  }
}

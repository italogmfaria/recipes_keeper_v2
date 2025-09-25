import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/app_drawer.dart';
import '../widgets/categoria_tabs.dart';
import '../viewmodels/receitas_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReceitasViewModel>().carregarReceitas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas Keeper'),
        elevation: 2,
      ),
      drawer: const AppDrawer(),
      body: Consumer<ReceitasViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Erro ao carregar receitas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(viewModel.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.carregarReceitas(),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          return CategoriaTabs(selectedIndex: _selectedIndex);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: 'Doces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lunch_dining),
            label: 'Salgadas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'Bebidas',
          ),
        ],
      ),
    );
  }
}

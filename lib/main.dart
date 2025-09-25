import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/receita.dart';
import 'views/detalhes_view.dart';
import 'views/home_view.dart';
import 'viewmodels/receitas_viewmodel.dart';
import 'views/settings_view.dart';
import 'views/sobre_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ReceitasViewModel(),
      child: const RecipesKeeperApp(),
    ),
  );
}

class RecipesKeeperApp extends StatelessWidget {
  const RecipesKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes Keeper',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.cyan,
          secondary: Colors.cyanAccent,
          tertiary: Colors.cyan.shade200,
          surface: Colors.white,
          background: Colors.grey.shade50,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          color: Colors.white,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            final initialIndex = settings.arguments as int? ?? 0;
            return MaterialPageRoute(
              builder: (_) => HomeView(initialIndex: initialIndex),
            );
          case '/detalhes':
            final receita = settings.arguments as Receita;
            return MaterialPageRoute(
              builder: (_) => DetalhesView(receita: receita),
            );
          case '/settings':
            return MaterialPageRoute(
              builder: (_) => SettingsView(),
            );
          case '/sobre':
            return MaterialPageRoute(
              builder: (_) => SobreView(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const HomeView(initialIndex: 0),
            );
        }
      },
    );
  }
}

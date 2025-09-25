import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home_view.dart';
import 'viewmodels/receitas_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ReceitasViewModel(),
      child: const RecipesKeeperApp(),
    ),
  );
}

class RecipesKeeperApp extends StatefulWidget {
  const RecipesKeeperApp({super.key});

  @override
  State<RecipesKeeperApp> createState() => _RecipesKeeperAppState();
}

class _RecipesKeeperAppState extends State<RecipesKeeperApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Receitas Keeper',
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
      home: const HomeView(),
    );
  }
}

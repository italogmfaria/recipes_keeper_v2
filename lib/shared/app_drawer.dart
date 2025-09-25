import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.cyan,
                    Colors.cyan.shade300,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Recipes Keeper',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.cyan.shade700,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  color: Colors.cyan.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
            Divider(color: Colors.cyan.shade100),
            ListTile(
              leading: Icon(
                Icons.favorite,
                color: Colors.cyan.shade700,
              ),
              title: Text(
                'Favoritos',
                style: TextStyle(
                  color: Colors.cyan.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false, arguments: 3);
              },
            ),
            Divider(color: Colors.cyan.shade100),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.cyan.shade700,
              ),
              title: Text(
                'Configurações',
                style: TextStyle(
                  color: Colors.cyan.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            Divider(color: Colors.cyan.shade100),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Colors.cyan.shade700,
              ),
              title: Text(
                'Sobre',
                style: TextStyle(
                  color: Colors.cyan.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sobre');
              },
            ),
            Divider(color: Colors.cyan.shade100),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Versão 1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

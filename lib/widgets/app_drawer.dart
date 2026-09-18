import 'dart:io';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void abrirTela(
    BuildContext context,
    Widget tela,
  ) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => tela,
      ),
    );
  }

  void sair(BuildContext context) {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text('Deseja realmente sair do aplicativo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                exit(0);
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF6F4E37),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.people_alt_rounded,
                      size: 38,
                      color: Color(0xFF6F4E37),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pessoas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Pessoas'),
            onTap: () {
              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.animation),
            title: const Text('Splash'),
            onTap: () {
              abrirTela(
                context,
                const SplashScreen(),
              );
            },
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Sair',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () {
              sair(context);
            },
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
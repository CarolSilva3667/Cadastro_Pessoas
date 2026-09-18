import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const CadastroPessoasApp());
}

class CadastroPessoasApp extends StatelessWidget {
  const CadastroPessoasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pessoas',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F6F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F4E37),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6F4E37),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
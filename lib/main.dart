import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PDFManagerApp());
}

class PDFManagerApp extends StatelessWidget {
  const PDFManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181A20),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
          background: const Color(0xFF181A20),
          primary: Colors.amber,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF23272F),
          foregroundColor: Colors.amber,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.amber,
            letterSpacing: 1.2,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF23272F),
          contentTextStyle: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
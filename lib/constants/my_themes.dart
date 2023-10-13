import 'package:flutter/material.dart';

enum MyTheme {
  defaultTheme,
  monospaceTheme,
}

final _defaultTheme = ThemeData.dark(useMaterial3: true).copyWith(
  appBarTheme: AppBarTheme(
    toolbarHeight: 80.0,
    backgroundColor: Colors.grey.shade900,
    titleTextStyle: TextStyle(
      fontSize: 36.0,
      color: Colors.grey.shade200,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardTheme(color: Colors.grey.shade800),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(
      fontSize: 18.0,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  ),
  tabBarTheme: TabBarTheme(unselectedLabelColor: Colors.grey.shade50),
  textTheme: TextTheme(
    headlineSmall: TextStyle(
      fontSize: 32.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    titleLarge: TextStyle(
      fontSize: 28.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    titleMedium: TextStyle(
      fontSize: 24.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.0,
      color: Colors.grey.shade50,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.0,
      color: Colors.grey.shade50,
      height: 1.5,
    ),
  ),
);

final _monospaceTheme = _defaultTheme.copyWith(
  appBarTheme: AppBarTheme(
    toolbarHeight: 80.0,
    backgroundColor: Colors.grey.shade900,
    titleTextStyle: _defaultTheme.appBarTheme.titleTextStyle?.copyWith(
      fontFamily: 'monospace',
    ),
  ),
  inputDecorationTheme: _defaultTheme.inputDecorationTheme.copyWith(
    hintStyle: _defaultTheme.inputDecorationTheme.hintStyle?.copyWith(
      fontFamily: 'monospace',
    ),
  ),
  textTheme: TextTheme(
    headlineSmall: _defaultTheme.textTheme.headlineSmall?.copyWith(
      fontFamily: 'monospace',
    ),
    titleLarge: _defaultTheme.textTheme.titleLarge?.copyWith(
      fontFamily: 'monospace',
    ),
    titleMedium: _defaultTheme.textTheme.titleMedium?.copyWith(
      fontFamily: 'monospace',
    ),
    bodyLarge: _defaultTheme.textTheme.bodyLarge?.copyWith(
      fontFamily: 'monospace',
    ),
    bodyMedium: _defaultTheme.textTheme.bodyMedium?.copyWith(
      fontFamily: 'monospace',
    ),
  ),
);

extension MyThemeExtension on MyTheme {
  ThemeData get theme {
    switch (this) {
      case MyTheme.defaultTheme:
        return _defaultTheme;
      case MyTheme.monospaceTheme:
        return _monospaceTheme;
      default:
        return ThemeData.fallback(useMaterial3: true);
    }
  }
}

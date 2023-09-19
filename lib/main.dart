import 'package:expense_tracker/expenses.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/constants/themes.dart' as themes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GoogleFonts.config.allowRuntimeFetching = false;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: themes.lightTheme,
    darkTheme: themes.darkTheme,
    themeMode: ThemeMode.system,
    home: const Expenses(),
  ));
}

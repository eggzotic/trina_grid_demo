import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'home_page.dart';
import 'state/theme_mode_state.dart';

void main() async{
  // necessary before any multi-language/date-formatting etc can safely be done
  await initializeDateFormatting();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (context) => ThemeModeState(context)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modeState = context.watch<ThemeModeState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: modeState.mode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      title: 'Trina Grid Demo',
      home: const HomePage(),
    );
  }
}

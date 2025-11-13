import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trina_grid/trina_grid.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trina Grid Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AppState with ChangeNotifier {
  //

  final rows = 20;
  final cols = 15;

  List<String> headerElements() {
    return List.generate(length, generator);
  }
}

enum TableHeader {
  firstName(title: "First name",type: TrinaColumnType.text()),
  surname,
  age,
  job,
  birthday;

  final String title;
  final TrinaColumnType type;

  const TableHeader({required this.title, required this.type});

  TrinaColumn columnFor() {
    return TrinaColumn(title: title, field: field, type: type, readOnly: true);
  }
}

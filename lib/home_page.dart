import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trina_grid_demo/app_state.dart';
import 'package:trina_grid_demo/my_trina_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _appState = context.read<AppState>();
  @override
  Widget build(BuildContext context) {
    debugPrint("HomePage build");
    final appState = context.watch<AppState>();
    final grid = MyTrinaTable(sortAsc: true, sortColIndex: 1);
    return Scaffold(
      appBar: AppBar(
        title: Text("TrinaGrid Demo (${_appState.people.length})"),
        actions: [
          IconButton(
            onPressed: () {
              appState.addPerson();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: grid,
    );
  }
}

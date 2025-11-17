import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'my_trina_table/my_trina_table.dart';
import 'person_attributes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _appState = context.read<AppState>();
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final grid = MyTrinaTable(
      sortAsc: true,
      sortColIndex: 0,
      headingsSource: PersonAttributes.values,
      rowsSource: appState.people,
      deleteRow: (id) => appState.deletePerson(id),
      deleteIcon: Tooltip(
        message: "Nuke 'em!",
        child: Icon(Icons.close, color: Colors.red),
      ),
    );
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'model/person_row_content.dart';
import 'state/app_state.dart';
import 'my_trina_table/my_trina_table.dart';
import 'model/person_attributes.dart';
import 'state/theme_mode_state.dart';

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
    final themeMode = context.watch<ThemeModeState>();
    final icon = themeMode.icon;
    final dateFormat = DateFormat(
      DateFormat.YEAR_NUM_MONTH_DAY,
      "en_GB",
    ).add_Hm().pattern;
    final grid = MyTrinaTable(
      dateFormat: dateFormat,
      sortAsc: true,
      sortColIndex: 0,
      headingsSource: PersonAttributes.values,
      rowsSource: appState.people
          .map((person) => PersonRowContent(person: person))
          .toList(),
      deleteRow: (id) => appState.deletePerson(id),
      deleteIcon: Tooltip(
        message: "Nuke 'em!",
        child: Icon(Icons.close, color: Colors.red),
      ),
      brightness: themeMode.brightness,
      cornerRadius: themeMode.cornerRadius,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: themeMode.description,
          onPressed: () => themeMode.cycleMode(),
          icon: Icon(icon),
        ),
        title: Text("TrinaGrid Demo (${_appState.people.length})"),
        actions: [
          IconButton(
            tooltip: "Add person",
            onPressed: () => appState.addPerson(),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: grid,
    );
  }
}

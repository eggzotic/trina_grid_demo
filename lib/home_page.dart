import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:trina_grid_demo/app_state.dart';
import 'package:trina_grid_demo/person.dart';
import 'package:trina_grid_demo/table_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _appState = context.read<AppState>();
  late TrinaGridStateManager _stateManager;
  late TrinaColumn _sortCol;
  int _autoFitCount = 0;

  final _gridRows = <TrinaRow>[];

  void _updateRows(List<Person> people) {
    _gridRows
      ..clear()
      ..addAll(
        people.map((person) {
          return TrinaRow(
            key: ValueKey(person.uuid),
            cells: person.cellFor()
              ..addEntries([
                MapEntry(
                  'delete',
                  TrinaCell(
                    value: "",
                    renderer: (rendererContext) => IconButton(
                      onPressed: () {
                        _appState.deletePerson(person.uuid);
                        _refreshTable();
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ),
              ]),
          );
        }).toList(),
      );
  }

  void _refreshTable() {
    _stateManager
      ..removeAllRows()
      ..appendRows(_gridRows);
    if (_sortCol.sort.isAscending) {
      debugPrint("Sorting asc on ${_sortCol.field}");
      _stateManager.sortAscending(_sortCol);
    } else if (_sortCol.sort.isDescending) {
      debugPrint("Sorting desc on ${_sortCol.field}");
      _stateManager.sortDescending(_sortCol);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("HomePage build");
    final appState = context.watch<AppState>();
    final columns =
        TableHeader.values.map((heading) => heading.columnFor()).toList()
          ..insert(
            0,
            TrinaColumn(
              title: "",
              field: 'delete',
              type: TrinaColumnType.text(),
            ),
          );
    final people = appState.people;
    _updateRows(people);
    final grid = TrinaGrid(
      columns: columns,
      rows: _gridRows,
      onLoaded: (event) {
        _stateManager = event.stateManager;
        _autoFitCount++;
        for (final col in columns) {
          _stateManager.autoFitColumn(context, col);
          debugPrint("Auto-fitting column: ${col.field}");
        }
        _sortCol = columns[1];
        _stateManager.sortAscending(_sortCol);
        debugPrint("Autofit count: $_autoFitCount");
      },
      onSorted: (event) {
        _sortCol = event.column;
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("TrinaGrid Demo (${people.length})"),
        actions: [
          IconButton(
            onPressed: () {
              appState.addPerson();
              _refreshTable();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: grid,
    );
  }
}

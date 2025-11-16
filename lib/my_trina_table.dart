import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:trina_grid_demo/app_state.dart';
import 'package:trina_grid_demo/table_header.dart';

class MyTrinaTable extends StatefulWidget {
  const MyTrinaTable({
    super.key,
    required this.sortAsc,
    required this.sortColIndex,
  });

  final bool sortAsc;
  final int sortColIndex;

  @override
  State<MyTrinaTable> createState() => _MyTrinaTableState();
}

class _MyTrinaTableState extends State<MyTrinaTable> {
  late final _appState = context.read<AppState>();
  TrinaGridStateManager? _stateManager;
  late TrinaColumn _sortCol;

  void _buildRows() {
    final state = _stateManager;
    if (state == null) return;
    final people = _appState.people;
    state
      ..removeAllRows(notify: false)
      ..appendRows(
        people.map((person) {
          return TrinaRow(
            key: ValueKey(person.uuid),
            cells: person.tableRowFor()
              ..addEntries([
                MapEntry(
                  'delete',
                  TrinaCell(
                    value: "",
                    renderer: (rendererContext) => IconButton(
                      onPressed: () {
                        _appState.deletePerson(person.uuid);
                        // _buildRows();
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ),
              ]),
          );
        }).toList(),
      );
    if (_sortCol.sort.isAscending) {
      state.sortAscending(_sortCol);
    } else if (_sortCol.sort.isDescending) {
      state.sortDescending(_sortCol);
    } else {
      debugPrint(
        "Sort column (${_sortCol.field}) has no asc/desc set, skipping sort",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_MyTrinaTableState build");
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
    _buildRows();
    return TrinaGrid(
      columns: columns,
      // initialize the table with empty rows, and then manage the rows entirely
      //  thru the StateManager API (i.e. _buildRows)
      rows: [],
      onLoaded: (event) {
        _stateManager = event.stateManager;
        for (final col in columns) {
          _stateManager!.autoFitColumn(context, col);
          debugPrint("Auto-fitting column: ${col.field}");
        }
        _sortCol = columns[widget.sortColIndex];
        widget.sortAsc
            ? _stateManager!.sortAscending(_sortCol)
            : _stateManager!.sortDescending(_sortCol);
        _buildRows();
      },
      onSorted: (event) {
        _sortCol = event.column;
      },
    );
  }
}

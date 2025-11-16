import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:trina_grid_demo/my_trina_table/trina_heading_source.dart';
import 'package:trina_grid_demo/my_trina_table/trina_row_source.dart';

/// Produces a table, based on the TrinaGrid package, displaying tabular data
/// that can be updated via simply updating the backing-data
class MyTrinaTable extends StatefulWidget {
  const MyTrinaTable({
    super.key,
    required this.sortAsc,
    required this.sortColIndex,
    required this.headingsSource,
    required this.rowsSource,
    this.deleteRow,
  });

  /// Whether to initially sort Ascending
  final bool sortAsc;

  /// The initial column-index to sort on
  final int sortColIndex;

  /// A list of objects whose class the column-headings can be derived
  final List<TrinaHeadingSource> headingsSource;

  /// A list of objects whose class the table-rows can be derived
  final List<TrinaRowSource> rowsSource;

  /// An optional function which can perform the corresponding data-source-level delete of a row
  final void Function(String id)? deleteRow;

  @override
  State<MyTrinaTable> createState() => _MyTrinaTableState();
}

class _MyTrinaTableState extends State<MyTrinaTable> {
  TrinaGridStateManager? _stateManager;
  late TrinaColumn _sortCol;

  void _buildRows() {
    final state = _stateManager;
    if (state == null) return;
    final people = widget.rowsSource;
    state
      ..removeAllRows(notify: false)
      ..appendRows(
        people.map((person) {
          return TrinaRow(
            key: ValueKey(person.id),
            cells: person.tableRowFor()
              ..addEntries([
                MapEntry(
                  'delete',
                  TrinaCell(
                    value: "",
                    renderer: (rendererContext) => IconButton(
                      onPressed: () {
                        widget.deleteRow?.call(person.id);
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
        widget.headingsSource.map((heading) => heading.columnFor()).toList()
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
        // Auto-fit all cols initially
        for (final col in columns) {
          _stateManager!.autoFitColumn(context, col);
        }
        // setup initial sorting
        _sortCol = columns[widget.sortColIndex];
        widget.sortAsc
            ? _stateManager!.sortAscending(_sortCol)
            : _stateManager!.sortDescending(_sortCol);
        // initialise the rows
        _buildRows();
      },
      onSorted: (event) {
        _sortCol = event.column;
      },
    );
  }
}

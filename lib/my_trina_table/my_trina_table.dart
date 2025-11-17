import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';
import 'trina_heading_source.dart';
import 'trina_row_source.dart';

/// Produces a table, based on the TrinaGrid package, displaying tabular data
/// that can be updated via simply updating the backing-data
class MyTrinaTable extends StatefulWidget {
  const MyTrinaTable({
    super.key,
    this.sortAsc = true,
    this.sortColIndex = 0,
    required this.headingsSource,
    required this.rowsSource,
    this.deleteRow,
    this.deleteIcon,
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

  /// Alternative icon to appear as the delete-row symbol - should be wrapped in Tooltip (if desired) as well
  final Widget? deleteIcon;

  @override
  State<MyTrinaTable> createState() => _MyTrinaTableState();
}

class _MyTrinaTableState extends State<MyTrinaTable> {
  TrinaGridStateManager? _stateManager;
  late TrinaColumn _sortCol;

  bool get _deleteAvailable => widget.deleteRow != null;

  void _buildRows() {
    final state = _stateManager;
    if (state == null) return;
    final rowItems = widget.rowsSource;
    state
      ..removeAllRows(notify: false)
      ..appendRows(
        rowItems.map((item) {
          return TrinaRow(
            key: ValueKey(item.id),
            cells: item.tableRowFor()
              ..addEntries([
                if (_deleteAvailable)
                  MapEntry(
                    'delete',
                    TrinaCell(
                      value: "",
                      renderer: (rendererContext) => IconButton(
                        tooltip: widget.deleteIcon != null ? "" : "Delete",
                        onPressed: () {
                          widget.deleteRow?.call(item.id);
                        },
                        icon: widget.deleteIcon ?? Icon(Icons.delete),
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
    final columns = widget.headingsSource
        .map((heading) => heading.columnFor())
        .toList();
    if (_deleteAvailable) {
      columns.insert(
        0,
        TrinaColumn(
          title: "",
          field: 'delete',
          type: TrinaColumnType.text(),
          readOnly: true,
          enableSorting: false,
        ),
      );
    }
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
        _sortCol = columns[widget.sortColIndex + (_deleteAvailable ? 1 : 0)];
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

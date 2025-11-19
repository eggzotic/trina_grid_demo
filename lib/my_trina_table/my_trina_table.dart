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
    this.isTransparent = true,
    this.brightness,
    this.deleteTooltip,
    this.deleteIconColor,
    this.deleteUnless,
    this.onSelectRow,
    this.dateFormat,
  });

  /// Whether to initially sort Ascending
  final bool sortAsc;

  /// The initial column-index to sort on
  final int sortColIndex;

  /// A list of objects whose class the column-headings can be derived
  final List<TrinaHeadingSource> headingsSource;

  /// A list of objects whose class the table-rows can be derived
  final List<TrinaRowSource> rowsSource;

  /// An optional function which can perform the corresponding data-source-level
  /// delete of a row
  final void Function(String id)? deleteRow;

  /// Alternative icon to appear as the delete-row symbol - should be wrapped in
  /// Tooltip (if desired) as well
  final Widget? deleteIcon;

  /// The message to indicate what action the delete button will take
  final String? deleteTooltip;

  /// The color for the delete-icon
  final Color? deleteIconColor;

  /// Whether to make the table transparent, and so allow the parent/wrapping
  /// background be visible instead
  final bool isTransparent;

  /// The current/in-effect brightness (i.e. light/dark mode).
  /// Defaults to the platform brightness.
  final Brightness? brightness;

  /// Whether to offer delete-functionality for a given item (e.g. decline to
  /// offer sign-out of one's own session)
  final bool Function(String id)? deleteUnless;

  /// An optional call-back when a row is clicked on
  final void Function(String id)? onSelectRow;

  final String? dateFormat;

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
    final wasEmpty = state.rows.isEmpty;
    state
      ..removeAllRows(notify: false)
      ..appendRows(
        rowItems.map((item) {
          final cannotDelete = widget.deleteUnless?.call(item.id) == true;
          return TrinaRow(
            key: ValueKey(item.id),
            cells: item.tableRowFor()
              ..addEntries([
                if (_deleteAvailable)
                  MapEntry(
                    'delete',
                    TrinaCell(
                      value: "",
                      renderer: (rendererContext) => cannotDelete
                          ? SizedBox.fromSize(size: Size.zero)
                          : IconButton(
                              color: widget.deleteIconColor,
                              tooltip:
                                  "${widget.deleteTooltip ?? "Delete"} ${item.id}",
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
    if (wasEmpty) _autofit(state.columns);
  }

  void _autofit(List<TrinaColumn> columns) {
    for (final col in columns) {
      _stateManager!.autoFitColumn(context, col);
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = widget.headingsSource
        .map((heading) => heading.columnFor(dateFormat: widget.dateFormat))
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
    final brightness =
        widget.brightness ?? MediaQuery.platformBrightnessOf(context);
    final themeDark = widget.isTransparent
        ? TrinaGridStyleConfig.dark(
            gridBackgroundColor: Colors.transparent,
            rowColor: Colors.transparent,
            cellTextStyle: TrinaGridStyleConfig.defaultDarkCellTextStyle,
          )
        : TrinaGridStyleConfig.dark();
    final themeLight = widget.isTransparent
        ? TrinaGridStyleConfig(
            gridBackgroundColor: Colors.transparent,
            rowColor: Colors.transparent,
            cellTextStyle: TrinaGridStyleConfig.defaultLightCellTextStyle,
          )
        : TrinaGridStyleConfig();
    final style = switch (brightness) {
      Brightness.dark => themeDark,
      Brightness.light => themeLight,
    };
    return TrinaGrid(
      configuration: TrinaGridConfiguration(
        style: style,
        selectingMode: TrinaGridSelectingMode.row,
      ),
      columns: columns,
      // initialize the table with empty rows, and then manage the rows entirely
      //  thru the StateManager API (i.e. _buildRows)
      rows: [],
      onLoaded: (event) {
        _stateManager = event.stateManager;
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
      onSelected: (event) {
        try {
          final itemId = (event.row?.key as ValueKey).value as String;
          widget.onSelectRow?.call(itemId);
        } catch (e) {
          debugPrint("onSelected row ${event.rowIdx}");
        }
      },
    );
  }
}

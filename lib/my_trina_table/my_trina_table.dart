import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';
import 'heading_source.dart';
import 'row_source.dart';

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
    this.maxRowsPerPage,
    this.cornerRadius = 0,
    this.showRowBorders = false,
    this.showColumnBorders = false,
  });

  /// Whether to initially sort Ascending
  final bool sortAsc;

  /// The initial column-index to sort on
  final int sortColIndex;

  /// A list of objects whose class the column-headings can be derived
  final List<HeadingSource> headingsSource;

  /// A list of objects whose class the table-rows can be derived
  final List<RowSource> rowsSource;

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

  /// Pagination will be used if this is non-null
  final int? maxRowsPerPage;

  /// Use this in case of wrapping the table, in e.g. a Card widget, which might
  /// have rounded corners
  final double cornerRadius;

  /// Whether to show the horizontal borders between rows
  final bool showRowBorders;

  /// Whether to show the vertical borders between columns
  final bool showColumnBorders;

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

    final allNewRowKeys = rowItems.map((row) => row.rowKey).toSet();

    final oldRowKeys = state.refRows
        .map((row) => (row.key as ValueKey<String>).value)
        .toSet();

    final onlyNewRows = rowItems
        .where((row) => !oldRowKeys.contains(row.rowKey))
        .toSet();

    // Remove rows no longer present, or which have been modified, from the state
    state.refRows.removeWhere(
      (row) => !allNewRowKeys.contains((row.key as ValueKey<String>).value),
    );

    // compose the content of the new/replaced rows only
    final newRowContent = onlyNewRows.map((item) {
      final cannotDelete = widget.deleteUnless?.call(item.id) == true;
      return TrinaRow(
        key: ValueKey(item.rowKey),
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
    });

    // add the new rows to the state
    state.refRows.addAll(newRowContent);

    // apply the current sorting
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

  bool get _usePagination => widget.maxRowsPerPage != null;

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

    final themeDark = TrinaGridStyleConfig.dark(
      gridBorderRadius: BorderRadius.circular(widget.cornerRadius),
      gridBackgroundColor: widget.isTransparent
          ? Colors.transparent
          : const Color(0xFF111111),
      rowColor: widget.isTransparent
          ? Colors.transparent
          : const Color(0xFF111111),

      // The overall around-the-outside table-border
      // gridBorderColor: Colors.transparent,
      // gridBorderWidth: 0,

      // The Cell border
      // borderColor: Colors.transparent,

      // enableColumnBorderVertical: true,
      // enableColumnBorderHorizontal: false,
      enableCellBorderVertical: widget.showColumnBorders,
      enableCellBorderHorizontal: widget.showRowBorders,
    );
    final themeLight = TrinaGridStyleConfig(
      gridBorderRadius: BorderRadius.circular(widget.cornerRadius),
      gridBackgroundColor: widget.isTransparent
          ? Colors.transparent
          : Colors.white,
      rowColor: widget.isTransparent ? Colors.transparent : Colors.white,

      // The overall around-the-outside table-border
      // gridBorderColor: Colors.transparent,
      // gridBorderWidth: 0,

      // The Cell border
      // borderColor: Colors.transparent,

      // enableColumnBorderVertical: true,
      // enableColumnBorderHorizontal: false,
      enableCellBorderVertical: widget.showColumnBorders,
      enableCellBorderHorizontal: widget.showRowBorders,
    );

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
        if (_usePagination) {
          _stateManager!.setPageSize(widget.maxRowsPerPage!);
        }
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
      createFooter: _usePagination
          ? (stateManager) {
              return TrinaPagination(stateManager, pageSizeToMove: 1);
            }
          : null,
    );
  }
}

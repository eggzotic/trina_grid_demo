import 'package:trina_grid/trina_grid.dart';

abstract mixin class RowSource {
  /// The data-source in a suitable form for TrinaRow to consume
  Map<String, TrinaCell> tableRowFor();

  /// A unique identifier for this data-object that is persistent across updates
  /// from the data-source (e.g. API responses)
  String get id;

  /// A custom hash of the relevant fields of this data-source - sufficient to
  /// determine/guarantee equality of 2 different instances
  int get rowHash;

  String get rowKey => "${id}_$rowHash";
}

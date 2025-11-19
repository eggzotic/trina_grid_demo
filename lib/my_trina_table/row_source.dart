import 'package:trina_grid/trina_grid.dart';

abstract class RowSource {
  Map<String, TrinaCell> tableRowFor();
  String get id;
}

import 'package:trina_grid/trina_grid.dart';

abstract class TrinaRowSource {
  Map<String, TrinaCell> tableRowFor();
  String get id;
}

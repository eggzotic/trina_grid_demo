import 'package:trina_grid/trina_grid.dart';

abstract mixin class HeadingSource {
  String get field;
  String get title;
  TrinaColumnType type({String? dateFormat});

  TrinaColumn columnFor({String? dateFormat}) {
    return TrinaColumn(
      title: title,
      field: field,
      type: type(dateFormat: dateFormat),
      readOnly: true,
    );
  }
}

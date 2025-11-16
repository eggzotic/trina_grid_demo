import 'package:trina_grid/trina_grid.dart';
import 'package:trina_grid_demo/my_trina_table/trina_head_source.dart';

enum TableHeader implements TrinaHeadSource {
  firstName(title: "First name"),
  surname(title: "Surname"),
  age(title: "Age"),
  job(title: "Occupation"),
  birthday(title: "Birth Date"),
  hasDog(title: "Has a dog");

  final String title;

  const TableHeader({required this.title});

  @override
  TrinaColumn columnFor() {
    return TrinaColumn(title: title, field: name, type: type, readOnly: true);
  }

  TrinaColumnType get type => switch (this) {
    firstName || surname || job => TrinaColumnType.text(),
    age => TrinaColumnType.number(),
    birthday => TrinaColumnType.date(),
    hasDog => TrinaColumnType.boolean(),
  };
}

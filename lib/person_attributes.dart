import 'package:trina_grid/trina_grid.dart';
import 'my_trina_table/trina_heading_source.dart';

enum PersonAttributes implements TrinaHeadingSource {
  firstName(title: "First name"),
  surname(title: "Surname"),
  age(title: "Age"),
  job(title: "Occupation"),
  birthday(title: "Birth Date"),
  hasDog(title: "Has a dog");

  final String title;

  const PersonAttributes({required this.title});

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

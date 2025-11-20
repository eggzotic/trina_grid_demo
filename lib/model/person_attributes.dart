import 'package:trina_grid/trina_grid.dart';
import '../my_trina_table/heading_source.dart';

enum PersonAttributes with HeadingSource {
  firstName(title: "First name"),
  surname(title: "Surname"),
  age(title: "Age"),
  job(title: "Occupation"),
  birthday(title: "Birth Date"),
  hasDog(title: "Has a dog");

  @override
  final String title;

  @override
  String get field => name;

  const PersonAttributes({required this.title});

  @override
  TrinaColumnType type({String? dateFormat}) => switch (this) {
    firstName || surname || job => TrinaColumnType.text(),
    age => TrinaColumnType.number(),
    birthday => TrinaColumnType.dateTime(
      format: dateFormat ?? 'yyyy-MM-dd HH:mm',
    ),
    hasDog => TrinaColumnType.boolean(),
  };
}

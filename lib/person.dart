import 'package:trina_grid/trina_grid.dart';
import 'date_ext.dart';
import 'occupation.dart';
import 'my_trina_table/row_source.dart';
import 'package:uuid/uuid.dart';

import 'person_attributes.dart';

class Person implements RowSource {
  final String firstName;
  final String surname;
  final Occupation job;
  final DateTime birthday;
  final bool hasDog;
  final String uuid;

  @override
  String get id => uuid;

  Person({
    required this.birthday,
    required this.firstName,
    required this.job,
    required this.surname,
    this.hasDog = false,
  }) : uuid = Uuid().v1();

  String get fullName => "$firstName $surname";

  int get ageInYears =>
      (DateTime.now().difference(birthday).inSeconds / DateExt.secondsPerYear)
          .floor();
  @override
  Map<String, TrinaCell> tableRowFor() {
    return {
      PersonAttributes.firstName.name: TrinaCell(value: firstName),
      PersonAttributes.surname.name: TrinaCell(value: surname),
      PersonAttributes.job.name: TrinaCell(value: job.jobName),
      PersonAttributes.birthday.name: TrinaCell(value: birthday),
      PersonAttributes.age.name: TrinaCell(value: ageInYears),
      PersonAttributes.hasDog.name: TrinaCell(value: hasDog),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          surname == other.surname &&
          job == other.job &&
          birthday == other.birthday &&
          hasDog == other.hasDog;

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      surname.hashCode ^
      job.hashCode ^
      birthday.hashCode ^
      hasDog.hashCode;
}

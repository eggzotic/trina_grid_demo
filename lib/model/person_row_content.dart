import 'package:trina_grid/trina_grid.dart';
import '../my_trina_table/row_source.dart';
import 'person.dart';
import 'person_attributes.dart';

/// This class serves as a view-model - providing the
class PersonRowContent with RowSource {
  final Person person;
  PersonRowContent({required this.person})
    : rowHash = Object.hash(
        person.uuid,
        person.firstName,
        person.surname,
        person.job,
        person.birthday,
        person.hasDog,
      );

  @override
  String get id => person.uuid;

  @override
  final int rowHash;

  @override
  Map<String, TrinaCell> tableRowFor() {
    return {
      PersonAttributes.firstName.name: TrinaCell(value: person.firstName),
      PersonAttributes.surname.name: TrinaCell(value: person.surname),
      PersonAttributes.job.name: TrinaCell(value: person.job.jobName),
      PersonAttributes.birthday.name: TrinaCell(value: person.birthday),
      PersonAttributes.age.name: TrinaCell(value: person.ageInYears),
      PersonAttributes.hasDog.name: TrinaCell(value: person.hasDog),
    };
  }
}

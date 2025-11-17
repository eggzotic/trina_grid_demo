import 'package:trina_grid/trina_grid.dart';
import 'date_ext.dart';
import 'occupation.dart';
import 'my_trina_table/trina_row_source.dart';
import 'package:uuid/uuid.dart';

class Person implements TrinaRowSource {
  // these field names must match *exactly* the corresponding enum cases (TableHeader)
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
      'firstName': TrinaCell(value: firstName),
      'surname': TrinaCell(value: surname),
      'job': TrinaCell(value: job.jobName),
      'birthday': TrinaCell(value: birthday),
      'age': TrinaCell(value: ageInYears),
      'hasDog': TrinaCell(value: hasDog),
      'uuid': TrinaCell(value: uuid),
    };
  }
}

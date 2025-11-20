import '../date_ext.dart';
import 'occupation.dart';
import 'package:uuid/uuid.dart';

class Person {
  final String firstName;
  final String surname;
  final Occupation job;
  final DateTime birthday;
  final bool hasDog;
  final String uuid;

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
}

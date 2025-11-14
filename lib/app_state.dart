import 'package:flutter/material.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:trina_grid_demo/date_ext.dart';
import 'package:trina_grid_demo/occupation.dart';
import 'package:trina_grid_demo/person.dart';

class AppState with ChangeNotifier {
  final _baseDate = DateTime(1920, 2, 12);

  AppState() {
    _people.addAll(_generatePeople());
  }
  //

  final rows = 5;

  final _people = <Person>[];
  List<Person> get people => [..._people];
  void deletePerson(String uuid) {
    _people.removeWhere((person) {
      if (person.uuid == uuid) {
        debugPrint("Deleting ${person.fullName}");
        return true;
      }
      return false;
    });
    notifyListeners();
  }

  void addPerson() {
    final person = _generateNewPerson();
    _people.add(person);
    debugPrint("AddPerson: ${person.fullName}");
    notifyListeners();
  }

  final _randomNames = RandomNames(Zone.us);

  Person _generateNewPerson() {
    final firstName = _randomNames.name();
    final surname = _randomNames.surname();
    final birthday = _baseDate.getRandomDateUpTo();
    final occupation = Occupation.randomJob();
    final hasDog = firstName.startsWith('A');
    return Person(
      birthday: birthday,
      firstName: firstName,
      job: occupation,
      surname: surname,
      hasDog: hasDog,
    );
  }

  List<Person> _generatePeople() =>
      List.generate(rows, (row) => _generateNewPerson());
}

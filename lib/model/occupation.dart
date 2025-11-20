import 'dart:math';

enum Occupation {
  softwareEngineer('Software Engineer'),
  doctor('Doctor'),
  teacher('Teacher'),
  artist('Artist'),
  chef('Chef'),
  pilot('Pilot'),
  astronaut('Astronaut'),
  writer('Writer'),
  musician('Musician'),
  farmer('Farmer'),
  nurse('Nurse'),
  hairDresser('Hair Dresser'),
  busDriver('Bus driver'),
  architect('Architect');

  final String jobName;
  const Occupation(this.jobName);

  static final _rand = Random();

  static Occupation randomJob() {
    final index = _rand.nextInt(values.length);
    return values[index];
  }
}

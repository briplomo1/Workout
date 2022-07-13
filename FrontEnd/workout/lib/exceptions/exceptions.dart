class InvalidUsernamePassword implements Exception {
  String message;
  InvalidUsernamePassword(this.message);
}

class EmailTaken implements Exception {
  String message;
  EmailTaken(this.message);
}

class CantCreateWorkout implements Exception {
  String message;
  CantCreateWorkout(this.message);
}

class CantGetExercises implements Exception {
  String message;
  CantGetExercises(this.message);
}

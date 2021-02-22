class InvalidUsernamePassword implements Exception {
  String message;
  InvalidUsernamePassword(this.message);
}

class EmailTaken implements Exception {
  String message;
  EmailTaken(this.message);
}

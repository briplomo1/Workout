class User {
  String url;
  String firstName;
  String lastName;
  String email;
  List<Set> sets;
  String detail;

  User(
      {this.url,
      this.firstName,
      this.lastName,
      this.email,
      this.sets,
      this.detail});

  factory User.fromJson(Map<String, dynamic> data) {
    print("user from json parsing");
    if (data != null) {
      var list = data['sets'] as List;
      List<Set> setsList = list.map((e) => Set.fromJson(e)).toList();
      return User(
          detail: data['detail'] ?? '',
          url: data['url'] ?? "",
          email: data['email'] ?? "",
          firstName: data['first_name'] ?? "",
          lastName: data['last_name'] ?? "",
          sets: setsList);
    } else {
      print("user is null");
      return null;
    }
  }

  Map<String, dynamic> toJson() => {};
}

//TODO: add date to all sets
class Set {
  String url;
  String name;
  String owner;
  int reps;
  int weight;
  DateTime dateCreated;

  Set(
      {this.url,
      this.name,
      this.owner,
      this.reps,
      this.weight,
      this.dateCreated});

  factory Set.fromJson(Map<String, dynamic> data) {
    int weights = int.parse(data['weight']);
    return Set(
      url: data['url'] ?? '',
      name: data['name'] ?? '',
      owner: data['owner'] ?? '',
      reps: data['reps'] ?? 0,
      weight: weights ?? 0,
      dateCreated: DateTime.parse(data['date']) ?? '',
    );
  }
}

class LoginResponse {
  String accessToken;
  String error;
  String refreshToken;

  LoginResponse({this.accessToken, this.error, this.refreshToken});
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        accessToken: json['access'] ?? "",
        refreshToken: json['refresh'] ?? "",
        error: json['detail'] ?? "");
  }
}

class LoginRequest {
  String email;
  String password;
  LoginRequest({this.email, this.password});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim()
    };
    return map;
  }
}

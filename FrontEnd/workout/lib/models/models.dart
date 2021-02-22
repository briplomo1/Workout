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
      return null;
    }
  }

  Map<String, dynamic> toJson() => {};
}

class Set {
  String url;
  String name;
  String owner;
  int reps;
  int weight;

  Set({this.url, this.name, this.owner, this.reps, this.weight});

  factory Set.fromJson(Map<String, dynamic> data) {
    int weights = int.parse(data['weight']);
    return Set(
      url: data['url'] ?? '',
      name: data['name'] ?? '',
      owner: data['owner'] ?? '',
      reps: data['reps'] ?? 0,
      weight: weights ?? 0,
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

import 'package:flutter/foundation.dart';

class User {
  String? url;
  String? firstName;
  String? lastName;
  String? email;
  List<Set>? sets;
  String? detail;

  User(
      {this.url,
      this.firstName,
      this.lastName,
      this.email,
      this.sets,
      this.detail});

  static User? fromJson(Map<String, dynamic>? data) {
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

  // Implement tojson
  Map<String, dynamic> toJson() => {};
}

class Set {
  String? url;
  String? exercise;
  String? owner;
  int? reps;
  double? weight;
  DateTime? dateCreated;

  Set(
      {this.url,
      this.exercise,
      this.owner,
      this.reps,
      this.weight,
      this.dateCreated});

  factory Set.fromJson(Map<String, dynamic> data) {
    double? weights = double.tryParse(data['weight']) ?? 0.0;
    return Set(
      url: data['url'] ?? '',
      exercise: data['exercise'] ?? '',
      owner: data['owner'] ?? '',
      reps: data['reps'] ?? 0,
      weight: weights,
      dateCreated: DateTime.parse(data['date']),
    );
  }
}

class Workout {
  String? url;
  String? name;
  DateTime? dateCreated;
  List<WorkoutSet>? sets;
  // Implement tojson
  Workout({
    this.url,
    this.name,
    this.dateCreated,
    this.sets,
  });
  factory Workout.fromJson(Map<String, dynamic> data) {
    var list = data['workout_sets'] as List;
    List<WorkoutSet> setsList =
        list.map((e) => WorkoutSet.fromJson(e)).toList();
    return Workout(
      url: data['url'] ?? '',
      name: data['name'] ?? '',
      dateCreated: DateTime.parse(data['date_created']),
      sets: setsList,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'workout_sets': sets,
    };
  }
}

class WorkoutSet {
  int? sets;
  String? url;
  String? exercise;
  int? reps;
  double? weight;
  DateTime? dateCreated;

  WorkoutSet(
      {this.url,
      this.exercise,
      this.reps,
      this.weight,
      this.dateCreated,
      this.sets});

  factory WorkoutSet.fromJson(Map<String, dynamic> data) {
    double? weights = double.tryParse(data['weight']) ?? 0.0;
    return WorkoutSet(
      sets: data['sets'] ?? '',
      url: data['url'] ?? '',
      exercise: data['exercise'] ?? '',
      reps: data['reps'] ?? 0,
      weight: weights,
      dateCreated: DateTime.parse(data['date']),
    );
  }
// Implement tojson
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'exercise': exercise,
      'reps': reps,
      'weight': weight,
    };
  }
}

class LoginResponse {
  String? accessToken;
  String? error;
  String? refreshToken;

  LoginResponse({this.accessToken, this.error, this.refreshToken});
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        accessToken: json['access'] ?? "",
        refreshToken: json['refresh'] ?? "",
        error: json['detail'] ?? '');
  }
}

class Exercise {
  String? name;

  Exercise({this.name});
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
    );
  }
}

class LoginRequest {
  String? email;
  String? password;
  LoginRequest({this.email, this.password});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email!.trim(),
      'password': password!.trim()
    };
    return map;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:workout/exceptions/exceptions.dart';
import 'dart:async';
import 'package:workout/models/models.dart';
import 'package:workout/services/services.dart';

//final _baseURL = 'https://bp-workout.herokuapp.com/api/';
final _baseURL = 'http://10.0.2.2:8000/api/';
final _usersURL = _baseURL + 'users/';
final _setsURL = _baseURL + 'sets/';
final _workoutURL = _baseURL + 'workouts/';
final _workoutSets = _baseURL + 'workout_sets/';
final _exercisesURL = _baseURL + 'exercises/';
//Auth endpoints
final _loginURL = _baseURL + 'token/';
final _refreshURL = _loginURL + 'refresh/';

String? accessToken;
StorageService storage = new StorageService();

class APIService {
  Future<User?> userLogin(LoginRequest? user) async {
    print("Logging in at: " + _loginURL);

    //http request to login with suppliewd user credentials
    var response = await http.post(Uri.parse(_loginURL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(user));

    LoginResponse res = LoginResponse.fromJson(json.decode(response.body));
    User? useR;
    // if request  is bad set state to unauthenticated
    if (response.statusCode == 401) {
      print("invalid credentials");
      throw InvalidUsernamePassword(
          "Invalid username or password! Try again...");
    } else if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response == '') {
      print('Error: ' + res.error!);
      useR = null;
    }
    // If refreshToken is not empty: save refresh token to storage and set accessToken var
    //Then get user using access token
    else if (res.refreshToken != '') {
      print("Received valid refresh token: ${res.accessToken}");
      print("Recieved valid access token: ${res.refreshToken}");
      accessToken = res.accessToken;
      print("set access token: $accessToken");
      storage.saveToken(res.refreshToken);
      useR = await getUser();
    }
    return useR;
  }

  //TODO: Implement sign up method

  Future<int> attemptSignUp(String email, String password) async {
    try {
      final http.Response response = await http.post(Uri.parse(_usersURL),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: {
            "email": email,
            "password": password
          });
      return response.statusCode;
    } on Exception catch (e) {
      print("error signing up: $e");
      return 404;
    }
  }

  ///Gets user from access token
  ///check access token if invalid
  ///check refresh token
  ///if invalid return to login screen
  Future<User?> getUser() async {
    if (accessToken == null) {
      print("acces token is null");
      return null;
    }

    final parts = accessToken!.split('.');
    if (parts.length != 3) {
      print("invalid access token");
      return null;
    }
    //Retrieves user ID from token payload. Uses id to make user request to api.
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    print('Normalized: ' + normalized);
    var response = utf8.decode(base64Url.decode(normalized));
    final jsonPayload = json.decode(response);
    if (jsonPayload is! Map<String, dynamic>) {
      print(" token payload invalid");
      return null;
    }
    print('Payload: ' + jsonPayload['user_id'].toString());
    //Gets individual user with user id
    final http.Response res = await http.get(
      Uri.parse(_usersURL + jsonPayload['user_id'].toString()),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
    );
    print("Json body: ");
    print(res.body);
    User? user = User.fromJson(json.decode(res.body));
    //If access token is no longer valid adn api returns detail message:
    // makes a request for new access token with stored refresh token
    if (user?.detail != '') {
      print("User detail: ");
      print(user?.detail);
      bool tokenIsValid = await getRefreshToken();
      if (!tokenIsValid) {
        return null;
      } else {
        print('trying to get new access token and attempt to get user again');
        var tryAfterRefresh = await getUser();
        return tryAfterRefresh;
      }
    }
    print("returning user to authetication bloc");
    print(user?.firstName);
    return user;
  }

  ///Makes refreshtoken request to api with saved token.
  ///if token invalid then app needs new login request. Returns to login page.

  Future<bool> getRefreshToken() async {
    print("refreshing token");
    //First check if there is a refresh token saved
    String? refreshToken = await storage.getToken();
    if (refreshToken == '') {
      print("no refresh token saved==null");
      return false;
    }
    print(refreshToken);
    //Uses currently saved refresh token to request new accessToken
    final msg = jsonEncode({"refresh": "$refreshToken"});
    final http.Response res = await http.post(Uri.parse(_refreshURL),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: msg);
    // If refreshToken saved is expired. Delete token and return false.
    if (res.statusCode == 401) {
      print("invalid refresh token");
      storage.deleteToken();
      return false;
    } else {
      // if reviece refresh from api, then update access token and return true
      Map<String, dynamic> data = json.decode(res.body);
      accessToken = data['access'];
      print("new access token saved to variable: Returning true");
      return true;
    }
  }

  //Function removes both tokens and returns to login page
  Future<void> logoutUser() async {
    await storage.deleteToken();
    accessToken = '';
    print(
        "Refresh token and access token deleted. User successfully logged out");
  }

//Gets list of all database exercises
  Future<List<Exercise>?> getExercises() async {
    bool tokenValid = await getRefreshToken();
    List<Exercise>? exercises;
    if (!tokenValid) {
      return null;
    }
    final http.Response? response = await http.get(
      Uri.parse(_exercisesURL),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    print(response?.body);
    if (response == null) {
      print("Response was null");
      throw Exception('Get exercises response was null');
    } else {
      List<dynamic> res = json.decode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 400) {
        print('Error: ' + response.statusCode.toString());
        throw Exception('Error: ' + response.body);
      } else {
        res == []
            ? exercises = []
            : exercises = res.map((e) => Exercise.fromJson(e)).toList();
        return exercises;
      }
    }
  }

  Future<List<Workout>?> getWorkouts() async {
    bool tokenValid = await getRefreshToken();

    if (tokenValid) {
      final http.Response response = await http.get(
        Uri.parse(_workoutURL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode < 200 ||
          response.statusCode >= 400 ||
          response == '') {
        print("Error getting exercises: ");
        print(response.statusCode);
        print(response.body);
        throw CantGetExercises("Error getting exercises: ${response.body}");
      } else {
        Map<String, dynamic> res = json.decode(response.body);
        if (res['detail'] != '') {
          print(res['detail']);
        } else {
          print("succeeded in creating workout");
        }
      }
    }

    return [];
  }

//Find a way to logout user when refresh token is invalid
  Future<void> createWorkout(Workout newWorkout) async {
    print(newWorkout.toJson());
    bool tokenValid = await getRefreshToken();
    if (tokenValid) {
      final http.Response response = await http.post(Uri.parse(_workoutURL),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(newWorkout.toJson()));
      if (response.statusCode < 200 ||
          response.statusCode >= 400 ||
          response == '') {
        print("Error creating workout: ");
        print(response.statusCode);
        print(response.body);
        throw CantCreateWorkout("Error creating workout: ${response.body}");
      } else {
        Map<String, dynamic> res = json.decode(response.body);
        if (res['detail'] != '') {
          print(res['detail']);
        } else {
          print("succeeded in creating workout");
        }
      }
    } else {
      // Do if token is invalid?????????????????????????????????????????????
    }
  }

  Future<void> updateWorkout(String url, Workout updatedWorkout) async {}

  Future<List<Set>> getAllSets() async {
    return [];
  }

  Future<void> updateSet() async {}
}

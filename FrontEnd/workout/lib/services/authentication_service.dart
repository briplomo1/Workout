import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workout/exceptions/exceptions.dart';
import 'dart:async';
import 'package:workout/models/models.dart';
import 'package:workout/services/api.dart';
import 'package:workout/services/services.dart';

//final _baseURL = 'http://10.0.2.2:8000/api/';
final _baseURL = 'https://bp-workout.herokuapp.com/api/';
final _usersURL = _baseURL + 'users/';
final _setsURL = _baseURL + 'sets/';
final _loginURL = _baseURL + 'token/';
final _refreshURL = _loginURL + 'refresh/';

String? accessToken;

StorageService storage = new StorageService();

class AuthenticationService {
  AuthenticationService();

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
        response == null) {
      print('Error: ' + res.error!);
      useR = null;
    }
    // If token is valid = save refresh token and set access token variable
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
  ///
  ///check access token if invalid
  ///check refresh token
  ///if invalid return to login screen
  ///
  Future<User?> getUser() async {
    if (accessToken == null) {
      print("acces token is null");
      return null;
    }
    print("getting user with token: $accessToken at $_usersURL");
    final parts = accessToken!.split('.');
    if (parts.length != 3) {
      print("invalid access token");
      return null;
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var response = utf8.decode(base64Url.decode(normalized));
    final jsonPayload = json.decode(response);
    if (jsonPayload is! Map<String, dynamic>) {
      print(" token payload invalid");
      return null;
    }
    print(jsonPayload['user_id']);
    final http.Response res = await http.get(
      Uri.parse(_usersURL + jsonPayload['user_id'].toString()),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
    );
    print("Json body: ");
    print(json.decode(res.body));
    User? user = User.fromJson(json.decode(res.body));
    //If access token is invalid makes a request
    // for new access token with refresh token
    //
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

  ///
  ///
  ///Makes refreshtoken request to api with saved token.
  ///if token invalid then needs new login returns to login page

  Future<bool> getRefreshToken() async {
    print("refreshing token");
    //First check if there is a refresh token saved
    String refreshToken = await storage.getToken();
    if (refreshToken == null || refreshToken == '') {
      print("no refresh token saved==null");
      return false;
    }
    print(refreshToken);
    final msg = jsonEncode({"refresh": "$refreshToken"});
    final http.Response res = await http.post(Uri.parse(_refreshURL),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: msg);
    // Check if refresh token is still valid
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

  Future<void> logoutUser() async {
    //Must navigate to login screen
    //Function will remove tokens
    await storage.deleteToken();
    currentToken = '';
    print(
        "Refresh token and access token deleted. User successfully logged out");
  }
}

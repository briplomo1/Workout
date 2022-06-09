import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:workout/models/models.dart';
import 'package:workout/services/services.dart';

final _baseURL = 'https://bp-workout.herokuapp.com/api/';
//final _baseURL = 'http://10.0.2.2:8000/api/';
final _usersURL = _baseURL + 'users/';
final _setsURL = _baseURL + 'sets/';
final _loginURL = _baseURL + 'token/';

String? currentToken;

class APIService {
// Authenticate with usernbame and password and get tokens
  Future<void> userLogin(LoginRequest user) async {
    print("Logging in at: " + _loginURL);
    // Sets state to is authenticating while making http request
    //_controller.add(AuthenticationStatus.isAuthenticating);
    //http request to login with suppliewd user credentials
    final http.Response? response = await http.post(Uri.parse(_loginURL),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(user));
    LoginResponse res;

    if (response == null) {
      print("response recieved was null");
    } else {
      res = LoginResponse.fromJson(json.decode(response.body));
      // if request  is bad set state to unauthenticated
      if (response.statusCode < 200 || response.statusCode > 400) {
        //_controller.add(AuthenticationStatus.unauthenticated);
        print('Error: ' + res.error!);
      } else {
        // if a token is given save refresh token and set status to authenticated
        if (res.refreshToken != '') {
          currentToken = res.accessToken;
          //await storage.saveToken(res.refreshToken);
          //_controller.add(AuthenticationStatus.authenticated);
          print("token saved in storage");
        } else {
          //if no token is given set state to unauthenticated
          //_controller.add(AuthenticationStatus.unauthenticated);
          print("No token recieved");
        }
      }
      print(json.decode(response.body));
    }
  }

  Future<User?> getUser() async {
    final parts = currentToken!.split('.');
    if (parts.length != 3) {
      throw Exception("Invalid access token");
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var response = utf8.decode(base64Url.decode(normalized));
    final jsonPayload = json.decode(response);
    if (jsonPayload is! Map<String, dynamic>) {
      print(" token payload invalid");
      return null;
    }
    final http.Response res = await http.get(
      Uri.parse(_usersURL + jsonPayload['user_id']),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $currentToken',
      },
    );

    User? user = User.fromJson(json.decode(res.body));
    return user;
  }
}

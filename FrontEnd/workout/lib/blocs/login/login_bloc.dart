import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:workout/blocs/authentication/authentication_bloc.dart';
import 'package:workout/blocs/authentication/authentication_event.dart';
import 'package:workout/exceptions/exceptions.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:workout/services/authentication_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  LoginBloc(AuthenticationBloc? authenticationBloc,
      AuthenticationService? authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc!,
        _authenticationService = authenticationService!,
        super(LoginInitial()) {
    on<LoginButtonPressed>(_mapLoginButtonPressedToState);
  }

  // @override
  // Stream<LoginState> mapEventToState(LoginEvent event) async* {
  //   if (event is LoginButtonPressed) {
  //     yield* _mapLoginButtonPressedToState(event);
  //   }
  // }
  // Stream<LoginState> _mapLoginButtonPressedToState(
  //     LoginButtonPressed event) async* {

  Future<void> _mapLoginButtonPressedToState(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    print("Trying login user await");
    try {
      emit(LoginLoading());
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
    try {
      final user = await _authenticationService.userLogin(event.user);
      if (user != null) {
        print("User logged in...");
        _authenticationBloc.add(UserLoggedIn(user: user));
        emit(LoginSuccess());
        emit(LoginInitial());
      } else {
        emit(LoginFailure(error: "Could not get user. User null..."));
      }
    } on InvalidUsernamePassword catch (e) {
      emit(LoginFailure(error: e.message));
    } on SocketException catch (e) {
      emit(LoginFailure(error: e.message));
    } catch (e) {
      emit(LoginFailure(error: 'An unknown error ocurred'));
    }
  }
}

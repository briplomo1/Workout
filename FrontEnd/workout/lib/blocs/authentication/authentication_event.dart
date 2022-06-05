import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:workout/models/models.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

//When app is launched
class AppLoaded extends AuthenticationEvent {
  final bool? isvalidToken;
  AppLoaded({this.isvalidToken});

  @override
  List<Object?> get props => [isvalidToken];
}

//When user has logged in
class UserLoggedIn extends AuthenticationEvent {
  final User user;

  UserLoggedIn({required this.user});

  @override
  List<Object> get props => [user];
}

//When user logged out
class UserLoggedOut extends AuthenticationEvent {}

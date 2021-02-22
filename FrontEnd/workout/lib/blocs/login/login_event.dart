import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:workout/models/models.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final LoginRequest user;

  LoginButtonPressed({@required this.user});

  @override
  List<Object> get props => [user];
}

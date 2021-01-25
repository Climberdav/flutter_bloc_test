import 'package:equatable/equatable.dart';
import 'package:bloc_app/model/user.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthenticationEvent {}

class UserLoggedIn extends AuthenticationEvent {
  final User user;

  UserLoggedIn({this.user});

  @override
  List<Object> get props => [user];
}

class UserLoggedOut extends AuthenticationEvent {}

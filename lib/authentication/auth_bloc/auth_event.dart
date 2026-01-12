import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;

  SignupRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
  });
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested(this.email);
}

class LogoutRequested extends AuthEvent {}

class TogglePasswordVisibility extends AuthEvent {
  final bool isLoginPage;

   TogglePasswordVisibility({this.isLoginPage = true});

  @override
  List<Object?> get props => [isLoginPage];
}

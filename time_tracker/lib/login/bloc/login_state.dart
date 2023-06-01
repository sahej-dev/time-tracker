part of 'login_bloc.dart';

final class LoginState extends Equatable {
  LoginState({
    this.status = FormzSubmissionStatus.initial,
    Email? email,
    this.password = const Password.pure(),
    this.isValid = false,
  }) : email = email ?? Email.pure();

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final bool isValid;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    bool? isValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [status, email, password];
}

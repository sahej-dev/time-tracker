part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignupFullNameChanged extends SignupEvent {
  final String fullName;

  const SignupFullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class SignupPhoneChanged extends SignupEvent {
  final String phone;

  const SignupPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();

  @override
  List<Object?> get props => [];
}

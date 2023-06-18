part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final FormzSubmissionStatus status;
  final FullName fullName;
  final Email email;
  final Phone phone;
  final Password password;
  final bool isValid;

  SignupState._({
    this.status = FormzSubmissionStatus.initial,
    this.fullName = const FullName.pure(),
    Email? email,
    Phone? phone,
    this.password = const Password.pure(),
    this.isValid = false,
  })  : email = email ?? Email.pure(),
        phone = phone ?? Phone.pure();

  SignupState.initial() : this._();

  SignupState copyWith({
    FormzSubmissionStatus? status,
    FullName? fullName,
    Email? email,
    Phone? phone,
    Password? password,
  }) {
    return SignupState._(
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isValid: Formz.validate([
        fullName ?? this.fullName,
        email ?? this.email,
        phone ?? this.phone,
        password ?? this.password,
      ]),
    );
  }

  @override
  List<Object?> get props => [
        status,
        fullName,
        email,
        phone,
        password,
        isValid,
      ];
}

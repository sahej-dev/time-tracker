import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:authentication_repository/authentication_repository.dart';

import '../models/models.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(SignupState.initial()) {
    on<SignupFullNameChanged>(_onFullNameChange);
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupPhoneChanged>(_onPhoneChanged);
    on<SignupSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onFullNameChange(
    SignupFullNameChanged event,
    Emitter<SignupState> emit,
  ) async {
    final fullName = FullName.dirty(event.fullName);

    emit(state.copyWith(
      fullName: fullName,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onEmailChanged(
    SignupEmailChanged event,
    Emitter<SignupState> emit,
  ) async {
    final email = Email.dirty(event.email);

    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPhoneChanged(
    SignupPhoneChanged event,
    Emitter<SignupState> emit,
  ) async {
    final phone = Phone.dirty(event.phone);

    emit(state.copyWith(
      phone: phone,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = Password.dirty(event.password);

    emit(state.copyWith(
      password: password,
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await _authenticationRepository.signUp(
          email: state.email.value,
          password: state.password.value,
          fullName: state.fullName.value,
          phone: state.phone.value,
        );

        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}

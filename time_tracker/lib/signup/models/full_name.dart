import 'package:formz/formz.dart';

enum FullNameValidationError { empty }

class FullName extends FormzInput<String, FullNameValidationError> {
  const FullName.pure([super.value = '']) : super.pure();
  const FullName.dirty([super.value = '']) : super.dirty();

  @override
  FullNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : FullNameValidationError.empty;
  }
}

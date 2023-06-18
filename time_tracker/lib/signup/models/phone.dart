import 'package:formz/formz.dart';

enum PhoneValidationError { invalid }

class Phone extends FormzInput<String, PhoneValidationError>
    with FormzInputErrorCacheMixin {
  Phone.pure([super.value = '']) : super.pure();
  Phone.dirty([super.value = '']) : super.dirty();

  static final _phoneRegExp = RegExp(
    r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
  );

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty) return null;

    if (!_phoneRegExp.hasMatch(value)) return PhoneValidationError.invalid;

    return null;
  }
}

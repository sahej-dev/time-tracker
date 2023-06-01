import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.firstName,
    required this.email,
    this.username,
    this.lastName,
    this.phone,
  });

  final String id;
  @JsonKey(name: "first_name")
  final String firstName;
  final String email;
  final String? username;
  @JsonKey(name: "last_name")
  final String? lastName;
  final String? phone;

  static User fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, username, firstName, lastName, email, phone];
}

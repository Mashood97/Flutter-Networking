import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "first_name")
  String first_name;
  @JsonKey(name: "last_name")
  String last_name;
  @JsonKey(name: "avatar")
  String avatar;

  User();
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}



import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';
part 'single_user_response.g.dart';

@JsonSerializable()
class SingleUserResponse{

  @JsonKey(name: "data")
  User user;

  SingleUserResponse();
  factory SingleUserResponse.fromJson(Map<String, dynamic> json) => _$SingleUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SingleUserResponseToJson(this);

}
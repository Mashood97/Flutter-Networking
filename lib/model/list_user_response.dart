import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';
part 'list_user_response.g.dart';

@JsonSerializable()
class ListUserResponse{

  @JsonKey(name: "data")
  List<User> user;

  ListUserResponse();
  factory ListUserResponse.fromJson(Map<String, dynamic> json) => _$ListUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListUserResponseToJson(this);

}
//Run this command in terminal
// flutter packages pub run build_runner builds
// Run this command in terminal to watch auto change
// flutter packages pub run build_runner watch
// Run this command in terminal to watch auto change and delete previously generated files
// flutter packages pub run build_runner watch --delete-conflicting-outputs

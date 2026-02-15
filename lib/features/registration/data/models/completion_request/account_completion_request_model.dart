import 'package:json_annotation/json_annotation.dart';

part 'account_completion_request_model.g.dart';

@JsonSerializable()
class AccountCompletionRequestModel {
  String registrationId;
  bool createNewAccount;

  AccountCompletionRequestModel({
    required this.registrationId,
    required this.createNewAccount,
  });

  factory AccountCompletionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccountCompletionRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountCompletionRequestModelToJson(this);
}

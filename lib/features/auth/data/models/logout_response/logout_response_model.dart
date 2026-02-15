import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_response_model.g.dart';

@JsonSerializable(createToJson: false)
class LogoutResponseModel {
  final bool success;
  final String message;

  LogoutResponseModel({required this.success, required this.message});

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseModelFromJson(json);
}

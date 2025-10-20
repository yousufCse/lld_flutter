import 'api_constant.dart';

class DevAppUrl implements AppUrl {
  @override
  String get baseUrl => 'https://uat-api.example.com';

  @override
  String get authUrl => 'https://uat-auth.example.com';

  @override
  String get verificationUrl => 'https://uat-verify.example.com';
}

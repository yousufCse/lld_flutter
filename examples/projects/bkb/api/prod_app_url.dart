import 'api_constant.dart';

class ProdAppUrl extends AppUrl {
  @override
  String get authUrl => 'https://prod-auth.example.com';

  @override
  String get baseUrl => 'https://prod-api.example.com';

  @override
  String get verificationUrl => 'https://prod-verify.example.com';
}

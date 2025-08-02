import 'package:flutter/widgets.dart';

class TestUser {
  final String name;
  final int age;

  TestUser(this.name, this.age);
}

class UserViewModel {
  final user = ValueNotifier<TestUser?>(null);

  Future<void> fetchTestUser() async {
    user.value = null;
    await Future.delayed(const Duration(seconds: 3));
    final yousuf = TestUser('Md. Yousuf Ali', 32);
    user.value = yousuf;
  }
}

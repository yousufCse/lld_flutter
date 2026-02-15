import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<void> saveInt(String key, int value);

  Future<int?> getInt(String key);
}

@LazySingleton(as: StorageService)
class StorageServiceImpl implements StorageService {
  final SharedPreferencesAsync sharedPreferences;

  StorageServiceImpl(this.sharedPreferences);

  @override
  Future<int?> getInt(String key) {
    return sharedPreferences.getInt(key);
  }

  @override
  Future<void> saveInt(String key, int value) {
    return sharedPreferences.setInt(key, value);
  }
}

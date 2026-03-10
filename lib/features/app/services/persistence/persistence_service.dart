import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'persistence_service.g.dart';

@Riverpod(keepAlive: true)
class PersistenceService extends _$PersistenceService {
  late SharedPreferences _prefs;

  @override
  void build() {
    _prefs = ref.watch(sharedPreferencesProvider);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

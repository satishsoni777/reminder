import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPref {
  static SharedPreferences? sharedPreferences;
  Future<SharedPreferences> get getPref async {
    sharedPreferences =
        sharedPreferences ?? (await SharedPreferences.getInstance());
    return sharedPreferences!;
  }

  Future<bool> setString(String key, dynamic value) async {
    if (value == null) {
      return false;
    }
    return (await getPref).setString(key, value);
  }

  Future<dynamic>? getString(String key) async {
    final data = (await getPref).getString(key);
    if (data == null || data.isEmpty) {
      return null;
    } else {
      return jsonDecode(data);
    }
  }
}

class SharedPrefImpl extends SharedPref {
  SharedPrefImpl._();

  static SharedPrefImpl instance = SharedPrefImpl._();
  static SharedPreferences? sharedPreferences;

  @override
  Future<SharedPreferences> get getPref async {
    return super.getPref;
  }

  Future<dynamic> getJsonObject(String key) async {
    final result = await getString(key);
    return jsonDecode(result);
  }

  @override
  Future<bool> setString(String key, dynamic value) async {
    return super.setString(key, jsonEncode(value));
  }
}

class SharPrefKeys {
  static const packages = "AppPackagesKey";
}

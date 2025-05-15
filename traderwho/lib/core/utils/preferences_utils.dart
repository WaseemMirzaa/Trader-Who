import 'package:hive/hive.dart';

import 'constants.dart';

/// A [PreferencesUtil] class for managing preferences using Hive.
class PreferencesUtil {
  /// A singleton instance of [PreferencesUtil].
  late Box<dynamic> preferences;

  /// A constructor that initializes the [PreferencesUtil] with a Hive box.
  PreferencesUtil(this.preferences);

  /// A [getPreferencesData] method to initialize the preferences box.
  dynamic getPreferencesData(String key) {
    return preferences.get(key) ?? '';
  }

  /// A [getBoolPreferencesData] method to initialize the preferences box.

  dynamic getBoolPreferencesData(String key, {bool defaultValue = false}) {
    return preferences.get(key) ?? defaultValue;
  }

  /// A [setPreferencesData] method to set a value in the preferences box.
  Future<void> setPreferencesData(String key, String? value) async {
    await preferences.put(key, value ?? '');
  }

  /// A [setBoolPreferencesData] method to set a boolean value in the preferences box.

  void setBoolPreferencesData(String key, {bool? value}) async {
    await preferences.put(key, value ?? false);
  }

  /// [clearPreferencesData] method to delete a value from the preferences box.

  Future<void> clearPreferencesData(String key) async {
    await preferences.delete(key);
  }

  /// A [getSelectedLanguage] method to get the selected language from preferences.

  String getSelectedLanguage() =>
      preferences.get(kSelectedLanguage, defaultValue: 'en') ?? 'en';

  /// A [setSelectedLanguage] method to set the selected language in preferences.
  Future<void> setSelectedLanguage(String languageCode) async =>
      await preferences.put(kSelectedLanguage, languageCode);
}

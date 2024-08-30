import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();

  SharedPreferences? _prefs;
  bool _isInitialized = false;
  final Logger _logger = Logger();

  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal();

  Future<void> _initializePreferences() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<void> setValue<T>(String key, T value) async {
    await _initializePreferences();

    try {
      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs!.setStringList(key, value);
      } else {
        throw UnsupportedError('Unsupported type');
      }
    } catch (e) {
      _logger.e('Error setting value for key "$key": $e');
    }
  }

  Future<T?> getValue<T>(String key) async {
    await _initializePreferences();

    try {
      if (T == String) {
        return _prefs!.getString(key) as T?;
      } else if (T == int) {
        return _prefs!.getInt(key) as T?;
      } else if (T == double) {
        return _prefs!.getDouble(key) as T?;
      } else if (T == bool) {
        return _prefs!.getBool(key) as T?;
      } else if (T == List<String>) {
        return _prefs!.getStringList(key) as T?;
      } else if (T == dynamic) {
        return _prefs!.get(key) as T?;
      } else {
        throw UnsupportedError('Unsupported type');
      }
    } catch (e) {
      _logger.e('Error getting value for key "$key": $e');
      return null;
    }
  }

  Future<void> removeValue(String key) async {
    await _initializePreferences();

    try {
      await _prefs!.remove(key);
    } catch (e) {
      _logger.e('Error removing value for key "$key": $e');
    }
  }

  Future<void> clearAll() async {
    await _initializePreferences();

    try {
      await _prefs!.clear();
    } catch (e) {
      _logger.e('Error clearing all preferences: $e');
    }
  }

  Future<Map<String, dynamic>> getStudentData() async {
    await _initializePreferences();

    final Map<String, dynamic> studentData = {};

    try {
      final keys = _prefs!.getKeys();
      await Future.forEach<String>(keys, (key) async {
        if (key.startsWith('student.')) {
          studentData[key] = _prefs!.get(key);
        }
      });

      return studentData;
    } catch (e) {
      _logger.e('Error getting student data: $e');
      return studentData;
    }
  }
}

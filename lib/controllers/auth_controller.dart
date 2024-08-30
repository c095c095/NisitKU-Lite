import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:nisitku_lite/services/auth_service.dart';
import 'package:nisitku_lite/services/shared_preferences_service.dart';
import 'package:nisitku_lite/utils/text.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final Logger _logger = Logger();

  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var errorMessage = ''.obs;
  var user = {}.obs;
  var token = ''.obs;

  Future<void> login(String username, String password) async {
    try {
      isLoading(true);
      errorMessage('');

      final result = await _authService.login(username, password);

      if (result['success'] == true) {
        token.value = result['data']['token'];
        final studentId = result['data']['id'];

        await Future.wait([
          _storage.write(key: 'token', value: token.value),
          _storage.write(key: 'student_id', value: studentId),
        ]);

        var profile = await _authService.getProfile(token.value, studentId);

        if (profile['success'] == true) {
          user.value = profile['data']..remove('status');
          result['data']['surname_en'] = capitalize(result['data']['surname_en']);

          user.addAll({
            'firstname_th': result['data']['name_th'],
            'lastname_th': result['data']['surname_th'],
            'firstname_en': result['data']['name_en'],
            'lastname_en': result['data']['surname_en'],
          });

          await _updateUserPreferences(user);

          isAuthenticated(true);
          _logger.i('Login success: ${user.values}');
          Get.offAllNamed('/home');
        } else {
          await _clearAuthData();

          _logger.w('Login failed: ${profile['message']}');
          errorMessage('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ โปรดติดต่อผู้ดูแลระบบ');
        }
      } else {
        _logger.w('Login failed: ${result['message']}');
        errorMessage(result['message']);
      }
    } catch (e) {
      _logger.e('Unexpected error: $e');
      errorMessage('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ โปรดติดต่อผู้ดูแลระบบ');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadUserFromStorage() async {
    try {
      token.value = await _storage.read(key: 'token') ?? '';

      if (token.value.isNotEmpty) {
        isLoading(true);
        errorMessage('');

        final result = await _prefsService.getStudentData();

        if (result.isNotEmpty) {
          user.value = result;
          isAuthenticated(true);

          _logger.i('User loaded from storage: ${user.values}');
        }

        var profile = await _authService.getProfile(token.value, user['id']);

        if (profile['success'] == true) {
          profile['data']?.remove('status');

          final updatedUser = {
            if (user['firstname_th'] != null) 'firstname_th': user['firstname_th'],
            if (user['lastname_th'] != null) 'lastname_th': user['lastname_th'],
            if (user['firstname_en'] != null) 'firstname_en': user['firstname_en'],
            if (user['lastname_en'] != null) 'lastname_en': user['lastname_en'],
          };

          user.value = {...profile['data'], ...updatedUser};

          for (final entry in user.entries) {
            await _prefsService.setValue('student.${entry.key}', entry.value);
          }

          _logger.i('User updated: ${user.values}');

          isAuthenticated(true);
        } else {
          _logger.w('Failed to get profile: ${profile['message']}');
        }
      }
    } catch (e) {
      _logger.e('Unexpected error: $e');
      errorMessage('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ โปรดติดต่อผู้ดูแลระบบ');
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    await _clearAuthData();
    Get.offAllNamed('/login');
  }

  Future<void> _updateUserPreferences(RxMap<dynamic, dynamic> data) async {
    for (final entry in data.entries) {
      await _prefsService.setValue('student.${entry.key}', entry.value);
    }
  }

  Future<void> _clearAuthData() async {
    isAuthenticated(false);
    user.clear();
    token.value = '';
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'student_id');
    await _prefsService.clearAll();
  }
}

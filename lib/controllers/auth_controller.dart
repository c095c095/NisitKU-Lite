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

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading(true);
      errorMessage('');

      final result = await _authService.login(username, password);

      if (result['success'] == true) {
        final token = result['data']['token'];
        final studentId = result['data']['id'];

        await Future.wait([
          _storage.write(key: 'token', value: token),
          _storage.write(key: 'student_id', value: studentId),
        ]);

        var profile = await _authService.getProfile();

        if (profile['success'] == true) {
          profile['data']?.remove('status');

          user.value = profile['data'];

          for (final entry in user.entries) {
            await _prefsService.setValue('student.${entry.key}', entry.value);
          }

          result['data']['surname_en'] =
              capitalize(result['data']['surname_en']);

          user.addAll({
            'firstname_th': result['data']['name_th'],
            'lastname_th': result['data']['surname_th'],
            'firstname_en': result['data']['name_en'],
            'lastname_en': result['data']['surname_en'],
          });
          await _prefsService.setValue(
              'student.firstname_th', result['data']['name_th']);
          await _prefsService.setValue(
              'student.lastname_th', result['data']['surname_th']);
          await _prefsService.setValue(
              'student.firstname_en', result['data']['name_en']);
          await _prefsService.setValue(
              'student.lastname_en', result['data']['surname_en']);

          isAuthenticated(true);
          _logger.i('Login success: ${user.values}');
        } else {
          await _storage.delete(key: 'token');
          await _storage.delete(key: 'id');

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

      if (isAuthenticated.value) {
        Get.offAllNamed('/home');
      }
    }
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final token = await _storage.read(key: 'token');

      if (token != null) {
        isLoading(true);
        errorMessage('');

        final result = await _prefsService.getStudentData();

        if (result.isNotEmpty) {
          user.value = result;
          isAuthenticated(true);

          _logger.i('User loaded from storage: ${user.values}');
        }

        var profile = await _authService.getProfile();

        if (result['success'] == true) {
          profile['data']?.remove('status');

          user.value = profile['data'];

          for (final entry in user.entries) {
            await _prefsService.setValue(entry.key, entry.value);
          }

          isAuthenticated(true);
        }
      }
    } catch (e) {
      _logger.e('Unexpected error: $e');
      errorMessage('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ โปรดติดต่อผู้ดูแลระบบ');
    } finally {
      isLoading(false);

      if (isAuthenticated.value) {
        Get.offAllNamed('/home');
      }
    }
  }

  Future<void> logout() async {
    // _authService.logout();
    isAuthenticated(false);
    user.clear();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'id');
    Get.offAllNamed('/login');
  }
}

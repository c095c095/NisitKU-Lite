import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/services/auth_service.dart';
import 'package:nisitku_lite/services/shared_preferences_service.dart';
import 'package:logger/logger.dart';

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
    // _loadUserFromStorage();
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
            await _prefsService.setValue(entry.key, entry.value);
          }

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
    final token = await _storage.read(key: 'token');

    if (token != null) {
      try {
        isLoading(true);
        errorMessage('');

        final result = await _authService.getProfile();

        if (result['success']) {
          user.value = result['data'];
          isAuthenticated(true);
        } else {
          errorMessage(result['message']);
        }

        if (result['forceLogout'] == true) {
          await logout();
        }
      } catch (e) {
        errorMessage('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ โปรดติดต่อผู้ดูแลระบบ');
        await logout();
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> logout() async {
    _authService.logout();
    isAuthenticated(false);
    user.clear();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'id');
    Get.offAllNamed('/login');
  }
}

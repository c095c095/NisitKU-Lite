import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var errorMessage = ''.obs;
  var user = {}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }

  Future<void> loadUserFromStorage() async {
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
          logout();
        }
      } catch (e) {
        errorMessage('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ โปรดติดต่อผู้ดูแลระบบ');
        logout();
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _authService.login(username, password);

      if (result['success']) {
        await _storage.write(key: 'token', value: result['data']['token']);
        await _storage.write(key: 'id', value: result['data']['id']);
        user.value = result['data'];
        isAuthenticated(true);
      } else {
        errorMessage(result['message']);
      }
    } catch (e) {
      errorMessage('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ โปรดติดต่อผู้ดูแลระบบ');
    } finally {
      isLoading(false);

      if (isAuthenticated.value) {
        Get.offAllNamed('/home');
      }
    }
  }

  void logout() async {
    _authService.logout();
    isAuthenticated(false);
    user.clear();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'id');
  }
}

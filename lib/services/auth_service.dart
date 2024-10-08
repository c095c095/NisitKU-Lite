import 'package:get/get.dart';
import 'package:nisitku_lite/config/api_config.dart';
import 'package:nisitku_lite/utils/check_internet_connnection.dart';

class AuthService extends GetxService {
  final GetHttpClient _httpClient = GetHttpClient();

  Future<Map<String, dynamic>> login(String username, String password) async {
    if (!await checkInternetConnection()) {
      return {'success': false, 'message': 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้'};
    }

    try {
      final response = await _httpClient.post(
        ApiConfig.controllerUrl,
        body: {
          'action': 'login',
          'id': username,
          'pass': password,
        },
      );

      if (response.body[0]['status'] == 'true') {
        return {'success': true, 'data': response.body[0]};
      } else {
        return {'success': false, 'message': 'รหัสผ่านไม่ถูกต้อง'};
      }
    } catch (e) {
      return {'success': false, 'message': 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ โปรดลองอีกครั้ง'};
    }
  }

  Future<Map<String, dynamic>> getProfile(String token, dynamic id) async {
    if (token.isEmpty || id == null || id?.isEmpty) {
      return {'success': false, 'forceLogout': true, 'message': 'ไม่พบข้อมูลการเข้าสู่ระบบ'};
    }

    if (!await checkInternetConnection()) {
      return {'success': false, 'forceLogout': false, 'message': 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้'};
    }

    try {
      final response = await _httpClient.post(
        ApiConfig.controllerUrl,
        body: {
          'action': 'profile',
          'id': id,
          'token': token,
        },
      );

      if (response.body[0]['status'] == 'true') {
        return {'success': true, 'forceLogout': false, 'data': response.body[0]};
      } else if (response.body[0]['status'] == 'false') {
        return {'success': false, 'forceLogout': true, 'message': 'ไม่สามารถดึงข้อมูลได้'};
      } else {
        return {'success': false, 'forceLogout': false, 'message': 'ไม่สามารถดึงข้อมูลได้'};
      }
    } catch (e) {
      return {'success': false, 'forceLogout': false, 'message': 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ โปรดลองอีกครั้ง'};
    }
  }

  Future<void> logout() async {}
}

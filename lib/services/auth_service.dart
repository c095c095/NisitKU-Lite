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
      return {
        'success': false,
        'message': 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ โปรดลองอีกครั้ง'
      };
    }
  }

  Future<void> logout() async {}
}

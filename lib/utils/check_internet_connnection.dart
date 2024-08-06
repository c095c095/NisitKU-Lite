import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkNetworkConnectivity() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    return false;
  } else {
    return true;
  }
}

Future<bool> checkInternetConnection() async {
  if (!await checkNetworkConnectivity()) {
    return false;
  }

  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  }
}

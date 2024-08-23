import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Checks the current network connectivity status.
///
/// Returns `true` if the device is connected to any network (Wi-Fi or mobile),
/// and `false` if there is no network connection.
Future<bool> checkNetworkConnectivity() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    return false;
  } else {
    return true;
  }
}

/// Checks if there is an active internet connection.
///
/// This function first verifies network connectivity using `checkNetworkConnectivity()`,
/// and then performs a lookup on Google's domain to confirm internet access.
///
/// Returns:
/// - `true` if there is an active internet connection.
/// - `false` if there is no network connectivity or if the lookup fails.
///
/// Throws:
/// - `SocketException` if the lookup encounters a network issue.
///
/// Example usage:
/// ```dart
/// bool isConnected = await checkInternetConnection();
/// if (isConnected) {
///   print('Connected to the internet.');
/// } else {
///   print('No internet connection.');
/// }
/// ```
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

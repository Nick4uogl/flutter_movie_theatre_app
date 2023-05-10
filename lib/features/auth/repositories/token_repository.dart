import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class TokenRepository {
  String secretKey = "2jukqvNnhunHWMBRRVcZ9ZQ9";
  final dio = Dio(BaseOptions(
    baseUrl: 'http://fs-mt.qwerty123.tech/api/auth/',
  ));

  Future<String> _getSessionToken() async {
    try {
      final response = await dio.post('/session');
      return response.data['data']['sessionToken'];
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while getting session token: $e');
    }
  }

  Future<String> getAccessToken() async {
    final sessionToken = await _getSessionToken();
    var firstChunk = utf8.encode(sessionToken);
    var secondChunk = utf8.encode(secretKey);
    var signature = sha256.convert([...firstChunk, ...secondChunk]);
    try {
      final response = await dio.post('/token', data: {
        "sessionToken": sessionToken,
        "signature": signature.toString(),
        "deviceId": await _getId(),
      });
      return response.data['data']['sessionToken'];
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while getting access token: $e');
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return '${webBrowserInfo.vendor ?? '-'} + ${webBrowserInfo.userAgent ?? '-'} + ${webBrowserInfo.hardwareConcurrency.toString()}';
    } else {
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      }
    }
    return null;
  }
}

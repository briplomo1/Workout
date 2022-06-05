import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

const String _applicationID = "myID";
const String _storageToken = "token";
String _deviceIdentity = "";

final _storage = new FlutterSecureStorage();
final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();

class Service {
  // Method gets device dentity

  Future<String> _getDeviceIdentity() async {
    if (_deviceIdentity == '') {
      try {
        if (Platform.isAndroid) {
          AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
          _deviceIdentity = "${info.device}-${info.id}";
        } else if (Platform.isIOS) {
          IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
          _deviceIdentity = "${info.model}-${info.identifierForVendor}";
        }
      } on PlatformException {
        _deviceIdentity = "unknown";
      }
    }
    return _deviceIdentity;
  }
}

// Method retrieves token from local storage
// if null returns empty string

class StorageService {
  Future<String> getToken() async {
    String? token = await _storage.read(key: "token");
    return token ?? '';
  }
// Method saves token to local storage

  Future<void> saveToken(String? token) async {
    await _storage.write(key: "token", value: token);
  }

//If token is invalid delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: "token");
  }
}

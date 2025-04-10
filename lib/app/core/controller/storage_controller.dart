import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  //user status
  Future<bool> getUserStatus() async {
    final String? value = await _secureStorage.read(key: "newUser");
    return value != null ? true : false;
  }

  Future<void> saveStatus(String value) async {
    await _secureStorage.write(key: "newUser", value: value);
  }

  Future<void> setShowMicToast(bool value) async {
    await _secureStorage.write(key: 'showMicToast', value: value.toString());
  }

  Future<bool> getShowMicToast() async {
    final value = await _secureStorage.read(key: 'showMicToast');
    return value == null || value == 'true';
  }
}

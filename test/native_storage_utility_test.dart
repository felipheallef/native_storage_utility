import 'package:flutter_test/flutter_test.dart';
import 'package:native_storage_utility/native_storage_utility.dart';
import 'package:native_storage_utility/src/native_storage_utility_platform_interface.dart';
import 'package:native_storage_utility/native_storage_utility_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeStorageUtilityPlatform
    with MockPlatformInterfaceMixin
    implements NativeStorageUtilityPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NativeStorageUtilityPlatform initialPlatform =
      NativeStorageUtilityPlatform.instance;

  test('$MethodChannelNativeStorageUtility is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeStorageUtility>());
  });

  test('getPlatformVersion', () async {
    NativeStorageUtility nativeStorageUtilityPlugin = NativeStorageUtility();
    MockNativeStorageUtilityPlatform fakePlatform =
        MockNativeStorageUtilityPlatform();
    NativeStorageUtilityPlatform.instance = fakePlatform;

    expect(await nativeStorageUtilityPlugin.getPlatformVersion(), '42');
  });
}

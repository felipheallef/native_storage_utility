import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'src/native_storage_utility_platform_interface.dart';

/// An implementation of [NativeStorageUtilityPlatform] that uses method channels.
class MethodChannelNativeStorageUtility extends NativeStorageUtilityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_storage_utility');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}

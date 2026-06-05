import 'dart:io';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'android_storage_utility_android.dart';
import 'native_storage_utility_foundation.dart';
import 'native_storage_utility_linux.dart';
import 'native_storage_utility_windows.dart';

// import 'src/method_channel_storage_utility.dart';

/// The interface that implementations of storage_utility must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `StorageUtility` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [NativeStorageUtilityPlatform] methods.
abstract class NativeStorageUtilityPlatform extends PlatformInterface {
  /// Constructs a NativeNativeStorageUtilityPlatform.
  NativeStorageUtilityPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeStorageUtilityPlatform _instance =
      switch (Platform.operatingSystem) {
        'ios' || 'macos' => NativeStorageUtilityFoundation(),
        'linux' => NativeStorageUtilityLinux(),
        'android' => NativeStorageUtilityAndroid(),
        'windows' => NativeStorageUtilityWindows(),
        _ => throw UnsupportedError(
          'Unsupported platform: ${Platform.operatingSystem}',
        ),
      };

  /// The default instance of [NativeStorageUtilityPlatform] to use.
  ///
  /// Defaults to [NativeStorageUtilityFoundation], [NativeStorageUtilityLinux], [NativeStorageUtilityAndroid], [NativeStorageUtilityWindows].
  static NativeStorageUtilityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeStorageUtilityPlatform] when
  /// they register themselves.
  static set instance(NativeStorageUtilityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Number of bytes available in storage.
  int getFreeBytes(String path) {
    throw UnimplementedError('getFreeBytes() has not been implemented.');
  }

  /// The total number of bytes supported by the storage.
  int getTotalBytes(String path) {
    throw UnimplementedError('getTotalBytes() has not been implemented.');
  }

  /// Open native directory via calling channel defined on platform interface
  ///
  /// The given parameter is the [path] to the directory on the respective platform
  ///
  /// This returns true if the path can be opened. Otherwise, it maybe null or false.
  void openDirectory(String path) {
    throw UnimplementedError('openDirectory() has not been implemented.');
  }

  void openFile(String path) {
    throw UnimplementedError('openFile() has not been implemented.');
  }
}

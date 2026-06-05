import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:xdg_desktop_portal/xdg_desktop_portal.dart';

import 'ffi/linux_bindings.dart';
import 'native_storage_utility_platform_interface.dart';

/// The Android implementation of [NativeStorageUtilityPlatform].
class NativeStorageUtilityAndroid extends NativeStorageUtilityPlatform {
  @override
  int getFreeBytes(String path) => using((arena) {
    final pathPtr = path.toNativeUtf8(allocator: arena);
    final bufferPtr = arena<statvfs>();

    final result = statvfs$1(pathPtr.cast(), bufferPtr);

    if (result != 0) {
      throw Exception('Unable to get free bytes of storage space');
    }

    return bufferPtr.ref.f_bavail * bufferPtr.ref.f_frsize;
  });

  @override
  int getTotalBytes(String path) => using((arena) {
    final pathPtr = path.toNativeUtf8(allocator: arena);
    final bufferPtr = arena<statvfs>();

    final result = statvfs$1(pathPtr.cast(), bufferPtr);

    if (result != 0) {
      throw Exception('Unable to get free bytes of storage space');
    }

    return bufferPtr.ref.f_blocks * bufferPtr.ref.f_frsize;
  });

  @override
  Future<void> openDirectory(String path) async {
    final client = XdgDesktopPortalClient();
    try {
      await client.openUri.openUri(Uri.file(path).toString());
    } finally {
      await client.close();
    }
  }
}

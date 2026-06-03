import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'storage_utility_platform_interface.dart';

/// The Windows implementation of [StorageUtilityPlatform].
class StorageUtilityWindows extends StorageUtilityPlatform {
  @override
  int getFreeBytes(String path) => using((arena) {
    final pathNamePtr = path.toNativeUtf16(allocator: arena);
    final lpFreeBytesAvailableToCaller = arena<ULONGLONG>();
    final lpTotalNumberOfFreeBytes = arena<ULONGLONG>();

    final result = GetDiskFreeSpaceEx(
      pathNamePtr,
      lpFreeBytesAvailableToCaller,
      nullptr,
      lpTotalNumberOfFreeBytes,
    );

    if (result == FALSE) {
      throw Exception('Unable to get free bytes of storage space');
    }

    return min(
      lpFreeBytesAvailableToCaller.value,
      lpTotalNumberOfFreeBytes.value,
    );
  });

  @override
  int getTotalBytes(String path) => using((arena) {
    final pathNamePtr = path.toNativeUtf16(allocator: arena);
    final lpTotalNumberOfBytes = arena<ULONGLONG>();

    final result = GetDiskFreeSpaceEx(
      pathNamePtr,
      nullptr,
      lpTotalNumberOfBytes,
      nullptr,
    );

    if (result == FALSE) {
      throw Exception('Unable to get total bytes of storage space');
    }

    return lpTotalNumberOfBytes.value;
  });

  @override
  Future<bool?> openDirectory(String path) async => using((arena) {
    final pathNamePtr = path.toNativeUtf16(allocator: arena);
    final operationPtr = 'open'.toNativeUtf16(allocator: arena);

    final hwnd = GetForegroundWindow();
    ShellExecute(
      hwnd,
      operationPtr,
      pathNamePtr,
      nullptr,
      nullptr,
      SW_SHOWNORMAL,
    );

    return true;
  });
}

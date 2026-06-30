import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'native_storage_utility_platform_interface.dart';

/// The Windows implementation of [StorageUtilityPlatform].
class NativeStorageUtilityWindows extends NativeStorageUtilityPlatform {
  @override
  int getFreeBytes(String path) => using((arena) {
    final pathNamePtr = arena.pcwstr(path);
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
    final pathNamePtr = arena.pcwstr(path);
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
  Future<bool?> openFile(String path) async => using((arena) {
    final pathNamePtr = arena.pcwstr(path);
    final operationPtr = arena.pcwstr('open');

    final hwnd = GetForegroundWindow();

    ShellExecute(hwnd, operationPtr, pathNamePtr, null, null, SW_SHOWNORMAL);

    return true;
  });

  @override
  Future<bool?> openDirectory(String path) => openFile(path);
}

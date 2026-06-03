import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'storage_utility_platform_interface.dart';

/// The Windows implementation of [StorageUtilityPlatform].
class StorageUtilityWindows extends StorageUtilityPlatform {
  @override
  int getFreeBytes(String path) {
    final pathNamePtr = path.toNativeUtf16();
    final lpFreeBytesAvailableToCaller = calloc<ULONGLONG>();
    final lpTotalNumberOfFreeBytes = calloc<ULONGLONG>();

    try {
      final int hr = GetDiskFreeSpaceEx(
        pathNamePtr,
        lpFreeBytesAvailableToCaller,
        nullptr,
        lpTotalNumberOfFreeBytes,
      );

      if (FAILED(hr)) {
        throw Exception('Unable to get free bytes of storage space');
      }

      return min(
        lpFreeBytesAvailableToCaller.value,
        lpTotalNumberOfFreeBytes.value,
      );
    } finally {
      free(pathNamePtr);
      free(lpFreeBytesAvailableToCaller);
      free(lpTotalNumberOfFreeBytes);
    }
  }

  @override
  int getTotalBytes(String path) {
    final pathNamePtr = path.toNativeUtf16();
    final lpTotalNumberOfBytes = calloc<ULONGLONG>();

    try {
      final int hr = GetDiskFreeSpaceEx(
        pathNamePtr,
        nullptr,
        lpTotalNumberOfBytes,
        nullptr,
      );

      if (FAILED(hr)) {
        throw Exception('Unable to get total bytes of storage space');
      }

      return lpTotalNumberOfBytes.value;
    } finally {
      free(pathNamePtr);
      free(lpTotalNumberOfBytes);
    }
  }

  @override
  Future<bool?> openDirectory(String path) async {
    final pathNamePtr = path.toNativeUtf16();
    final operationPtr = 'open'.toNativeUtf16();

    try {
      final hwnd = GetForegroundWindow();
      ShellExecute(
        hwnd,
        operationPtr,
        pathNamePtr,
        nullptr,
        nullptr,
        SW_SHOWNORMAL,
      );
    } finally {
      free(pathNamePtr);
      free(operationPtr);
    }

    return true;
  }
}

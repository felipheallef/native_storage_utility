import 'dart:io';

import 'package:objective_c/objective_c.dart';

import 'ffi/foundation_bindings.dart';
import 'native_storage_utility_platform_interface.dart';

/// The iOS and macOS implementation of [StorageUtilityPlatform].
class NativeStorageUtilityFoundation extends NativeStorageUtilityPlatform {
  NSFileManager get _manager => NSFileManager.getDefaultManager();
  NSWorkspace get _workspace => NSWorkspace.getSharedWorkspace();

  @override
  int getFreeBytes(String path) {
    final url = NSURL.fileURLWithPath(NSString(path));
    final attributes = url.resourceValuesForKeys(
      NSArray.of([NSURLVolumeAvailableCapacityForImportantUsageKey]),
    );

    final bytes =
        attributes?.objectForKey(
              NSURLVolumeAvailableCapacityForImportantUsageKey,
            )
            as NSNumber?;

    if (bytes == null) {
      throw Exception('Unable to get free bytes of storage space');
    }

    return bytes.longValue;
  }

  @override
  int getTotalBytes(String path) {
    final attributes = _manager.attributesOfFileSystemForPath(NSString(path));

    if (attributes == null) {
      throw Exception('Unable to get total bytes of storage space');
    }

    final bytes = attributes.objectForKey(NSFileSystemSize) as NSNumber?;

    return bytes?.longValue ?? 0;
  }

  @override
  Future<void> openDirectory(String path) async {
    if (Platform.isMacOS) {
      if (await FileSystemEntity.isDirectory(path)) {
        _workspace.openFile(NSString(path));
      } else {
        final url = NSURL.fileURLWithPath(NSString(path));
        _workspace.activateFileViewerSelectingURLs(.of([url]));
      }
    }
  }

  @override
  void openFile(String path) {
    final nativePath = NSString(path);

    if (!_manager.fileExistsAtPath(nativePath)) {
      throw Exception('File does not exist: $path');
    }

    if (!_manager.isReadableFileAtPath(nativePath)) {
      throw Exception('File is not readable: $path');
    }

    // final url = NSURL.fileURLWithPath(nativePath);

    _workspace.openFile(nativePath);
  }
}

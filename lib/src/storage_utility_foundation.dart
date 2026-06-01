import 'dart:io';

import 'package:objective_c/objective_c.dart';

import 'ffi/foundation_bindings.dart';
import 'storage_utility_platform_interface.dart';

/// The iOS and macOS implementation of [StorageUtilityPlatform].
class StorageUtilityFoundation extends StorageUtilityPlatform {
  NSFileManager get _manager => NSFileManager.getDefaultManager();

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
  Future<bool?> openDirectory(String path) async {
    if (Platform.isMacOS) {
      final workspace = NSWorkspace.getSharedWorkspace();

      if (await FileSystemEntity.isDirectory(path)) {
        workspace.openFile(NSString(path));
      } else {
        final url = NSURL.fileURLWithPath(NSString(path));
        workspace.activateFileViewerSelectingURLs(.of([url]));
      }
    }

    return true;
  }
}

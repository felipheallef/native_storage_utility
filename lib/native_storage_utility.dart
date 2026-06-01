import 'src/storage_utility_platform_interface.dart';

StorageUtilityPlatform get _platform => StorageUtilityPlatform.instance;

/// Number of bytes available in storage.
int getFreeBytes(String path) {
  return _platform.getFreeBytes(path);
}

/// The total number of bytes supported by the storage.
int getTotalBytes(String path) {
  return _platform.getTotalBytes(path);
}

/// Open native directory via calling channel defined on platform interface
///
/// The given parameter is the [path] to the directory on the respective platform
///
/// This returns true if the path can be opened. Otherwise, it maybe null or false.
Future<bool?> openDirectory(String path) async {
  return _platform.openDirectory(path);
}

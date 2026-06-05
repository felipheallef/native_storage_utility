import 'src/native_storage_utility_platform_interface.dart';

NativeStorageUtilityPlatform get _platform => .instance;

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
void openDirectory(String path) {
  return _platform.openDirectory(path);
}

void openFile(String path) {
  _platform.openFile(path);
}

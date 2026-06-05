import 'package:jni/jni.dart';
import 'package:jni_flutter/jni_flutter.dart';

import 'jni/android_bindings.dart' as j;
import 'native_storage_utility_platform_interface.dart';

/// The Android implementation of [NativeStorageUtilityPlatform].
class NativeStorageUtilityAndroid extends NativeStorageUtilityPlatform {
  NativeStorageUtilityAndroid()
    : _context = androidApplicationContext.as<j.Context>(j.Context.type);

  late final j.Context _context;

  @override
  int getFreeBytes(String path) {
    final statFs = j.StatFs(path.toJString());
    return statFs.availableBytes;
  }

  @override
  int getTotalBytes(String path) {
    final statFs = j.StatFs(path.toJString());
    return statFs.totalBytes;
  }

  @override
  Future<void> openFile(String path) async {
    final mimeType = getMimeType(path);

    // final uri = j.Uri.parse(Uri.file(path).toString().toJString());
    final uri = j.FileProvider.getUriForFile(
      _context,
      '${_context.packageName}.fileprovider'.toJString(),
      j.File.new$1(path.toJString()),
    );

    final intent = j.Intent.new$3(j.Intent.ACTION_VIEW);

    intent.addCategory(j.Intent.CATEGORY_DEFAULT);
    // Uri uri = FileUtil.getFileUri(context, filePath);
    intent.setDataAndType(uri, mimeType);
    intent.addFlags(
      j.Intent.FLAG_ACTIVITY_NEW_TASK |
          j.Intent.FLAG_GRANT_READ_URI_PERMISSION |
          j.Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
    );

    final resolveInfoList = <j.ResolveInfo>[];

    if (j.Build$VERSION.SDK_INT >= j.Build$VERSION_CODES.TIRAMISU) {
      final result =
          _context.packageManager
              ?.queryIntentActivities(
                intent,
                j.PackageManager$ResolveInfoFlags.of(
                  j.PackageManager.MATCH_DEFAULT_ONLY,
                ),
              )
              ?.asDart() ??
          [];

      resolveInfoList.addAll(result.nonNulls);
    } else {
      final result =
          _context.packageManager
              ?.queryIntentActivities$1(
                intent,
                j.PackageManager.MATCH_DEFAULT_ONLY,
              )
              ?.asDart() ??
          [];

      resolveInfoList.addAll(result.nonNulls);
    }

    for (final resolveInfo in resolveInfoList) {
      final packageName = resolveInfo.activityInfo!.packageName;
      _context.grantUriPermission(
        packageName,
        uri,
        j.Intent.FLAG_GRANT_READ_URI_PERMISSION |
            j.Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
      );
    }

    _context.startActivity(intent);
  }

  bool hasPermission(String permission) {
    final string = permission.toJString();
    return _context.checkSelfPermission(string) ==
        j.PackageManager.PERMISSION_GRANTED;
  }

  JString getMimeType(String path) {
    final mimeTypeMap = j.MimeTypeMap.singleton!;
    final mimeType = mimeTypeMap.getMimeTypeFromExtension(
      path.split('.').last.toJString(),
    );

    if (mimeType == null) {
      throw Exception('Unable to get mime type of file');
    }

    return mimeType;
  }
}

import 'dart:io';

import 'package:args/args.dart';
import 'package:ffigen/ffigen.dart';
import 'package:jnigen/jnigen.dart';

final _darwinConfig = FfiGenerator(
  globals: .includeSet({
    'NSFileAppendOnly',
    'NSFileBusy',
    'NSFileCreationDate',
    'NSFileDeviceIdentifier',
    'NSFileExtensionHidden',
    'NSFileGroupOwnerAccountID',
    'NSFileGroupOwnerAccountName',
    'NSFileHFSCreatorCode',
    'NSFileHFSTypeCode',
    'NSFileImmutable',
    'NSFileModificationDate',
    'NSFileOwnerAccountID',
    'NSFileOwnerAccountName',
    'NSFilePosixPermissions',
    'NSFileProtectionKey',
    'NSFileReferenceCount',
    'NSFileSize',
    'NSFileSystemFileNumber',
    'NSFileSystemFreeNodes',
    'NSFileSystemFreeSize',
    'NSFileSystemNodes',
    'NSFileSystemNumber',
    'NSFileSystemSize',
    'NSFileType',
    'NSURLVolumeTotalCapacityKey',
    'NSURLVolumeAvailableCapacityKey',
    'NSURLVolumeAvailableCapacityForImportantUsageKey',
    'NSURLVolumeAvailableCapacityForOpportunisticUsageKey',
  }),
  headers: Headers(
    entryPoints: [
      .file(
        '$macSdkPath/System/Library/Frameworks/CoreFoundation.framework/Headers/CoreFoundation.h',
      ),
      .file(
        '$macSdkPath/System/Library/Frameworks/Foundation.framework/Headers/Foundation.h',
      ),
      .file(
        '$macSdkPath/System/Library/Frameworks/AppKit.framework/Versions/C/Headers/AppKit.h',
      ),
    ],
  ),
  output: Output(dartFile: Uri.file('lib/src/ffi/foundation_bindings.dart')),
  objectiveC: ObjectiveC(
    interfaces: .includeSet({'NSFileManager', 'NSWorkspace'}),
  ),
  enums: .includeSet({'NSFileAttributeKey', 'NSFileSystemSize'}),
  structs: .includeSet({'NSFileAttributeKey', 'NSFileSystemSize'}),
);

final _linuxConfig = FfiGenerator(
  headers: Headers(
    entryPoints: [.file('/usr/include/x86_64-linux-gnu/sys/statvfs.h')],
  ),
  functions: .includeSet({'statvfs', 'fstatvfs'}),
  structs: .includeSet({'statvfs'}),
  output: Output(dartFile: .file('lib/src/ffi/linux_bindings.dart')),
);

final packageRoot = Platform.script.resolve('../');

final androidConfig = Config(
  outputConfig: OutputConfig(
    dartConfig: DartCodeOutputConfig(
      path: packageRoot.resolve('lib/src/jni/android_bindings.dart'),
      structure: .singleFile,
    ),
  ),
  androidSdkConfig: AndroidSdkConfig(
    addGradleDeps: true,
    androidExample: packageRoot.resolve('example').path,
  ),
  sourcePath: [packageRoot.resolve('android/app/src/main/java')],
  classes: [
    'android.app.Application',
    'android.app.PendingIntent',
    'android.content',
    'android.os',
    'android.net.Uri',
    'android.webkit.MimeTypeMap',
    'androidx.core.content.FileProvider',
    'java.io.File',
  ],
);

void main(List<String> args) {
  final parser = ArgParser()
    ..addOption(
      'platform',
      allowed: ['android', 'ios', 'macos', 'linux'],
      mandatory: true,
    );

  final arguments = parser.parse(args);
  final platform = arguments['platform'];

  if (platform case 'android') {
    generateJniBindings(androidConfig);
  } else if (platform case 'ios' || 'macos' || 'darwin') {
    _darwinConfig.generate();
  } else if (platform case 'linux') {
    _linuxConfig.generate();
  } else {
    throw ArgumentError('Invalid platform: $platform');
  }
}

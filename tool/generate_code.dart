import 'package:args/args.dart';
import 'package:ffigen/ffigen.dart';

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
  headers: Headers(entryPoints: [.file('$macSdkPath/usr/include/_bounds.h')]),
  functions: .includeSet({'statvfs', 'fstatvfs'}),
  structs: .includeSet({'statvfs'}),
  output: Output(dartFile: .file('lib/src/ffi/linux_bindings.dart')),
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
    // generateJniBindings(androidConfig);
  } else if (platform case 'ios' || 'macos' || 'darwin') {
    _darwinConfig.generate();
  } else if (platform case 'linux') {
    _linuxConfig.generate();
  } else {
    throw ArgumentError('Invalid platform: $platform');
  }
}

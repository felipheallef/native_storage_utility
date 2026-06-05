#ifndef FLUTTER_PLUGIN_NATIVE_STORAGE_UTILITY_PLUGIN_H_
#define FLUTTER_PLUGIN_NATIVE_STORAGE_UTILITY_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace native_storage_utility {

class NativeStorageUtilityPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NativeStorageUtilityPlugin();

  virtual ~NativeStorageUtilityPlugin();

  // Disallow copy and assign.
  NativeStorageUtilityPlugin(const NativeStorageUtilityPlugin&) = delete;
  NativeStorageUtilityPlugin& operator=(const NativeStorageUtilityPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace native_storage_utility

#endif  // FLUTTER_PLUGIN_NATIVE_STORAGE_UTILITY_PLUGIN_H_

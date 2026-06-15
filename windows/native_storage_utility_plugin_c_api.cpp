#include "include/native_storage_utility/native_storage_utility_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "native_storage_utility_plugin.h"

void NativeStorageUtilityPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  native_storage_utility::NativeStorageUtilityPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

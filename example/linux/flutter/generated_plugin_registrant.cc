//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <lab_sound_flutter/lab_sound_flutter_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) lab_sound_flutter_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "LabSoundFlutterPlugin");
  lab_sound_flutter_plugin_register_with_registrar(lab_sound_flutter_registrar);
}

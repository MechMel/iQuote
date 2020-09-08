import 'package:axiom_hoist_quote_calculator/M2/M2Setting.dart';
import 'package:axiom_hoist_quote_calculator/models/AHSettings.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHDiskController.dart';

class AHSettingsController {
  static const String SETTING_FILE_EXTENSION = ".dat";

  static void setupSettingsController() {
    loadSaveableSettings();
    for (String settingName in AHSettings.saveableSettings.keys) {
      M2ISetting setting = AHSettings.saveableSettings[settingName];
      setting.onValueChanged.addListener(saveSaveableSettings);
    }
    AHSettings.settingsHaveBeenSetup = true;
  }

  static void loadSaveableSettings() {
    for (String settingName in AHSettings.saveableSettings.keys) {
      M2ISetting setting = AHSettings.saveableSettings[settingName];
      setting.parse(AHDiskController.loadFileAsString(getSettingFileName(settingName)));
    }
  }

  static void saveSaveableSettings() {
    for (String settingName in AHSettings.saveableSettings.keys) {
      M2ISetting setting = AHSettings.saveableSettings[settingName];
      AHDiskController.saveFileAsString(getSettingFileName(settingName), setting.toString());
    }
  }

  static String getSettingFileName(String settingName) {
    return settingName + SETTING_FILE_EXTENSION;
  }
}
import 'package:axiom_hoist_quote_calculator/M2/M2Setting.dart';
//import 'package:axiom_hoist_quote_calculator/controllers/AHEstimationSetting.dart';

class AHSettings {
  static bool settingsHaveBeenSetup = false;
  static Map<String, M2ISetting> saveableSettings = {
    // Company Settings
    "companyName": companyName,
    "companyPhysicalAddressLine1": companyPhysicalAddressLine1,
    "companyPhysicalAddressLine2": companyPhysicalAddressLine2,
    "companyPhoneNumber": companyPhoneNumber,
    "companyEmailAddress": companyEmailAddress,
    // Email Settings
    "emailSubject": emailSubject,
    "emailBody": emailBody,
    // Active File Settings
    //"activeEstimationFileName": activeEstimationFileName,
    //"activeEstimationHasBeenSentThisSession": activeEstimationHasBeenSentThisSession,
    // Export Settings
    //"nextEstimationNumber": nextEstimationNumber,
    "daysTillExpiration": daysTillExpiration,
    //"inspectionExportDescription": inspectionExportDescription,
    "scissorLiftExportDescription": scissorLiftExportDescription,
    "transportationExportDescription": transportationExportDescription,
    "feesExportDescription": feesExportDescription,
    "discountsExportDescription": discountsExportDescription,
  };

  // Company Settings
  static M2Setting<String> companyName = M2Setting(
    defaultValue: "Axiom Hoist",
  );

  static M2Setting<String> companyPhysicalAddressLine1 = M2Setting(
    defaultValue: "42450 NW Palace Dr",
  );

  static M2Setting<String> companyPhysicalAddressLine2 = M2Setting(
    defaultValue: "Banks, OR 97106",
  );

  static M2Setting<String> companyPhoneNumber = M2Setting(
    defaultValue: "503-847-6747",
  );

  static M2Setting<String> companyEmailAddress = M2Setting(
    defaultValue: "",
  );

  // Email Settings
  static M2Setting<String> emailSubject = M2Setting(
    defaultValue: "Inspection quote",
  );

  static M2Setting<String> emailBody = M2Setting(
    defaultValue: "See inspection quote attached.",
  );

  // Active File Settings
  /*static M2Setting<String> activeEstimationFileName = M2Setting(
    defaultValue: null,
  );

  static AHEstimationSetting activeEstimation = AHEstimationSetting(
    defaultValue: null,
  );*/

  /*static M2Setting<bool> activeEstimationHasBeenSentThisSession = M2Setting<bool> (
    defaultValue: false,
  );*/

  // Export Settings
  /*static M2Setting<int> nextEstimationNumber = M2Setting(
    defaultValue: 1000,
  );*/

  static M2Setting<int> daysTillExpiration = M2Setting(
    defaultValue: 14,
  );

  static M2Setting<String> inspectionVariableIdentifier = M2Setting(
    defaultValue: "c",
  );

  /*static M2Setting<String> inspectionExportDescription = M2Setting(
    defaultValue: "Perform annual periodic crane inspection on a {crane} as specified by OSHA and ANSI.",
  );*/

  static M2Setting<String> scissorLiftExportDescription = M2Setting(
    defaultValue: "Manlift supplied by Axiom Hoist.",
  );

  static M2Setting<String> transportationExportDescription = M2Setting(
    defaultValue: "Transportation costs.",
  );

  static M2Setting<String> feesExportDescription = M2Setting(
    defaultValue: "Fees.",
  );

  static M2Setting<String> discountsExportDescription = M2Setting(
    defaultValue: "Discount.",
  );
}

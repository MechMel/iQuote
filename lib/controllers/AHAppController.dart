import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2Events.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2SerializableDate.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2SetupM2.dart';
import 'package:axiom_hoist_quote_calculator/PDF/AHPDFExporter.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHDiskController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHEmailController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHSettingsController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_AutoSavingProperty.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_CraneCategoriesController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_QuoteController.dart';
import 'package:axiom_hoist_quote_calculator/models/AHSettings.dart';
import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/views/AHAppUI.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';

class AHAppController {
  static const String APP_VERSION = "Demo 1.2020.09.00";
  static const String ESTIMATION_FILE_EXTENSION = ".ahec";
  static const String BASE_ESTIMATION_FILE_NAME =
      "Untitled" + ESTIMATION_FILE_EXTENSION;
  //static AQI_QuoteController _activeQuoteFileName;
  static AQI_AutoSavingProperty<String> _lastEditedQuoteFileName;
  static AQI_QuoteController _activeQuoteController;
  static AQI_QuoteController get activeQuoteController {
    return _activeQuoteController;
  }

  //static M2Event onFlutterSetupComplete = M2Event();
  static M2Event onControllersSetupComplete = M2Event();
  static M2Event onEstimationSaveFilesChanged = M2Event();
  static M2Event onActiveEstimationChanged = M2Event();
  static M2Event onSettingsChanged = M2Event();

  static void run() async {
    runApp(M2SetupM2());
    //await Future.delayed(Duration(seconds: 10));
    await _postFlutterControllersSetup();
    runApp(AHAppUI());
  }

  static void _setLastEditedQuoteFileName(String newFileName) {
    _lastEditedQuoteFileName.value = newFileName;
  }

  static Future _postFlutterControllersSetup() async {
    await AHDiskController.setupAHDiskController();
    AHSettingsController.setupSettingsController();
    AQI_CraneCategoriesController.setupCraneCategoriesController();
    AHPDFExporter.setupPDFExporter();
    _lastEditedQuoteFileName = AQI_AutoSavingProperty<String>(
      null,
      "lastEditedQuoteFileName.json",
    );
    _setLastEditedEstimationToActiveEstimation();
    onControllersSetupComplete.trigger();
  }

  static void closeTheKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    //AHAppUI.reloadUI();
  }

  static void _setLastEditedEstimationToActiveEstimation() {
    if (_lastEditedQuoteFileName.value != null) {
      AQI_QuoteController newQuoteController =
          AQI_QuoteController.fromFile(_lastEditedQuoteFileName.value);
      _changeActiveQuoteController(newQuoteController);
    } else {
      setActiveQuoteControllerToNewQuote();
    }
  }

  static void setActiveQuoteControllerToNewQuote() {
    _changeActiveQuoteController(AQI_QuoteController.createNewQuote());
  }

  static void swapToEstimation(String newQuoteFileName) {
    AQI_QuoteController newQuoteController =
        AQI_QuoteController.fromFile(newQuoteFileName);
    _changeActiveQuoteController(newQuoteController);
  }

  static void _changeActiveQuoteController(
      AQI_QuoteController newQuoteController) {
    _activeQuoteController = newQuoteController;
    _activeQuoteController.onAfterQuoteSaved = _setLastEditedQuoteFileName;
    _lastEditedQuoteFileName.value = _activeQuoteController.fileName;
    log("Active quote - ${_activeQuoteController.fileName}");
    onActiveEstimationChanged.trigger();
  }

  static List<String> getSavedQuotesFileNames() {
    return AQI_QuoteController.getSavedEstimationFileNames();
  }

  static void emailActiveQuote() {
    emailQuote(_activeQuoteController);
  }

  static void emailQuote(AQI_QuoteController quote) {
    AHEmailController.emailEstimation(quote);
  }

  static void exportActiveEstimationAsPdf() {
    _activeQuoteController.exportQuoteAsPdf();
  }

  static void deleteEstimationFile(String fileName) {
    // TODO: Hang onto a copy of the file for a couple days before deleteting it permanently
    if (_activeQuoteController.fileName == fileName) {
      setActiveQuoteControllerToNewQuote();
    }
    AHDiskController.deleteSavedFile(fileName);
    onEstimationSaveFilesChanged.trigger();
  }

  static mailCraneCategoriesToTKE() {
    M2SerializableDate todaysDate =
        M2SerializableDate.fromDateTime(DateTime.now());

    // Generate the file name
    String fileFormattedDate =
        M2SerializableDate.getFormattedDate(todaysDate, delimiter: "_");
    String fileFormattedCompanyName =
        AHSettings.companyName.value.toLowerCase().replaceAll(" ", "_");
    String fileName =
        "${fileFormattedCompanyName}_crane_categories_$fileFormattedDate.json";

    // Export the crane categories
    String craneCategoriesDataAsText = AHDiskController.loadFileAsString(
        AQI_CraneCategoriesController.CRANE_CATEGORIES_FILE_NAME);
    String exportedFilePath = AHDiskController.exportFileAsString(
        fileName, craneCategoriesDataAsText);

    // Email the crane categories
    String todaysDateEmailFormatted =
        M2SerializableDate.getFormattedDate(todaysDate);
    String emailSubject =
        "${AHSettings.companyName.value} - Inpsection Quote Creator Crane Categories Export - $todaysDateEmailFormatted";
    String emailBody =
        "Attached is the crane categories file from ${AHSettings.companyName.value}.";
    AHEmailController.sendEmail(MailOptions(
      subject: emailSubject,
      body: emailBody,
      recipients: ["info@turnkeyecosystems.com"],
      attachments: [
        exportedFilePath,
      ],
    ));
  }

  static Future<void> exportAllSavedFiles() async {
    Directory saveDirectory = await getApplicationDocumentsDirectory();
    Directory exportDirectory;
    if (Platform.isIOS) {
      exportDirectory = saveDirectory;
    } else {
      exportDirectory = await getExternalStorageDirectory();
    }
    String exportFilePath =
        exportDirectory.path + "/" + 'axiom_inspector_all_files.zip';
    if (File(exportFilePath).existsSync()) {
      File(exportFilePath).deleteSync();
    }
    var encoder = ZipFileEncoder();
    encoder.create(exportFilePath);
    encoder.addDirectory(saveDirectory);
    encoder.close();

    final MailOptions mailOptions = MailOptions(
      body:
          "Something may have gone wrong. Exported all files from Axiom Q Inspector.",
      subject: "Axiom Q Inspector emergency saved files export!",
      recipients: ["MelchiahMauck@gmail.com"],
      isHTML: false,
      attachments: [
        exportFilePath,
      ],
    );

    FlutterMailer.send(mailOptions).catchError((e) {
      log(e.toString());
      FlutterShare.shareFile(
        title: mailOptions.subject,
        text: mailOptions.body,
        filePath: mailOptions.attachments[0],
      ).catchError((e) {
        log(e.toString());
      });
    });
  }
}

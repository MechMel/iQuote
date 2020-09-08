import 'dart:convert';
import 'dart:developer';
import 'package:axiom_hoist_quote_calculator/M2/M2ObjectWrapperForControllers.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2QuantityAtRateWrapperForControllers.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2SerializableDate.dart';
import 'package:axiom_hoist_quote_calculator/PDF/AHPDFExporter.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHDiskController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_AutoSavingProperty.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_CraneCategoriesController.dart';
import 'package:axiom_hoist_quote_calculator/models/AHTask.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_Quote.dart';

class AQI_QuoteController {
  static const String ESTIMATION_FILE_EXTENSION = ".ahec";
  static const String UNTITLED_ESTIMATION_NAME = "Untitled";
  static const int DEFAULT_FIRST_QUOTE_NUMBER = 1000;
  static const String _NEXT_QUOTE_NUMBER_FILE_NAME = "nextQuoteNumber.json";
  static AQI_AutoSavingProperty<int> _nextQuoteNumber = AQI_AutoSavingProperty(
    DEFAULT_FIRST_QUOTE_NUMBER,
    "nextQuoteNumber.json",
  );
  static M2ObjectWrapperForControllers<int> nextQuoteNumber = M2ObjectWrapperForControllers(
    getSourceValue: () { return _nextQuoteNumber.value; },
    setSourceValue: (newValue) { _nextQuoteNumber.value = newValue; },
    getSourceDefaultValue: () { return DEFAULT_FIRST_QUOTE_NUMBER; },
  );
  
  final AQI_Quote _quote;
  String _quoteFileName;
  String get fileName {
    return _quoteFileName;
  }
  void Function(String) onAfterQuoteSaved;

  // Wrappers
  // Quote Numbers
  set periodicQuoteNumber(int value) {
    _quote.periodicQuoteNumber.value = value;
    _saveQuote();
  }
  set frequentQuoteNumber(int value) {
    _quote.frequentQuoteNumber.value = value;
    _saveQuote();
  }
  Map<InspectionFrequency, int> get quoteNumber {
    return {
      InspectionFrequency.PERIODIC: _quote.periodicQuoteNumber.value,
      InspectionFrequency.FREQUENT: _quote.frequentQuoteNumber.value,
    };
  }
  M2ObjectWrapperForControllers<M2SerializableDate> creationDate;
  M2ObjectWrapperForControllers frequency;
  M2ObjectWrapperForControllers<String> companyName;
  M2ObjectWrapperForControllers<String> contactName;
  M2ObjectWrapperForControllers<String> contactEmailAddress;
  M2ObjectWrapperForControllers<String> companyAddressLine1;
  M2ObjectWrapperForControllers<String> companyAddressLine2;
  M2ObjectWrapperForControllers<double> hourlyRate;
  M2QuantityAtRateWrapperForControllers<double, double> transportaion;
  M2QuantityAtRateWrapperForControllers<int, double> _periodicManLifts;
  M2QuantityAtRateWrapperForControllers<int, double> _frequentManLifts;
  M2QuantityAtRateWrapperForControllers<int, double> get manLifts {
    if (frequency.value == InspectionFrequency.PERIODIC) {
      return _periodicManLifts;
    } else if (frequency.value == InspectionFrequency.FREQUENT) {
      return _frequentManLifts;
    } else {
      throw("AQI_QuoteController.manLifts does not handle ${frequency.value.toString()}!");
    }
  }
  M2ObjectWrapperForControllers<double> fees;
  M2ObjectWrapperForControllers<double> discounts;
  M2ObjectWrapperForControllers<bool> shouldShowTaskBreakDownInExport;

  // Calculators
  double get totalCost {
    return _quote.totalCost;
  }
  double get totalLaborCost {
    return _quote.totalLaborCost;
  }
  double get totalManHours {
    return _quote.totalManHours;
  }
  double get totalScissorLiftCost {
    return _quote.totalManLiftCost;
  }
  double get totalTransportationCost {
    return _quote.totalTransportationCost;
  }

  // Cosntructors
  void _initializeProperties() {
    frequency = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.frequency,
      onAfterSet: _saveQuote,
    );
    creationDate = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.creationDate,
      onAfterSet: _saveQuote,
    );
    companyName = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.companyName,
      onAfterSet: _saveQuote,
    );
    contactName = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.contactName,
      onAfterSet: _saveQuote,
    );
    contactEmailAddress = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.contactEmailAddress,
      onAfterSet: _saveQuote,
    );
    companyAddressLine1 = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.companyAddressLine1,
      onAfterSet: _saveQuote,
    );
    companyAddressLine2 = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.companyAddressLine2,
      onAfterSet: _saveQuote,
    );
    _periodicManLifts = M2QuantityAtRateWrapperForControllers.fromQuantityAtRate(
      source: _quote.periodicManLifts,
      onAfterSetQuantity: _saveQuote,
      onAfterSetRate: _saveQuote,
    );
    _frequentManLifts = M2QuantityAtRateWrapperForControllers.fromQuantityAtRate(
      source: _quote.frequentManLifts,
      onAfterSetQuantity: _saveQuote,
      onAfterSetRate: _saveQuote,
    );
    transportaion = M2QuantityAtRateWrapperForControllers.fromQuantityAtRate(
      source: _quote.transportation,
      onAfterSetQuantity: _saveQuote,
      onAfterSetRate: _saveQuote,
    );
    hourlyRate = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.hourlyRate,
      onAfterSet: _saveQuote,
    );
    fees = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.fees,
      onAfterSet: _saveQuote,
    );
    discounts = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.discounts,
      onAfterSet: _saveQuote,
    );
    shouldShowTaskBreakDownInExport = M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _quote.shouldShowTaskBreakDownInExport,
      onAfterSet: _saveQuote,
    );
  }

  AQI_QuoteController(this._quote, {this.onAfterQuoteSaved}) {
    _quoteFileName = null;

    _initializeProperties();

    _saveQuote();
  }

  AQI_QuoteController.fromFile(this._quoteFileName, {this.onAfterQuoteSaved}) : _quote = _loadQuote(_quoteFileName) {
    _initializeProperties();
  }

  // Getters
  List<AHTask> getTasks() {
    List<AHTask> tasks = List();
    List<int> activeCraneCategoriesIDs = AQI_CraneCategoriesController.getActiveOrLegacyCraneCategoriesIDs(true);

    // Remove any unused legacy tasks from this quote
    List<int> unusedLegacyTasksIDs = List();
    for (int taskID in _quote.tasksByID.keys) {
      if (!activeCraneCategoriesIDs.contains(taskID) && !_quote.tasksByID[taskID].doesTaskActuallyHaveReleventChanges()) {
        unusedLegacyTasksIDs.add(taskID);
      }
    }
    for (int unusedLegacyTaskID in unusedLegacyTasksIDs) {
      _quote.tasksByID.remove(unusedLegacyTaskID);
    }

    // Add any missing active tasks to this quote
    for (int craneCategoryID in activeCraneCategoriesIDs) {
      if (!_quote.tasksByID.containsKey(craneCategoryID)) {
        _quote.tasksByID[craneCategoryID] = AHTask(craneCategoryID);
      }
    }

    // Add any legacy tasks to the return list
    for (int taskID in _quote.tasksByID.keys) {
      if (!activeCraneCategoriesIDs.contains(taskID)) {
        AHTask legacyTask = _quote.tasksByID[taskID];

        if (legacyTask.doesTaskActuallyHaveReleventChanges()) {
          tasks.add(legacyTask);
        } else {
          _quote.tasksByID.remove(taskID);
        }
      }
    }

    // Add all active tasks to the return list
    for (int taskID in activeCraneCategoriesIDs) {
      tasks.add(_quote.tasksByID[taskID]);
    }

    return tasks;
  }
  
  String exportQuoteAsPdf() {
    return AHPDFExporter.exportEstimationAsPDF(this);
  }

  void _saveQuote() {
    // Update the file name
    if (_quoteFileName != _generateEstimationSaveFileName(_quote)) {
      if (_quoteFileName != null) {
        AHDiskController.deleteSavedFile(_quoteFileName);
      }
      _quoteFileName = _generateEstimationSaveFileName(_quote);
    }

    // Encode the quote
    String encodedJson = jsonEncode(_quote);

    // Save the quote
    AHDiskController.saveFileAsString(_quoteFileName, encodedJson);
    if (onAfterQuoteSaved != null) {
      onAfterQuoteSaved(_quoteFileName);
    }
    AHAppController.onEstimationSaveFilesChanged.trigger();
  }

  static AQI_QuoteController createNewQuote() {
    AQI_Quote newQutoe = AQI_Quote(_nextQuoteNumber.value, _nextQuoteNumber.value + 1);
    _nextQuoteNumber.value += 2;
    return AQI_QuoteController(newQutoe);
  }

  static AQI_Quote _loadQuote(String fileName) {
    String encodedJson = AHDiskController.loadFileAsString(fileName);
    Map<String, dynamic> decodedJson = jsonDecode(encodedJson);
    return AQI_Quote.fromDecodedJson(decodedJson);
  }
  
  static String _generateEstimationSaveFileName(AQI_Quote quote) {
    String quoteFileName = "";
    String elementDelimiter = "_";

    if (quote.companyName.value != null && quote.companyName.value != "") {
      String abbreviatedCompanyName = quote.companyName.value;
      if (abbreviatedCompanyName.length > 6) {
        abbreviatedCompanyName = abbreviatedCompanyName.substring(0, 6).trim().replaceAll(" ", elementDelimiter);
      }
      quoteFileName += abbreviatedCompanyName;
    } else {
      quoteFileName += UNTITLED_ESTIMATION_NAME;
    }

    quoteFileName += elementDelimiter + quote.periodicQuoteNumber.value.toString();
    quoteFileName += ESTIMATION_FILE_EXTENSION;

    return quoteFileName;
  }

  static List<String> getSavedEstimationFileNames() {
    List<String> fileNames = AHDiskController.getSavedFileNamesFromFileExtension(ESTIMATION_FILE_EXTENSION);
    fileNames.sort((a, b) { return (_getInvoiceNumberFromFileName(a) > _getInvoiceNumberFromFileName(b)) ? -1: 1; });
    return fileNames;
  }

  static int _getInvoiceNumberFromFileName(String fileName) {
    fileName = fileName.substring(0, fileName.length - ESTIMATION_FILE_EXTENSION.length);
    int quoteNumber = 0;
    try {
      quoteNumber = int.parse(fileName.substring(fileName.length - 4));
    } catch (e) {
      log(fileName + " - " + e.toString());
    }
    return quoteNumber;
  }
}
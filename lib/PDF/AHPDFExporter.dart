import 'dart:developer';
import 'dart:typed_data';
import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2SerializableDate.dart';
import 'package:axiom_hoist_quote_calculator/PDF/AHStylePDF.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_QuoteController.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_Quote.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:image/image.dart' as ImageUtils;
import 'package:axiom_hoist_quote_calculator/models/AHTask.dart';
import 'package:axiom_hoist_quote_calculator/models/AHSettings.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHDiskController.dart';
import 'package:axiom_hoist_quote_calculator/PDF/AHCustomPDFWidgets.dart';

class AHPDFExporter {
  static const String COMPLETE_DOT_ROW = "..........................................................................................................................................................................................................................";
  static ImageUtils.Image _decodedLogo;
  
  static void setupPDFExporter() async {
    // TODO: Define the file path somewhere else
    ByteData rawLogoBytes = await rootBundle.load('assets/AxiomHoistProfileSmall.jpg');
    _decodedLogo = ImageUtils.decodeJpg(rawLogoBytes.buffer.asUint8List());
  }

  static String exportEstimationAsPDF(AQI_QuoteController estimationToExport) {
    Document pdf = Document();

    String axiomHoistAddressText = AHSettings.companyPhysicalAddressLine1.value + "\n"
      + AHSettings.companyPhysicalAddressLine2.value + "\n"
      + AHSettings.companyPhoneNumber.value + "\n"
      + AHSettings.companyEmailAddress.value + "\n";
    String customerAddressText = "${estimationToExport.companyName.value}\n${estimationToExport.companyAddressLine1.value}\n${estimationToExport.companyAddressLine2.value}\n";
    String formattedCurrentDate = M2SerializableDate.getFormattedDate(M2SerializableDate.fromDateTime(DateTime.now())).toString();
    DateTime expirationDate = DateTime.now().add(Duration(days:AHSettings.daysTillExpiration.value));
    String formattedExpirationDate = M2SerializableDate.getFormattedDate(M2SerializableDate.fromDateTime(expirationDate)).toString();
    
    PdfImage logoPdfImage = PdfImage(
      pdf.document,
      image: _decodedLogo.data.buffer.asUint8List(),
      width: _decodedLogo.width,
      height: _decodedLogo.height,
    );
  
    pdf.addPage(
      MultiPage(
        pageFormat: AHStylePDF.PAGE_FORMAT,
        margin: EdgeInsets.only(left: AHStylePDF.MARGIN_SIZE, top: AHStylePDF.MARGIN_SIZE, right: AHStylePDF.MARGIN_SIZE, bottom: AHStylePDF.MARGIN_SIZE),
        footer: (Context context) {
          return Center(child: AHBodyTextNormal("Thank you for your business!", textAlign: TextAlign.center));
        },
        build: (Context context) => [
          Container(
            child: Row(
              children: [
                Container(
                  width: 0.37 * AHStylePDF.internalPageWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AHBodyTextBold(AHSettings.companyName.value + "\n", textAlign: TextAlign.left),
                          AHBodyTextNormal(axiomHoistAddressText, textAlign: TextAlign.left),
                          Container(height: 13),
                          AHTitleText("Quote", textAlign: TextAlign.left),
                          Container(height: 13),
                        ],
                      ),
                      Container(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              width: 100,
                              child: Column(
                                children: [
                                  AHBodyTextBold("ADDRESS\n", textAlign: TextAlign.left),
                                  AHBodyTextNormal(customerAddressText, textAlign: TextAlign.left),
                                ],
                              ),
                            ),
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
                Container(
                  width: .26 * AHStylePDF.internalPageWidth,
                ),
                Container(
                  width: 0.37 * AHStylePDF.internalPageWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        // TODO: Make these sizes based off of the document's width. Have some place up above where the constants can all be set.
                        height: 85,
                        width: 85,
                        alignment: Alignment.topRight,
                        child: Row(children: [Image(logoPdfImage, fit: BoxFit.scaleDown,),]),
                      ),
                      Container(
                        height: 8,
                      ),
                      Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 84,
                                width: 100,
                                child: Column(
                                  children: [
                                    AHBodyTextBold("QUOTE # \n", textAlign: TextAlign.right),
                                    AHBodyTextBold("DATE \n ", textAlign: TextAlign.right),
                                    AHBodyTextBold("EXPIRATION \n", textAlign: TextAlign.right),
                                  ],
                                ),
                              ),
                              Container(
                                height: 84,
                                width: 100,
                                child: Column(
                                  children: [
                                    AHBodyTextNormal(" ${estimationToExport.quoteNumber[estimationToExport.frequency.value]}\n", textAlign: TextAlign.left),
                                    AHBodyTextNormal(" $formattedCurrentDate\n", textAlign: TextAlign.left),
                                    AHBodyTextNormal(" $formattedExpirationDate\n", textAlign: TextAlign.left),
                                  ],
                                ),
                              ),
                            ]
                          ),
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 24,
          ),
          Container(
            width:AHStylePDF.totalPageWidth,
            child: Column(    
              children: [
                AHBodyTextNormal("PLEASE DETACH TOP PORTION AND RETURN WITH YOUR PAYMENT.", textAlign: TextAlign.center),
                AHBodyTextNormal(COMPLETE_DOT_ROW, textAlign: TextAlign.center),
              ],
            ),
          ),
          Container(
            height: 8,
          ),
          Row(
            children: [
              Container(
                // TODO: Make these widths based off of the document's width. Have some place up above where the constants can all be set.
                width: AHStylePDF.internalPageWidth / 2.0,
                height: 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AHBodyTextBold("DEPARTMENT", textAlign: TextAlign.left),
                    AHBodyTextNormal(estimationToExport.contactName.value, textAlign: TextAlign.left),
                  ],
                ),
              ),
              Container(
                width: AHStylePDF.internalPageWidth / 2.0,
                height: 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AHBodyTextBold("INVOICE DESCRIPTION", textAlign: TextAlign.left),
                    AHBodyTextNormal("Perform ${getTextForCraneFrequency(estimationToExport.frequency.value)} inspection.", textAlign: TextAlign.left),
                  ],
                ),
              ),
            ],
          ),
          getExportableTasksArea(estimationToExport),
          Container(
            width: AHStylePDF.totalPageWidth,
            child: AHBodyTextNormal(COMPLETE_DOT_ROW, textAlign: TextAlign.center),
          ),
          Container(
            width: 3 * AHStylePDF.LINE_SPACING_BODY,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 0.6 * AHStylePDF.internalPageWidth,
                child: AHBodyTextNormal("TOTAL\n", textAlign: TextAlign.right),
              ),
              Container(
                width: 0.4 * AHStylePDF.internalPageWidth,
                child: AHBodyTextBold("\$" + M2FlutterUtilities.getPrintableNum(estimationToExport.totalCost, 2) + "\n", textAlign: TextAlign.right),
              ),
            ],
          ),
          Container(
            height: 50,
          ),
          Row(
            children: [
              Container(
                // TODO: Make these widths based off of the document's width. Have some place up above where the constants can all be set.
                width: AHStylePDF.internalPageWidth / 2.0,
                child: AHBodyTextNormal("Accepted By", textAlign: TextAlign.left),
              ),
              Container(
                width: AHStylePDF.internalPageWidth / 2.0,
                child: AHBodyTextNormal("Accepted Date", textAlign: TextAlign.left),
              ),
            ],
          ),
        ],
      ),
    );

    return AHDiskController.exportFileAsBytes(getEstimationExportName(estimationToExport), Uint8List.fromList(pdf.save()));
  }

  static Widget getExportableTasksArea(AQI_QuoteController quoteController) {
    if(quoteController.shouldShowTaskBreakDownInExport.value) {
      return getBrokenDownTaskArea(quoteController);
    } else {
      return getCollapsedTaskArea(quoteController);
    }
  }

  static Widget getCollapsedTaskArea(AQI_QuoteController quoteController) {
    List<Widget> children = List();
    final double taskDescriptionWidthFactor = 0.85;
    final double amountAreaWidthFactor = 1 - taskDescriptionWidthFactor;

    children.add(
      Container(
        height: 15,
        child: Stack(
          children: [
            Container(
              height: 15,
              // TODO: Get this box to span the whole page,
              width: AHStylePDF.totalPageWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AHStylePDF.COLOR_ACCENT),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // For whatever reason the other labels won't center themselves horizontally unless something like "\nx" comes first
                Container(
                  width: 0 * AHStylePDF.internalPageWidth,
                  child: AHBodyTextNormal("\n.", textAlign: TextAlign.left, color: AHStylePDF.COLOR_ACCENT),
                ),
                Container(
                  width: taskDescriptionWidthFactor * AHStylePDF.internalPageWidth,
                  child: AHBodyTextNormal("ACTIVITY\n", textAlign: TextAlign.left, color: AHStylePDF.COLOR_PRIMARY),
                ),
                Container(
                  width: amountAreaWidthFactor * AHStylePDF.internalPageWidth,
                  child: AHBodyTextNormal("AMOUNT\n", textAlign: TextAlign.right, color: AHStylePDF.COLOR_PRIMARY),
                ),
              ],
            ),
          ],
        ),
      )
    );
    
    children.add(Container(height: 2 * AHStylePDF.LINE_SPACING_BODY));
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: taskDescriptionWidthFactor * AHStylePDF.internalPageWidth,
          child: AHBodyTextNormal(getConsolidatedTasksDescription(quoteController), textAlign: TextAlign.left),
        ),
        Container(
          width: amountAreaWidthFactor * AHStylePDF.internalPageWidth,
          child: AHBodyTextNormal("\$" + M2FlutterUtilities.getPrintableNum(quoteController.totalCost, 2) + '\n', textAlign: TextAlign.right),
        ),
      ],
    ));

    return Column(children: children);
  }

  static String getConsolidatedTasksDescription(AQI_QuoteController quoteController) {
    // Declare local variables
    String description = "";
    String craneWord = "crane";
    String manLiftWord = "Manlift";
    int totalTaskQuantity;

    // Set local variables to their proper values
    totalTaskQuantity = 0;
    for (AHTask task in quoteController.getTasks()) {
      totalTaskQuantity += task.quantity;
    }
    if (totalTaskQuantity > 1) {
      craneWord += "s";
    }
    if (quoteController.manLifts.quantity > 1) {
      manLiftWord += "s";
    }

    // Construct the description
    if (totalTaskQuantity > 0) {
      description += "Perform ${getTextForCraneFrequency(quoteController.frequency.value)} crane inspection on ${M2FlutterUtilities.getPrintableNum(totalTaskQuantity, 0)} $craneWord as specified by OSHA and ANSI.";
    }
    if (quoteController.manLifts.quantity > 0) {
      description += " $manLiftWord will be supplied by ${AHSettings.companyName.value}.";
    }

    return description;
  }

  static Widget getBrokenDownTaskArea(AQI_QuoteController quoteController) {
    List<Widget> children = List();
    final double taskDescriptionWidthFactor = 0.58;
    final double numericFieldsWidthFactor = (1 - taskDescriptionWidthFactor) / 3.0;

    children.add(
      Container(
        height: 15,
        child: Stack(
          children: [
            Container(
              height: 15,
              // TODO: Get this box to span the whole page,
              width: AHStylePDF.totalPageWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AHStylePDF.COLOR_ACCENT),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // For whatever reason the other labels won't center themselves horizontally unless something like "\nx" comes first
                Container(
                  width: 0 * AHStylePDF.internalPageWidth,
                  child: AHBodyTextNormal("\n.", textAlign: TextAlign.left, color: AHStylePDF.COLOR_ACCENT),
                ),
                Container(
                  width: taskDescriptionWidthFactor * AHStylePDF.internalPageWidth,
                  child: AHBodyTextNormal("ACTIVITY\n", textAlign: TextAlign.left, color: AHStylePDF.COLOR_PRIMARY),
                ),
                Container(
                  width: numericFieldsWidthFactor * AHStylePDF.internalPageWidth,
                  child: AHBodyTextNormal("QTY\n", textAlign: TextAlign.right, color: AHStylePDF.COLOR_PRIMARY),
                ),
                Container(
                  width: numericFieldsWidthFactor * AHStylePDF.internalPageWidth,
                  child: AHBodyTextNormal("RATE\n", textAlign: TextAlign.right, color: AHStylePDF.COLOR_PRIMARY),
                ),
                Container(
                  width: numericFieldsWidthFactor * AHStylePDF.internalPageWidth,
                  child: AHBodyTextNormal("AMOUNT\n", textAlign: TextAlign.right, color: AHStylePDF.COLOR_PRIMARY),
                ),
              ],
            ),
          ],
        ),
      )
    );
    
    children.add(Container(height: 2 * AHStylePDF.LINE_SPACING_BODY));
    // Tasks
    for (AHTask task in quoteController.getTasks()) {
      if (task.quantity > 0) {
        children.add(getExportableTask(quoteController.frequency.value, task, quoteController.hourlyRate.value, taskDescriptionWidthFactor: taskDescriptionWidthFactor, numericFieldsWidthFactor: numericFieldsWidthFactor));
        children.add(Container(height: 2 * AHStylePDF.LINE_SPACING_BODY));
      }
    }

    // Scissor Lifts
    if (quoteController.manLifts.quantity > 0) {
      children.add(getExportableQuantityAtRate(
        "",
        AHSettings.scissorLiftExportDescription.value,
        "",
        quoteController.manLifts.quantity,
        quoteController.manLifts.rate,
        taskDescriptionWidthFactor: taskDescriptionWidthFactor,
        numericFieldsWidthFactor: numericFieldsWidthFactor
      ));
      children.add(Container(height: 2 * AHStylePDF.LINE_SPACING_BODY));
    }

    // Transportation
    if (quoteController.transportaion.quantity > 0) {
      children.add(getExportableQuantityAtRate(
        "",
        AHSettings.transportationExportDescription.value,
        "",
        quoteController.transportaion.quantity,
        quoteController.transportaion.rate,
        taskDescriptionWidthFactor: taskDescriptionWidthFactor,
        numericFieldsWidthFactor: numericFieldsWidthFactor
      ));
      children.add(Container(height: 2 * AHStylePDF.LINE_SPACING_BODY));
    }

    // Fees
    if (quoteController.fees.value > 0) {
      children.add(getExportableQuantityAtRate(
        "",
        AHSettings.feesExportDescription.value,
        "",
        1,
        quoteController.fees.value,
        taskDescriptionWidthFactor: taskDescriptionWidthFactor,
        numericFieldsWidthFactor: numericFieldsWidthFactor
      ));
      children.add(Container(height: 2 * AHStylePDF.LINE_SPACING_BODY));
    }

    // Discounts
    if (quoteController.discounts.value > 0) {
      children.add(getExportableQuantityAtRate(
        "",
        AHSettings.discountsExportDescription.value,
        "",
        1,
        quoteController.discounts.value,
        taskDescriptionWidthFactor: taskDescriptionWidthFactor,
        numericFieldsWidthFactor: numericFieldsWidthFactor
      ));
      children.add(Container(height: 2 * AHStylePDF.LINE_SPACING_BODY));
    }

    return Column(children: children);
  }

  static Widget getExportableTask(InspectionFrequency frequency, AHTask task, double hourlyRate, {double taskDescriptionWidthFactor = 0.58, double numericFieldsWidthFactor = 0.14}) {
    return getExportableQuantityAtRate(
      task.taskName,
      "Perform ${getTextForCraneFrequency(frequency)} crane inspection on {crane} as specified by OSHA and ANSI.",
      AHSettings.inspectionVariableIdentifier.value,
      task.quantity,
      hourlyRate * task.getPerUnitManHours(frequency),
      taskDescriptionWidthFactor: taskDescriptionWidthFactor,
      numericFieldsWidthFactor: numericFieldsWidthFactor
    );
  }

  static Widget getExportableQuantityAtRate(String activityName, String activityDescription, String activityNameDelimiter, num quantity, double rate, {double taskDescriptionWidthFactor = 0.58, double numericFieldsWidthFactor = 0.14}) {
    String description = insertVariableValueIntoText(activityDescription, activityNameDelimiter, activityName);
    double totalTaskCost = quantity * rate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: taskDescriptionWidthFactor * AHStylePDF.internalPageWidth,
          child: AHBodyTextNormal(description, textAlign: TextAlign.left),
        ),
        Container(
          width: numericFieldsWidthFactor * AHStylePDF.internalPageWidth,
          child: AHBodyTextNormal(quantity.toString() + '\n', textAlign: TextAlign.right),
        ),
        Container(
          width: numericFieldsWidthFactor * AHStylePDF.internalPageWidth,
          child: AHBodyTextNormal("\$" + M2FlutterUtilities.getPrintableNum(rate, 2) + '\n', textAlign: TextAlign.right),
        ),
        Container(
          width: numericFieldsWidthFactor * AHStylePDF.internalPageWidth,
          child: AHBodyTextNormal("\$" + M2FlutterUtilities.getPrintableNum(totalTaskCost, 2) + '\n', textAlign: TextAlign.right),
        ),
      ],
    );
  }

  static String getTextForCraneFrequency(InspectionFrequency frequency) {
    String textForInspectionFrequency;
    if (frequency == InspectionFrequency.PERIODIC) {
      textForInspectionFrequency = "Periodic";
    } else if (frequency == InspectionFrequency.FREQUENT) {
      textForInspectionFrequency = "Monthly Frequent";
    }
    return textForInspectionFrequency;
  }

  static String insertVariableValueIntoText(String text, String identifier, String variableValue) {
    RegExp variablePattern = RegExp(r"{" + identifier + r"[^}]*}", caseSensitive: false);
    return text.replaceAll(variablePattern, variableValue);
  }
  
  static String getEstimationExportName(AQI_QuoteController quoteController) {
    String estiamtionExportName;
    String elementDelimiter = "_";

    estiamtionExportName = "Estimate" + elementDelimiter + quoteController.quoteNumber[quoteController.frequency.value].toString();
    estiamtionExportName += elementDelimiter + "from" + elementDelimiter;
    estiamtionExportName += AHSettings.companyName.value.replaceAll(" ", elementDelimiter);
    estiamtionExportName += ".pdf";
    
    return estiamtionExportName;
  }
}
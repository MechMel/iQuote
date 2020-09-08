import 'dart:async';

import 'package:axiom_hoist_quote_calculator/UI/custom_widgets/M2UIBuilders.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_QuoteController.dart';
import 'package:axiom_hoist_quote_calculator/models/AHSettings.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_EditDefaultsPage.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_EmergencyExportAllDialog.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_InputFields.dart';
import 'package:flutter/material.dart';

class AQI_SettingsPageUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: AHBodyText(
            "App Version: ${AHAppController.APP_VERSION}",
            textAlign: TextAlign.center,
            color: AHStyle.COLOR_HINT,
          ),
        ),
        _buildCompanySettingsArea(context),
        _buildQuoteSettingsArea(context),
        _buildEmailSettingsArea(context),
        _buildExportSettingsArea(context),
        Container(
          height: 0.25 * AHStyle.lineHeight,
        ),
        Container(
          height: 1.25 * AHStyle.lineHeight,
          child: FlatButton(
            color: AHStyle.COLOR_ERROR,
            onPressed: () {
              showDialog(
                context: context,
                child: AQI_EmergencyExportAllDialog(),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                AHAppController.exportAllSavedFiles().then((value) {
                  Navigator.of(context).pop();
                });
              });
            },
            child: AHBodyText(
              "Emergency Export All Files",
              color: AHStyle.COLOR_BACKGROUND,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanySettingsArea(BuildContext context) {
    return M2UIBuilders.buildDisplayArea(
      title: "${AHSettings.companyName.value} Settings",
      children: [
        Container(
          alignment: Alignment.center,
          height: 1.75 * AHStyle.lineHeight,
          child: AHTextField(
            getValue: () {
              return AHSettings.companyName.value;
            },
            setValue: (value) {
              AHSettings.companyName.value = value;
            },
            labelText: "Company Name",
            hintText: "Company Name",
            icon: Icon(Icons.business),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 1.75 * AHStyle.lineHeight,
          child: AHTextField(
            getValue: () {
              return AHSettings.companyPhysicalAddressLine1.value;
            },
            setValue: (value) {
              AHSettings.companyPhysicalAddressLine1.value = value;
            },
            labelText: "Company Address Line 1",
            hintText: "Company Address Line 1",
            icon: Icon(Icons.place),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 1.75 * AHStyle.lineHeight,
          child: AHTextField(
            getValue: () {
              return AHSettings.companyPhysicalAddressLine2.value;
            },
            setValue: (value) {
              AHSettings.companyPhysicalAddressLine2.value = value;
            },
            labelText: "Company Address Line 2",
            hintText: "Company Address Line 2",
            icon: Icon(Icons.place),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 1.75 * AHStyle.lineHeight,
          child: AHTextField(
            getValue: () {
              return AHSettings.companyPhoneNumber.value;
            },
            setValue: (value) {
              AHSettings.companyPhoneNumber.value = value;
            },
            labelText: "Company Phone Number",
            hintText: "Company Phone Number",
            icon: Icon(Icons.phone),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 1.75 * AHStyle.lineHeight,
          child: AHTextField(
            getValue: () {
              return AHSettings.companyEmailAddress.value;
            },
            setValue: (value) {
              AHSettings.companyEmailAddress.value = value;
            },
            labelText: "Company Email Address",
            hintText: "Company Email Address",
            icon: Icon(Icons.email),
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteSettingsArea(BuildContext context) {
    return M2UIBuilders.buildDisplayArea(
      title: "Quote Settings",
      children: [
        // Next Quote Number
        Container(
          height: 1.25 * AHStyle.lineHeight,
          width: AHStyle.internalPageWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AHBodyText(
                "Next Quote # =",
                textAlign: TextAlign.right,
              ),
              Container(
                height: 0.75 * AHStyle.lineHeight,
                width: 0.17 * AHStyle.internalPageWidth,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: AHStyle.pageMargins * 0.35,
                ),
                child: AHNumericField.fromIntWrapper(
                  source: AQI_QuoteController.nextQuoteNumber,
                ),
              ),
            ],
          ),
        ),

        //
        Container(
          height: 1.25 * AHStyle.lineHeight,
          child: FlatButton(
            color: AHStyle.COLOR_PRIMARY,
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new AQI_EditDefaultsPage()),
              );
            },
            child: AHBodyText(
              "Edit Crane Categorys and Defaults",
              color: AHStyle.COLOR_BACKGROUND,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailSettingsArea(BuildContext context) {
    return M2UIBuilders.buildDisplayArea(
      title: "Email Settings",
      children: [
        Container(
          alignment: Alignment.center,
          height: 1.75 * AHStyle.lineHeight,
          child: AHTextField(
            getValue: () {
              return AHSettings.emailSubject.value;
            },
            setValue: (value) {
              AHSettings.emailSubject.value = value;
            },
            labelText: "Email Subject",
            hintText: "Email Subject",
            icon: Icon(Icons.label_outline),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 2.5 * AHStyle.lineHeight,
          child: AHTextField(
            getValue: () {
              return AHSettings.emailBody.value;
            },
            setValue: (value) {
              AHSettings.emailBody.value = value;
            },
            labelText: "Email Body",
            hintText: "Email Body",
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            icon: Icon(Icons.format_line_spacing),
          ),
        ),
      ],
    );
  }

  Widget _buildExportSettingsArea(BuildContext context) {
    return M2UIBuilders.buildDisplayArea(
      title: "Export Settings",
      children: [
        // Days till expiration
        Container(
          height: 1.25 * AHStyle.lineHeight,
          width: AHStyle.internalPageWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AHBodyText("Quote duration = "),
              Container(
                height: 0.8 * AHStyle.lineHeight,
                width: 0.125 * AHStyle.internalPageWidth,
                alignment: Alignment.center,
                //padding: EdgeInsets.all(AHStyle.pageMargins),
                child: AHNumericField(
                  getValue: () {
                    return AHSettings.daysTillExpiration.value;
                  },
                  setValue: (value) {
                    AHSettings.daysTillExpiration.value = value.toInt();
                  },
                  defaultValue: AHSettings.daysTillExpiration.defaultValue,
                  decimalCount: 0,
                ),
              ),
              Container(
                child: AHBodyText(" days"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

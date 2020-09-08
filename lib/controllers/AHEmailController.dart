import 'dart:developer';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_QuoteController.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:axiom_hoist_quote_calculator/PDF/AHPDFExporter.dart';
import 'package:axiom_hoist_quote_calculator/models/AHSettings.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class AHEmailController {
  static const String regexEmailAddressValidatorString = r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  static RegExp regexEmailAddressValidator = RegExp(regexEmailAddressValidatorString);
  
  static void emailEstimation(AQI_QuoteController quoteToEmail) {
    // TODO: Consider support for multiple recipients
    // TODO: Find a way to automatically email without using the phone's default app.
    // Get Recipient
    String recipient = "";
    if (regexEmailAddressValidator.hasMatch(quoteToEmail.contactEmailAddress.value)) {
      recipient = quoteToEmail.contactEmailAddress.value;
    }

    // Get body text
    String contactName = quoteToEmail.contactName.value;
    String bodyText = "$contactName,\n" + AHSettings.emailBody.value;

    String filePath = AHPDFExporter.exportEstimationAsPDF(quoteToEmail);
    log(filePath);
    
    final MailOptions mailOptions = MailOptions(
      body: bodyText,
      subject: AHSettings.emailSubject.value,
      recipients: [recipient],
      //ccRecipients: ["MelchiahMauck@gmail.com"],
      bccRecipients: [AHSettings.companyEmailAddress.value],
      isHTML: false,
      attachments: [ filePath, ],
    );

    sendEmail(mailOptions);
  }
  
  static void sendEmail(MailOptions mailOptions) {
    // TODO: Consider support for multiple recipients
    // TODO: Find a way to automatically email without using the phone's default app.

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
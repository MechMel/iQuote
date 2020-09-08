import 'package:axiom_hoist_quote_calculator/PDF/AHStylePDF.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class AHBodyTextNormal extends AHCustomText {
  AHBodyTextNormal(String text, {PdfColor color = AHStylePDF.COLOR_TEXT, TextAlign textAlign = TextAlign.left,}) : super(text, AHStylePDF.textStyleBodyNormal, color, textAlign: textAlign);
}

class AHBodyTextBold extends AHCustomText {
  AHBodyTextBold(String text, {PdfColor color = AHStylePDF.COLOR_TEXT, TextAlign textAlign = TextAlign.left, }) : super(text, AHStylePDF.textStyleBodyBold, color, textAlign: textAlign);
}

class AHTitleText extends AHCustomText {
  AHTitleText(String text, {PdfColor color = AHStylePDF.COLOR_PRIMARY, TextAlign textAlign = TextAlign.left, }) : super(text, AHStylePDF.textStyleTitle, color, textAlign: textAlign);
}

class AHCustomText extends Text {
  AHCustomText(String text, TextStyle style, PdfColor color, {TextAlign textAlign = TextAlign.left, }) : super(text, style: style.apply(color: color), textAlign: textAlign);
}
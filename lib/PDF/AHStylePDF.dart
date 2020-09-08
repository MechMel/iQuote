import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class AHStylePDF {
  //static Font font = Font.helvetica();
  //static Font fontBold = Font.helveticaBold();
  static const PdfPageFormat PAGE_FORMAT = PdfPageFormat.a4;
  static double get totalPageWidth { return PAGE_FORMAT.width; }
  static const double MARGIN_SIZE = 25;
  static double get internalPageWidth { return PAGE_FORMAT.width - (2 * MARGIN_SIZE); }
  static const double LINE_SPACING_BODY = 2.5;
  static const double LINE_SPACING_TITLE = 2.5;
  static const double FONT_SIZE_BODY = 9;
  static const double FONT_SIZE_TITLE = 28;
  static const PdfColor COLOR_PRIMARY = PdfColor(0.0, 0.43, 0.71);
  static const PdfColor COLOR_ACCENT = PdfColor(0.85, 0.85, 1);
  static const PdfColor COLOR_TEXT = PdfColors.black;
  static const PdfColor COLOR_BACKGROUND = PdfColors.white;
  static TextStyle textStyleBodyNormal = TextStyle(fontSize: FONT_SIZE_BODY, fontWeight: FontWeight.normal, lineSpacing: LINE_SPACING_BODY);
  static TextStyle textStyleBodyBold = TextStyle(fontSize: FONT_SIZE_BODY, fontWeight: FontWeight.bold, lineSpacing: LINE_SPACING_BODY);
  static TextStyle textStyleTitle = TextStyle(fontSize: FONT_SIZE_TITLE, fontWeight: FontWeight.normal, lineSpacing: LINE_SPACING_TITLE, color: COLOR_PRIMARY);
}
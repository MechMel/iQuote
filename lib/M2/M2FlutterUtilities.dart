import 'dart:async';

class M2FlutterUtilities {
  static Future<void> when(bool Function() condition) async {
    // Wait until the condition has been met
    while (!condition()) {
      await Future.delayed(const Duration(milliseconds: 100), () => "100");
    }
  }

  static ObjectType tryReadJson<ObjectType>(Map<String, dynamic> decodedJson, String key, ObjectType defaultValue) {
    if (decodedJson != null && decodedJson.containsKey(key)) {
      return decodedJson[key];
    } else {
      return defaultValue;
    }
  }

  static String getPrintableNum(num number, int decimalCount) {
    List<String> numberTextParts = number.toStringAsFixed(decimalCount).split(".");
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function commaFunction = (Match match) => '${match[1]},';
    String numberText = numberTextParts[0].replaceAllMapped(reg, commaFunction);
    if (numberTextParts.length > 1) {
      numberText += "." + numberTextParts[1];
    }
    return numberText;
  }
}
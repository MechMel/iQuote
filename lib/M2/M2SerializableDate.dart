import 'package:flutter/material.dart';

class M2SerializableDate {
  // Constants
  static const String YEAR_JSON_KEY = "year";
  static const String MONTH_JSON_KEY = "month";
  static const String DAY_JSON_KEY = "day";

  // Properties
  int year;
  int month;
  int day;

  // Contructors
  M2SerializableDate({@required this.year, @required this.month, @required this.day});

  M2SerializableDate.fromDateTime(DateTime dateTime, )
    : year = dateTime.year,
      month = dateTime.month,
      day = dateTime.day;

  M2SerializableDate.fromDecodedJson(Map<String, dynamic> decodedJson)
    : year = decodedJson[YEAR_JSON_KEY],
      month = decodedJson[MONTH_JSON_KEY],
      day = decodedJson[DAY_JSON_KEY];
        
  Map<String, dynamic> toJson()  => {
    YEAR_JSON_KEY: year,
    MONTH_JSON_KEY: month,
    DAY_JSON_KEY: day,
  };

  // Functions
  static String getFormattedDate(M2SerializableDate date, {String delimiter = "/"}) {
    return date.month.toString().padLeft(2, "0") + delimiter + date.day.toString().padLeft(2, "0") + delimiter + date.year.toString();
  }
}
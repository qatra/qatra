import 'package:flutter/services.dart';

String convertArabicToEnglish(String input) {
  const Map<String, String> arabicToEnglish = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  String output = '';
  for (int i = 0; i < input.length; i++) {
    output += arabicToEnglish[input[i]] ?? input[i];
  }
  return output;
}

class EnglishNumeralsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String translated = convertArabicToEnglish(newValue.text);
    return newValue.copyWith(
      text: translated,
      selection: newValue.selection,
    );
  }
}

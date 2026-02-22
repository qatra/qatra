import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FasilaSelector extends StatelessWidget {
  final String? selectedFasila;
  final Function(String) onFasilaSelected;
  final String? Function(String?)? validator;
  final List<String>? customFasilaList;
  final String? hintText;
  final Color? iconColor;

  const FasilaSelector({
    super.key,
    required this.selectedFasila,
    required this.onFasilaSelected,
    this.validator,
    this.customFasilaList,
    this.hintText,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final listToDisplay = customFasilaList ?? bloodTypes;

    return DropdownButtonFormField<String>(
      initialValue:
          (selectedFasila != null && listToDisplay.contains(selectedFasila))
              ? selectedFasila
              : null,
      isExpanded: true,
      hint: hintText != null
          ? Center(
              child: Text(
                hintText!,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            )
          : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(
          Icons.local_hospital_outlined,
          color: iconColor ?? Colors.black,
          size: 24,
        ),
        labelStyle: TextStyle(fontFamily: "Tajawal", color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      validator: validator,
      items: listToDisplay.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Center(
            child: Text(
              dropDownStringItem,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  fontFamily: 'Tajawal', color: Colors.black, fontSize: 14),
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValueSelected) {
        if (newValueSelected != null) {
          onFasilaSelected(newValueSelected);
        }
      },
    );
  }
}

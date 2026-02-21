import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FasilaSelector extends StatelessWidget {
  final String? selectedFasila;
  final Function(String) onFasilaSelected;
  final String? Function(String?)? validator;
  final List<String>? customFasilaList;
  final String? hintText;

  const FasilaSelector({
    super.key,
    required this.selectedFasila,
    required this.onFasilaSelected,
    this.validator,
    this.customFasilaList,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final listToDisplay = customFasilaList ?? bloodTypes;

    return DropdownButtonFormField<String>(
      initialValue:
          (selectedFasila != null && listToDisplay.contains(selectedFasila))
              ? selectedFasila
              : null,
      isDense: true,
      isExpanded: true,
      hint: hintText != null
          ? Center(
              child: Text(hintText!,
                  style: const TextStyle(
                    fontFamily: "Tajawal",
                    color: Colors.grey,
                    fontSize: 15.0,
                  )),
            )
          : null,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: const Icon(
          Icons.local_hospital_outlined,
          color: Colors.black,
          size: 24,
        ),
        labelStyle: const TextStyle(fontFamily: "Tajawal", color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(vertical: 13.5),
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

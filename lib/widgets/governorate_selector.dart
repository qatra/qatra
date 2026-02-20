import 'package:flutter/material.dart';
import 'city_search_list.dart';

class GovernorateSelector extends StatelessWidget {
  final String? selectedGovernorate;
  final bool isShowIcon;
  final Function(String) onGovernorateSelected;
  final String? Function(String?)? validator;

  const GovernorateSelector({
    super.key,
    this.isShowIcon = true,
    required this.selectedGovernorate,
    required this.onGovernorateSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () => _showGovernoratePicker(context),
      validator: validator,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: 'المحافظة',
        labelStyle: const TextStyle(
          fontFamily: 'Tajawal',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: isShowIcon
            ? Icon(Icons.location_city, color: Colors.red[900])
            : null,
        hintText: selectedGovernorate ?? 'اختر المحافظة',
      ),
      controller: TextEditingController(text: selectedGovernorate),
    );
  }

  void _showGovernoratePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: GovernrateSearchList(
                    onGovernrateTap: (governorate) {
                      onGovernorateSelected(governorate);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class FasilaSelector extends StatelessWidget {
  final String? selectedFasila;
  final Function(String) onFasilaSelected;
  final String? Function(String?)? validator;
  final List<String> fasilaList;
  final String labelText;

  const FasilaSelector({
    super.key,
    required this.selectedFasila,
    required this.onFasilaSelected,
    required this.fasilaList,
    this.validator,
    this.labelText = "الفصيلة",
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () => _showFasilaPicker(context),
      validator: validator,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Tajawal',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(
          Icons.local_hospital,
          color: Colors.red[900],
        ),
        hintText: labelText,
      ),
      controller: TextEditingController(text: selectedFasila ?? ''),
    );
  }

  void _showFasilaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15),
            Text(
              labelText,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            const SizedBox(height: 5),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: fasilaList.length,
              itemBuilder: (context, index) {
                final fasila = fasilaList[index];
                final isSelected = fasila == selectedFasila;
                return ElevatedButton(
                  onPressed: () {
                    onFasilaSelected(fasila);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.red[900] : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(color: Colors.red[900]!, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: isSelected ? 4 : 0,
                  ),
                  child: Text(
                    fasila,
                    style: const TextStyle(
                      // fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }
}

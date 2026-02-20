import 'package:flutter/material.dart';
import 'governrate_bank.dart';
import '../widgets/city_search_list.dart';

class BloodBank extends StatelessWidget {
  const BloodBank({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GovernrateSearchList(
          onGovernrateTap: (governrate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GovernrateBank(governrate: governrate),
              ),
            );
          },
        ),
      ),
    );
  }
}

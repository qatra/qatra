import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GovernrateSearchList extends StatefulWidget {
  final Function(String) onGovernrateTap;

  const GovernrateSearchList({super.key, required this.onGovernrateTap});

  @override
  State<GovernrateSearchList> createState() => _GovernrateSearchListState();
}

class _GovernrateSearchListState extends State<GovernrateSearchList> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCities = egyptGovernorates;

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = egyptGovernorates;
      } else {
        _filteredCities =
            egyptGovernorates.where((city) => city.contains(query)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 18,
            right: 16.0,
            left: 16,
          ),
          child: TextFormField(
            controller: _searchController,
            onChanged: _filterCities,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              labelText: 'ابحث عن المحافظة',
              labelStyle: const TextStyle(fontFamily: 'Tajawal'),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(end: 5),
                      child: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterCities('');
                        },
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide:
                    BorderSide(color: Colors.red[900]!.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Colors.red[900]!),
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredCities.isEmpty
              ? const Center(
                  child: Text(
                    "لا توجد نتائج",
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  itemCount: _filteredCities.length,
                  itemBuilder: (context, index) {
                    final city = _filteredCities[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        onTap: () => widget.onGovernrateTap(city),
                        title: Center(
                          child: Text(
                            city,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.red[900],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

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
            right: 18,
            left: 18,
          ),
          child: TextFormField(
            controller: _searchController,
            onChanged: _filterCities,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'ابحث عن المحافظة',
              isDense: true,
              prefixIcon: const Icon(
                Icons.search,
                size: 24,
              ),
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
              : ListView.separated(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, right: 18, left: 18),
                  itemCount: _filteredCities.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 15,
                  ),
                  itemBuilder: (context, index) {
                    final city = _filteredCities[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
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

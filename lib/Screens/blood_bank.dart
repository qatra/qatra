import 'package:flutter/material.dart';
import 'governrate_bank.dart';

class BloodBank extends StatefulWidget {
  @override
  _BloodBankState createState() => _BloodBankState();
}

class _BloodBankState extends State<BloodBank> {
  TextEditingController _search = new TextEditingController();
  List _cities = [
    "الدقهلية",
    "القاهرة",
    "الجيزة",
    "القليوبية",
    "الأسكندرية",
    "البحيرة",
    "مطروح",
    "دمياط",
    "كفر الشيخ",
    "الغربية",
    "المنوفية",
    "الشرقية",
    "بورسعيد",
    "الإسماعيلية",
    "السويس",
    "شمال سيناء",
    "جنوب سيناء",
    "بني سويف",
    "الفيوم",
    "المنيا",
    "أسيوط",
    "الوادي الجديد",
    "سوهاج",
    "قنا",
    "الأقصر",
    "أسوان",
    "البحر الأحمر",
  ];
  List _searchList = [];

  @override
  void initState() {
    super.initState();
    _searchList = _cities;
  }

  _setSearchFilter(String val) {
    if (val.isEmpty) {
      setState(() {
        _searchList = _cities;
      });
      return;
    }
    List temp = [];
    _cities.forEach((city) {
      if (city.contains(val)) {
        temp.add(city);
      }
    });
    setState(() {
      _searchList = temp;
    });
  }

  Widget governrateCard(id) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Container(
        color: Colors.grey[200],
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GovernrateBank(
                          city: id,
                        )));
          },
          title: Center(
            child: Text(
              id,
              style: TextStyle(
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "بنك الدم",
              style: TextStyle(fontFamily: "Tajawal", color: Colors.red[900]),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.red[900]),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        controller: _search,
                        onChanged: (val) => _setSearchFilter(val),
                        decoration: InputDecoration(
                            labelText: 'ابحث',
                            labelStyle: TextStyle(
                              fontFamily: 'Tajawal',
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _search.text = "";
                                });
                                _setSearchFilter("");
                              },
                              child: Icon(Icons.cancel,
                                  size: 25, color: Colors.black87),
                            ),
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: ListView(
                  children: List.generate(_searchList.length, (index) {
                    return governrateCard(_searchList[index]);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

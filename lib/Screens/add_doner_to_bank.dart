import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icandoit/wavyyy.dart';
import '../user_model.dart';

import 'dart:io';

creatAlertDialog(BuildContext context, text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Warning",
            style: TextStyle(color: Colors.red[900], fontSize: 24),
          ),
          elevation: 10,
          content: Text(
            "$text",
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontFamily: "Tajawal", fontSize: 18, color: Colors.black87),
          ),
        );
      });
}

class AddDonerToBank extends StatefulWidget {
  var city;
  GlobalKey<ScaffoldState> _scafold;

  AddDonerToBank(this.city, this._scafold);

  @override
  _AddDonerToBankState createState() => _AddDonerToBankState();
}

class _AddDonerToBankState extends State<AddDonerToBank> {
  GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();

  final _fireStore = FirebaseFirestore.instance;
  User? _user;
  String? name;
  String? fasila;
  String? city;
  String? phone;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var _currentFasilaSelected = 'حدد الفصيلة';
  var _fasila = [
    'حدد الفصيلة',
    'AB+',
    "AB-",
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-"
  ];

  showNotification(msg, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$msg",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Tajawal", fontSize: 18),
          ),
        ),
        backgroundColor: Colors.black87.withOpacity(.8),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      _currentFasilaSelected = newValueSelected;
    });
  }

  validation() {
    (_formKey.currentState?.validate() ?? false) ? addDonorToGovernrateBank() : print("not valid");
  }

  addDonorToGovernrateBank() async {
    setState(() {
      isLoading = true;
    });

    var now = new DateTime.now();

    setState(() {
      _user = User(
          uid: "----",
          email: "----",
          displayName: name,
          phone: phone,
          fasila: _currentFasilaSelected,
          address: city,
          date: now,
          dateOfDonation: "----");
    });

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print("Connected to Mobile Network");

        await _fireStore
            .collection('bank')
            .doc(widget.city)
            .collection('doners')
            .doc(now.toString())
            .set(_user.toMap(_user));

        Navigator.pop(context);

        showNotification("تم اضافة متبرع بنجاح", context); // Pass context instead of widget._scafold

        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      print("Unable to connect. Please Check Internet Connection");

      showNotification("لا يوجد اتصال بالانترنت", context);

      setState(() {
        isLoading = false;
      });
    }

//    setState(() {
//      isLoading = false;
//    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: scafoldKey,

          floatingActionButton: Padding(
              padding: const EdgeInsets.only(right: 20, top: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        "assets/drop.png",
                        width: 75,
                        height: 80,
                      ),
                      Positioned(
                        bottom: 18,
                        right: 24,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          body: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 120,
                      child: Wavyyyy(
                        title: "أضف متبرع الي بنك الدم",
                        backGroundColor: Colors.white,
                        leftIcon: null,
                        onPressedLeft: null,
                        directionOfRightIcon: TextDirection.rtl,
                        onPressedRight: null,
                        rightIcon: null,
                      )),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(15),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: DropdownButtonFormField<String>(
                            validator: (value) => value == "حدد الفصيلة"
                                ? 'برجاء اختيار الفصيلة'
                                : null,
                            elevation: 10,
                            isDense: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                prefixIcon: Icon(
                                  Icons.local_hospital,
                                  size: 22,
                                )),
                            items: _fasila.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Center(
                                  child: Text(
                                    dropDownStringItem,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValueSelected) {
                              if (newValueSelected != null) {
                                _onDropDownItemSelected(newValueSelected);
                              }
                            },
                            initialValue: _currentFasilaSelected,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: new TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "برجاء كتابة الاسم";
                              }
                              if (text.length > 40) {
                                return "الاسم طويل جدا";
                              }
                              if (text.length < 2) {
                                return "الاسم قصير جدا";
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            controller: null,
                            onChanged: (text) {
                              setState(() {
                                name = text;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: 'الاسم',
                                labelStyle: TextStyle(
                                  fontFamily: 'Tajawal',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                prefixIcon: Icon(Icons.account_circle)),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: new TextFormField(
                            validator: (text) {
                              if (text == null) return null;
                              if (text.contains(" ")) {
                                return "لا يجب ان توجد مسافات في رقم التليفون";
                              }
                              if (text.isEmpty) {
                                return "برجاء كتابة رقم التليفون";
                              }
                              if (text.length != 11) {
                                return "رقم التليفون غير صحيح";
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            controller: null,
                            onChanged: (text) {
                              setState(() {
                                phone = text;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: 'رقم التليفون',
                                labelStyle: TextStyle(
                                  fontFamily: 'Tajawal',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                prefixIcon: Icon(Icons.phone_android)),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: null,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "برجاء تحديد العنوان";
                                }
                                if (text.length > 60) {
                                  return "العنوان طويل جدا";
                                }
                                if (text.length < 2) {
                                  return "العنوان قصير جدا";
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              onChanged: (text) {
                                setState(() {
                                  city = text;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.add_location),
                                labelText: 'المدينة',
                                labelStyle: TextStyle(
                                  fontFamily: 'Tajawal',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        isLoading
                            ? Image.asset(
                                "assets/loading.gif",
                                height: 47.0,
                                width: 47.0,
                              )
                            : ElevatedButton(
                                child: Text(
                                  'حفظ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                      fontSize: 20),
                                ),
                                onPressed: () {
                                  validation();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    backgroundColor: Colors.green),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

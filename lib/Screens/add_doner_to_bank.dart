import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user_model.dart';
import '../helpers/utils_helper.dart';

import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';

creatAlertDialog(BuildContext context, text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
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
  final String governrate;

  const AddDonerToBank(this.governrate, {super.key});

  @override
  AddDonerToBankState createState() => AddDonerToBankState();
}

class AddDonerToBankState extends State<AddDonerToBank> {
  final _fireStore = FirebaseFirestore.instance;
  User? _user;
  String? name;
  String? phone;
  String? address;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var _currentFasilaSelected = 'حدد الفصيلة';
  final _fasila = [
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

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      _currentFasilaSelected = newValueSelected;
    });
  }

  validation() {
    (_formKey.currentState?.validate() ?? false)
        ? addDonorToGovernrateBank()
        : debugPrint("not valid");
  }

  addDonorToGovernrateBank() async {
    setState(() {
      isLoading = true;
    });

    var now = DateTime.now();

    setState(() {
      _user = User(
          uid: "----",
          email: "----",
          displayName: name,
          phone: phone,
          fasila: _currentFasilaSelected,
          governorate: widget.governrate,
          address: address,
          date: now,
          dateOfDonation: "----");
    });

    try {
      await _fireStore
          .collection('bank')
          .doc(widget.governrate)
          .collection('doners')
          .doc(now.toString())
          .set(_user!.toMap());

      Navigator.pop(context);

      showNotification("تم اضافة متبرع بنجاح",
          context); // Pass context instead of widget._scafold

      setState(() {
        isLoading = false;
      });
    } on SocketException catch (_) {
      debugPrint("Unable to connect. Please Check Internet Connection");

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "أضف متبرع الي بنك الدم",
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
                    TextFormField(
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
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
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
                        initialValue: widget.governrate,
                        enabled: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'المحافظة',
                          labelStyle: TextStyle(
                            fontFamily: 'Tajawal',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          prefixIcon: Icon(Icons.location_city),
                        ),
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
                              address = text;
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // top border
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: EdgeInsets.only(right: 22, left: 22, top: 16, bottom: 30),
        child: isLoading
            ? Image.asset(
                "assets/loading.gif",
                height: 35,
                width: 35,
              )
            : ElevatedButton(
                onPressed: () {
                  validation();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.red[900]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'حفظ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        fontSize: 17),
                  ),
                ),
              ),
      ),
    );
  }
}

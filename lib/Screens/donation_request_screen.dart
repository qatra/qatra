import 'package:flutter/foundation.dart';

import '../helpers/utils_helper.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart' as lo;
import '../repositories/firebase_repository.dart';
import '../utils/constants.dart';
import '../utils/phone_formatter.dart';
import '../widgets/fasila_selector.dart';
import '../widgets/governorate_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';

class DonationRequestScreen extends StatefulWidget {
  const DonationRequestScreen({super.key});

  @override
  DonationRequestScreenState createState() => DonationRequestScreenState();
}

class DonationRequestScreenState extends State<DonationRequestScreen> {
  final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;

  final _madinaController = TextEditingController();
  final _governmentController = TextEditingController();

  double? longitude;
  double? latitude;
  String? city;
  String? government;

  String? name;
  String? akias;
  String? hospital;
  String? phone;
  String? note;

  TextEditingController textFieldController = TextEditingController();
  final TextEditingController _akias = TextEditingController();

  bool _isLoading = false;

  String? fasila;

  final _formTlabKey = GlobalKey<FormState>();

  void _onDropDownItemSelected(String? newValueSelected) {
    setState(() {
      fasila = newValueSelected ?? fasila;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state is AppAuthenticated) {
          if (phone == null && state.userProfile?.phone != null) {
            phone = state.userProfile!.phone;
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "طلب تبرع",
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 0, right: 20, left: 20),
                  child: Form(
                    key: _formTlabKey,
                    child: Column(
                      children: <Widget>[
                        FasilaSelector(
                          selectedFasila: fasila,
                          fasilaList: bloodTypes,
                          onFasilaSelected: (value) {
                            _onDropDownItemSelected(value);
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "حدد الفصيلة";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "ادخل اسم الحالة";
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          controller: textFieldController,
                          onChanged: (text) {
                            setState(() {
                              name = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'الاسم',
                            prefixIcon:
                                Icon(Icons.person, color: Colors.red[900]),
                            labelStyle: const TextStyle(
                              fontFamily: 'Tajawal',
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              akias = "---";
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          controller: _akias,
                          onChanged: (text) {
                            setState(() {
                              akias = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'عدد الأكياس',
                            prefixIcon:
                                Icon(Icons.bloodtype, color: Colors.red[900]),
                            labelStyle: const TextStyle(
                              fontFamily: 'Tajawal',
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GovernorateSelector(
                          selectedGovernorate: government,
                          onGovernorateSelected: (value) {
                            setState(() {
                              government = value;
                              _governmentController.text = value;
                            });
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return "ادخل اسم المحافظة";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "ادخل اسم المدينة";
                            }
                            if (text.trim() == "") {
                              return "ادخل اسم المدينة";
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          controller: _madinaController,
                          onChanged: (text) {
                            setState(() {
                              city = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'المدينة',
                            prefixIcon: Icon(Icons.location_city,
                                color: Colors.red[900]),
                            labelStyle: const TextStyle(
                              fontFamily: 'Tajawal',
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "ادخل اسم المستشفي";
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          controller: null,
                          onChanged: (text) {
                            setState(() {
                              hospital = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'اسم المستشفي',
                            prefixIcon: Icon(Icons.local_hospital,
                                color: Colors.red[900]),
                            labelStyle: const TextStyle(
                              fontFamily: 'Tajawal',
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          initialValue: phone,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "ادخل رقم تليفون المرافق";
                            }
                            if (text.length != 11) {
                              return "هذا الرقم غير صحيح";
                            }
                            return null;
                          },
                          keyboardType: const TextInputType.numberWithOptions(),
                          inputFormatters: [EnglishNumeralsFormatter()],
                          textAlign: TextAlign.center,
                          onChanged: (text) {
                            setState(() {
                              phone = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'رقم المرافق',
                            prefixIcon:
                                Icon(Icons.phone, color: Colors.red[900]),
                            labelStyle: const TextStyle(
                              fontFamily: 'Tajawal',
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              note = "---";
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          controller: null,
                          onChanged: (text) {
                            setState(() {
                              note = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'ملاحظات',
                            prefixIcon:
                                Icon(Icons.note, color: Colors.red[900]),
                            labelStyle: const TextStyle(
                              fontFamily: 'Tajawal',
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
            child: _isLoading
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "ارسال طلب التبرع",
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 17),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  getLocationPermission() async {
    final lo.Location location = lo.Location();
    bool serviceEnabled;
    lo.PermissionStatus permissionGranted;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      if (!kIsWeb) {
        permissionGranted = await location.hasPermission();
        if (permissionGranted == lo.PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != lo.PermissionStatus.granted) {
            return;
          }
        }
      }
    } catch (e) {
      debugPrint("Location permission error: $e");
    }
  }

  validation() {
    (_formTlabKey.currentState?.validate() ?? false)
        ? addPost()
        : debugPrint("not valid");
  }

  addPost() async {
    setState(() {
      _isLoading = true;
    });
    var now = DateTime.now();
    bool postColor = true;

    try {
      await _submitPost(now, postColor);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showNotification("حدث خطأ ما", context);
    }
  }

  _submitPost(DateTime now, bool postColor) async {
    final state = context.read<AppCubit>().state;
    String? userEmail;
    if (state is AppAuthenticated) {
      userEmail = state.firebaseUser.email;
    }

    Map<String, dynamic> postMap() => {
          'name': name,
          'fasila': fasila,
          'akias': akias,
          'government': government,
          'city': city,
          'hospital': hospital,
          'phone': phone,
          'note': note,
          'date': now,
          'dateThatSignsThePost': now.toString(),
          'postSender': userEmail,
          'postColor': postColor
        };

    await _firebaseRepo.sendDonationRequest(postMap(), now.toString());

    setState(() {
      _isLoading = false;
    });

    showNotification("تم اضافة طلب التبرع بنجاح", context);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}

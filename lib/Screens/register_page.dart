import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icandoit/Screens/login_page.dart';
import 'package:location/location.dart' as lo;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../repositories/firebase_repository.dart';
import '../helpers/utils_helper.dart';
import 'package:icandoit/user_model.dart';
import 'package:icandoit/widgets/fasila_selector.dart';
import '../utils/phone_formatter.dart';
import '../widgets/governorate_selector.dart';
import 'main_screen.dart';

final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;
User? _user;

class RegisterPage extends StatefulWidget {
  final String? emailFromGoogle;
  final String? uidFromGoogle;

  const RegisterPage({super.key, this.emailFromGoogle, this.uidFromGoogle});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? name;
  String? email;
  String? password;
  String? confirmPassword;
  String? phoneNumber;
  String? address;
  String? governorate;

  String? _currentFasilaSelected;

  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.emailFromGoogle != null) {
      _emailController.text = widget.emailFromGoogle!;
      email = widget.emailFromGoogle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Center(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 5.0, right: 20.0, left: 20.0, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "برجاء كتابة الاسم";
                                }
                                if (text.length > 40) {
                                  return "الاسم طويل جدا";
                                }
                                if (text.trim() == "") {
                                  return "لا يجب ان يكون الاسم كله مسافات";
                                }
                                if (text.length < 2) {
                                  return "الاسم قصير جدا";
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              controller: _nameController,
                              onChanged: (text) {
                                setState(() {
                                  name = text;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'الاسم',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Tajawal',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(Icons.account_circle)),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 17),
                              child: TextFormField(
                                readOnly: widget.emailFromGoogle != null,
                                enabled: widget.emailFromGoogle == null,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "برجاء كتابة البريد الالكتروني";
                                  }
                                  if (text.length > 50) {
                                    return "البريد الالكتروني طويل جدا";
                                  }
                                  if (text.contains(" ")) {
                                    return "لا يجب ان توجد مسافات في البريد الالكتروني";
                                  }
                                  if (!text.contains("@") ||
                                      !text.contains(".")) {
                                    return "البريد الالكتروني غير صحيح";
                                  }
                                  if (text.length < 2) {
                                    return "البريد الالكتروني قصير جدا";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                controller: _emailController,
                                onChanged: (text) {
                                  setState(() {
                                    email = text;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: 'البريد الالكتروني',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Tajawal',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(Icons.email)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 17),
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
                                inputFormatters: [EnglishNumeralsFormatter()],
                                onChanged: (text) {
                                  setState(() {
                                    phoneNumber = text;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: 'رقم التليفون',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Tajawal',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(Icons.phone_android)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 17),
                              child: FasilaSelector(
                                selectedFasila: _currentFasilaSelected,
                                onFasilaSelected: (value) {
                                  _onDropDownItemSelected(value);
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "حدد فصييلة دمك";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 17),
                              child: GovernorateSelector(
                                selectedGovernorate: governorate,
                                onGovernorateSelected: (value) {
                                  setState(() {
                                    governorate = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "برجاء اختيار المحافظة";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 17),
                              child: TextFormField(
                                controller: _addressController,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "برجاء كتابة المنطقة";
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
                                  hintText: 'المنطقة',
                                  labelStyle: const TextStyle(
                                    fontFamily: 'Tajawal',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 13),
                              child: SizedBox(
                                width: 300,
                                height: 37,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    _formKey.currentState!.validate()
                                        ? creatUser()
                                        : debugPrint("not valid");
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: Colors.red[900]!),
                                  child: Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              child: Text(
                                'لديك حساب ؟ سجل دخولك من هنا .',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                            ),
                          ],
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

  Future<void> getLocationPermission() async {
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

  creatUser() async {
    setState(() {
      showSpinner = true;
    });
    auth.User? firebaseUser;

    try {
      try {
        if (widget.uidFromGoogle != null) {
          // If we have a Google UID, we use the current user or the one from Google flow
          firebaseUser = _firebaseRepo.currentUser;
        } else {
          // This path might no longer be used if we only allow Google Sign-In,
          // but keeping for robustness if password code is ever uncommented.
          await _firebaseRepo.register(
              email!, password ?? "dummy_password_unused");
          firebaseUser = _firebaseRepo.currentUser;
        }

        var now = DateTime.now();
        _user = User(
            uid: firebaseUser!.uid,
            email: firebaseUser.email,
            displayName: name,
            phone: phoneNumber,
            fasila: _currentFasilaSelected,
            address: address,
            governorate: governorate,
            date: now,
            dateOfDonation: "----");

        await _firebaseRepo.createUserProfile(_user!);

        setState(() {
          showSpinner = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MainScreen()),
            (Route<dynamic> route) => false);
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        String errorSigningIn = "حدث خطأ أثناء إنشاء الحساب: $e";
        if (!kIsWeb) {
          if (e is auth.FirebaseAuthException) {
            switch (e.code) {
              case 'user-not-found':
                errorSigningIn = "لا يوجد مستخدم بهذه المعلومات";
                break;
              case 'wrong-password':
                errorSigningIn = "كلمة مرور خاطئة";
                break;
              case 'network-request-failed':
                errorSigningIn = "خطأ في الاتصال بالشبكة";
                break;
              default:
                errorSigningIn = e.message ?? e.code;
            }
          }
        }
        showNotification(errorSigningIn, context);
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      showNotification("خطأ غير متوقع", context);
    }
  }

  void _onDropDownItemSelected(String? newValueSelected) {
    setState(() {
      _currentFasilaSelected = newValueSelected ?? _currentFasilaSelected;
    });
  }
}

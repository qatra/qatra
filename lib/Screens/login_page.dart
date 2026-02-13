import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:icandoit/Screens/profile_page.dart';
import '../user_model.dart';
import 'register_page.dart';
import 'first_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:universal_io/io.dart';
import 'package:google_sign_in/google_sign_in.dart' as gs;
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _fireStore = FirebaseFirestore.instance;
  String? email;
  String? password;

// ... (skip unchanged lines if possible, but replace_file_content needs contiguous)
// I will just replace the import line and the usage block separately.
  bool _showPassword = false;
  bool showSpinner = false;
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  GlobalKey<ScaffoldState> _scafold = new GlobalKey<ScaffoldState>();

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future _signIn() async {
    try {
      final gs.GoogleSignIn googleSignIn = gs.GoogleSignIn.standard();
      final gs.GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        // User cancelled the sign-in
        return;
      }

      final gs.GoogleSignInAuthentication authentication =
          await account.authentication;

      auth.UserCredential res = await _auth.signInWithCredential(
          auth.GoogleAuthProvider.credential(
              idToken: authentication.idToken,
              accessToken: authentication.accessToken));

      if (res.additionalUserInfo!.isNewUser) {
        setState(() {
          showSpinner = true;
        });
        try {
          if (!kIsWeb) {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              print("Connected to Mobile Network");
              await _finishSocialSignIn();
            }
          } else {
            await _finishSocialSignIn();
          }
        } on SocketException catch (_) {
          String invalid = "حدث خطأ أثناء اتمام العملية !";
          setState(() {
            showSpinner = false;
          });
          showNotification("حدث خطأ أثناء اتمام العملية ", context);
        }

        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => FirstPage()));
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => ProfilePage()));

        setState(() {
          showSpinner = false;
        });
      } else {
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => FirstPage()));
      }
    } catch (e) {
      print("${e.toString()}");
      showNotification("${e.toString()}", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _scafold,
          backgroundColor: Colors.white,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Center(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(23.0),
                  children: <Widget>[
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 5.0, right: 20.0, left: 20.0, bottom: 30),
                      child: new Column(
                        children: <Widget>[
                          Form(
                            key: _loginFormKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 20.00),
                                  child: Image.asset(
                                    "assets/fainallogo.png",
                                    height: 140,
                                    width: 150,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 17),
                                  child: new TextFormField(
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "برجاء كتابة البريد الالكتروني";
                                      }
                                      if (text.length < 2) {
                                        return "البريد الالكتروني قصير جدا";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) {
                                      setState(() {
                                        email = text;
                                      });
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    textAlign: TextAlign.center,
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        labelText: 'البريد الالكتروني',
                                        labelStyle: TextStyle(
                                          fontFamily: 'Tajawal',
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        prefixIcon: Icon(Icons.email)),
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.only(top: 17),
                                  child: new TextFormField(
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "برجاء كتابة كلمة المرور";
                                      }
                                      if (text.length <= 5) {
                                        return "كلمة المرور يجب ان لا تقل عن 6 حروف";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) {
                                      setState(() {
                                        password = text;
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    controller: _passwordController,
                                    obscureText: !this._showPassword,
                                    decoration: new InputDecoration(
                                      prefixIcon: Icon(Icons.lock_outline),
                                      labelText: 'كلمة المرور',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Tajawal',
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: this._showPassword
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() => this._showPassword =
                                              !this._showPassword);
                                        },
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 15),
                                  child: new Column(
                                    children: <Widget>[
                                      SizedBox(height: 10.0),
                                      Container(
                                        padding:
                                            EdgeInsets.only(top: 2, bottom: 15),
                                        child: SizedBox(
                                          width: 300,
                                          height: 37,
                                          child: ElevatedButton(
                                            child: Text(
                                              'تسجيل الدخول',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () async {
                                              _loginFormKey.currentState!
                                                      .validate()
                                                  ? signIn()
                                                  : print("not valid");
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                backgroundColor:
                                                    Colors.red[900]),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 2),
                                        child: SizedBox(
                                          width: 300,
                                          height: 37,
                                          child: ElevatedButton(
                                            child: Text(
                                              'إنشاء حساب',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new RegisterPage()));
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                backgroundColor: Colors.green),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 3,
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: SizedBox(
                                          width: 300,
                                          height: 37,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    'Sign in with Google',
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 14,
                                                ),
                                                Image.asset(
                                                  "assets/google.png",
                                                  height: 20,
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                            onPressed: () async {
                                              _signIn();
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 3,
                                        color: Colors.grey,
                                      ),
                                      new TextButton(
                                        child: new Text(
                                          'نسيت كلمة المرور ؟',
                                          style: TextStyle(
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                        onPressed: () {
                                          forgotPassword(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  var forgottenEmail;

  forgotPassword(BuildContext contex) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Center(
              child: Text(
                "ارسال كلمة المرور لبريدك الالكتروني",
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: Colors.red[900],
                  fontSize: 15,
                ),
              ),
            ),
            elevation: 10,
            content: TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (text) {
                forgottenEmail = text;
              },
              decoration: InputDecoration(
                labelText: "البريد الالكتروني",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'ارسال',
                  style: TextStyle(
                      color: Colors.white, // check
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                onPressed: () {
                  sendPassReset(forgottenEmail);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.green),
              ),
            ],
          );
        });
  }

  Future sendPassReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      showNotification("لا يوجد اتصال بالانترنت !", context);
      return e;
    }
  }

  signIn() async {
    setState(() {
      showSpinner = true;
    });

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => FirstPage()));
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      setState(() {
        showSpinner = false;
      });

      String errorSigningIn = "لقد حدث خطأ في اتمام العملية !";
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          // ... (existing logic)
        } else if (Platform.isIOS) {
          // ... (existing logic)
        }
      }
      showNotification(errorSigningIn, context);
      print(e);
    }
  }

  Future<void> _finishSocialSignIn() async {
    auth.User? firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      var now = new DateTime.now();
      var _user = User(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? "",
          displayName: "---",
          phone: "---",
          fasila: "---",
          address: "---",
          date: now,
          dateOfDonation: "---");
      await _fireStore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(_user.toMap());

      setState(() {
        showSpinner = false;
      });
    }
  }
}

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
      backgroundColor: Colors.black87.withValues(alpha: .8),
      duration: Duration(seconds: 4),
    ),
  );
}

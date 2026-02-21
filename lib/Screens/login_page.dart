import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'register_page.dart';
import 'main_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:google_sign_in/google_sign_in.dart' as gs;
import '../utils/google_sign_in_web_stub.dart'
    if (dart.library.js_interop) '../utils/google_sign_in_web_real.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../repositories/firebase_repository.dart';
import '../bloc/app_bloc.dart';
import '../helpers/utils_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String? email;
  String? password;

  final gs.GoogleSignIn _googleSignIn = gs.GoogleSignIn.instance;
  StreamSubscription<gs.GoogleSignInAuthenticationEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initGoogleSignIn();
  }

  void _initGoogleSignIn() async {
    if (kIsWeb) {
      await _googleSignIn.initialize(
          clientId:
              "858369127304-gum9t7adrbd0vug21csb8irk9t35qep6.apps.googleusercontent.com");
    } else {
      await _googleSignIn.initialize();
    }

    _authSubscription = _googleSignIn.authenticationEvents.listen((event) {
      if (event is gs.GoogleSignInAuthenticationEventSignIn) {
        _handleGoogleSignInResult(event.user);
      }
    }, onError: (e) {
      debugPrint("Google Sign In Error: $e");
      showNotification(e.toString(), context);
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleGoogleSignInResult(gs.GoogleSignInAccount account) async {
    setState(() {
      showSpinner = true;
    });
    try {
      final gs.GoogleSignInAuthentication authentication =
          account.authentication;

      auth.UserCredential res = await _firebaseRepo.loginWithGoogle(
          idToken: authentication.idToken, accessToken: null);

      // Check if user exists in Firestore users collection
      final userProfile = await _firebaseRepo.getUserProfile(res.user!.uid);

      if (userProfile != null) {
        if (context.mounted) {
          await context.read<AppCubit>().refreshUserProfile();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen()));
        }
      } else {
        // User doesn't exist in our DB, send to registration
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RegisterPage(
                      emailFromGoogle: account.email,
                      uidFromGoogle: res.user!.uid,
                    )));
      }
    } catch (e) {
      debugPrint(e.toString());
      showNotification(e.toString(), context);
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  bool showSpinner = false;
  final _loginFormKey = GlobalKey<FormState>();

  final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;

  Future _signIn() async {
    try {
      if (kIsWeb) {
        // On web, the button itself handles the sign-in flow.
        // We just need to ensure the client is initialized (done in initState).
        return;
      }
      final gs.GoogleSignIn googleSignIn = gs.GoogleSignIn.instance;
      await googleSignIn.authenticate();
      // On mobile, authenticate() will trigger the authenticationEvents listener.
    } catch (e) {
      debugPrint(e.toString());
      showNotification(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
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
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      "تسجيل الدخول أو إنشاء حساب باستخدام جوجل",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: kIsWeb
                        ? Center(child: renderGoogleSignInButton())
                        : SizedBox(
                            width: 300,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
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
                    height: 30,
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

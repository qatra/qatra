import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/app_bloc.dart';
import 'login_page.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var alertMessage = "برجاء التحقق من الاتصال بشبكة الانترنت";
  bool refreshButton = false;

  Future<void> checkIfLoggedIn() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await context.read<AppCubit>().refreshUserProfile();
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        checkIfLoggedIn();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: Opacity(
                opacity: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.red[900]!,
                  child: Image.asset(
                    "assets/fainallogo.png",
                    height: 140,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              child: TextLiquidFill(
                text: 'قطرة دم = حياة',
                waveColor: Colors.red[900]!,
                boxBackgroundColor: Colors.white,
                textStyle: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
                loadDuration: Duration(milliseconds: 750),
              ),
            ),
            refreshButton == false
                ? Container()
                : Positioned(
                    bottom: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            'اعادة المحاولة',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {},
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

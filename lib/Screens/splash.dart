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
      extendBody: true,
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Center(
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
          ],
        ),
      ),
    );
  }
}

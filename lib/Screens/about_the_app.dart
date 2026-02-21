import 'package:flutter/material.dart';
import 'package:icandoit/helpers/utils_helper.dart';
// import 'package:icandoit/wavyyy.dart';

class AboutTheApp extends StatelessWidget {
  const AboutTheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      titlePadding: EdgeInsets.only(top: 15),
      title: Center(
        child: Text(
          "عن قطرة",
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: Colors.red[900],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text:
                                "تطبيق قطرة هو مشروع تخرج طلبة كلية الهندسة جامعة المنصورة قسم الاتصالات و الالكترونيات ",
                            style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          // TextSpan(
                          //   text: "\nقسم الاتصالات و الالكترونيات",
                          //   style: TextStyle(
                          //       fontFamily: 'Tajawal',
                          //       fontSize: 16,
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.bold),
                          // ),
                        ])),
                    const SizedBox(height: 10),
                    _buildName("عبدالله عزمي احمد"),
                    _buildName("ايمان محمود محمد"),
                    _buildName("مى ممدوح الطنطاوى"),
                    _buildName("ولاء عابد جابر"),
                    _buildName("نورا محمد فرج"),
                    _buildName("اسماء مختار القفاص"),
                    _buildName("سهيلة ابراهيم الشيخ"),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 6),
                      child: Text(
                        "تحت اشراف",
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildName("م/ باسم مصطفى حسن"),
                    _buildName("د/ ايهاب هانى عبدالحى"),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/fainallogo.png',
                          height: 45,
                        ),
                        const SizedBox(width: 15),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: InkWell(
                            onTap: () => launchExternalUrl(
                                "https://www.facebook.com/Qatra.blood.donation?rdid=65ZBQiESrCgdFbSO&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1HfDqNz78c%2F%3Fref%3D1#"),
                            child: const Text(
                              'تواصل معنا',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.only(bottom: 10, right: 15, left: 15),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "إغلاق",
            style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.red[900],
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildName(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        name,
        style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            color: Colors.red[900],
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'donation_article.dart';
import 'package:url_launcher/url_launcher.dart';

class Articles extends StatefulWidget {
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            elevation: 0,
            title: Text(
              "مقالات",
              style: TextStyle(fontFamily: "Tajawal", color: Colors.blue[900]),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.blue[900]),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  color: Colors.grey[300],
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => DonationArticle()));
                        },
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Image.asset(
                                  'assets/88.jpg',
                                  height: 250,
                                  fit: BoxFit.fitWidth,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "التبرع بالدم .. حقائق و إرشادات",
                                      style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 3),
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: new BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "مهم",
                                            style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.red[900]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL() async {
                            final url = Uri.parse(
                                'https://www.moh.gov.sa/HealthAwareness/EducationalContent/Diseases/Hematology/Pages/009.aspx');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }

                          _launchURL();
                        },
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Image.asset(
                                  'assets/33.jpg',
                                  height: 250,
                                  fit: BoxFit.fitWidth,
                                ),
                                Text(
                                  "لماذا التبرع بالدم ؟",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL() async {
                            final url = Uri.parse(
                                'https://www.emaratalyoum.com/local-section/health/2013-12-13-1.631357');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }

                          _launchURL();
                        },
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Image.asset(
                                  'assets/44.jpg',
                                  height: 250,
                                  fit: BoxFit.fitWidth,
                                ),
                                Text(
                                  "تعويض الدم المتبرع به",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL() async {
                            final url = Uri.parse(
                                'https://arabic.rt.com/news/828610-%D8%AD%D9%82%D8%A7%D8%A6%D9%82-%D9%85%D9%87%D9%85%D8%A9-%D8%A7%D9%84%D8%AF%D9%85-%D8%A7%D9%84%D8%A8%D8%B4%D8%B1%D9%8A/');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }

                          _launchURL();
                        },
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Image.asset(
                                  'assets/11.jpg',
                                  height: 250,
                                  fit: BoxFit.fitWidth,
                                ),
                                Text(
                                  "حقائق مهمة غير معروفة عن الدم البشري",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL() async {
                            final url = Uri.parse(
                                'https://www.webteb.com/articles/%D8%A7%D8%B4%D9%8A%D8%A7%D9%84-%D9%8A%D8%AC%D8%A8-%D8%A7%D9%84%D8%A7%D9%86%D8%AA%D8%A8%D8%A7%D9%84-%D9%84%D9%87%D8%A7-%D9%82%D8%A8%D9%84-%D8%A7%D9%84%D8%AA%D8%A8%D8%B1%D8%B9-%D8%A8%D8%A7%D9%84%D8%AF%D9%85_20550');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }

                          _launchURL();
                        },
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Image.asset(
                                  'assets/22.jpg',
                                  height: 250,
                                  fit: BoxFit.fitWidth,
                                ),
                                Text(
                                  "أشياء يجب الإنتباه لها قبل التبرع بالدم",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

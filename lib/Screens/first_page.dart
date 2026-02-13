import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icandoit/wavyyy.dart';
// // import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'blazma_bank.dart';
import 'blood_bank.dart';
import 'about_theApp.dart';
import 'articles.dart';
import 'chat.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'tlab_tabaro3.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
// import 'package:social_share_plugin/social_share_plugin.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:icandoit/appBar_widget.dart';
// import 'package:share_extend/share_extend.dart';

final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

final _auth = auth.FirebaseAuth.instance;
auth.User? _loggedInUser;

Future<auth.User?> getCurrentUser() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  } catch (e) {
    print(e);
  }
  return _loggedInUser;
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  _FirstPageState();

  var _fasila = [
    ' - عرض كل الطلبات -  ',
    'AB+',
    "AB-",
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    'اي فصيلة',
  ];
  var _currentFasilaSelected = ' - عرض كل الطلبات -  ';

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      _currentFasilaSelected = newValueSelected;
    });
  }

  Stream<QuerySnapshot>? search = FirebaseFirestore.instance
      .collection("post")
      .orderBy('date', descending: true)
      .snapshots();

  setTheSearch() {
    if (_currentFasilaSelected != ' - عرض كل الطلبات -  ') {
      setState(() {
        search = FirebaseFirestore.instance
            .collection("post")
            .orderBy('date', descending: true)
            .where('fasila', isEqualTo: _currentFasilaSelected)
            .snapshots();
      });
    } else {
      setState(() {
        search = FirebaseFirestore.instance
            .collection("post")
            .orderBy('date', descending: true)
            .snapshots();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  static IconData backIcon(BuildContext context) {
    if (kIsWeb) return Icons.arrow_back;
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
//        theme: ThemeData.dark(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            key: _key,
            resizeToAvoidBottomInset: false,
//            appBar: Wavyyyy(),
            floatingActionButton: Padding(
                padding: const EdgeInsets.only(right: 20, top: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new TalabTabaro3()));
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
                          bottom: 15,
                          right: 21,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            drawer: Opacity(
              opacity: .9,
              child: Drawer(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      child: DrawerHeader(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/fainallogo.png",
                          )
                        ],
                      )),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: null,
                            child: Container(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new BloodBank()));
                                },
                                title: Text(
                                  "بنك الدم",
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                leading: Icon(Icons.local_hospital,
                                    size: 30, color: Colors.red[900]),
                                trailing: null,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: null,
                            child: Container(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new BlazmaBank()));
                                },
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      "بنك البلازما",
                                      style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      "( المتعافين )",
                                      style: TextStyle(
                                          fontFamily: 'Tajawal',
//                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87.withOpacity(.5),
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                leading: Icon(Icons.add_circle_outline,
                                    size: 30, color: Colors.red[900]),
                                trailing: null,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: null,
                            child: Container(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new ProfilePage()));
                                },
                                title: Text(
                                  "الصفحة الشخصية",
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                leading: Icon(Icons.account_circle,
                                    size: 30, color: Colors.red[900]),
                                trailing: null,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: null,
                            child: Container(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => Chat()));
                                },
                                title: Text(
                                  "الشات العام",
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                leading: Icon(Icons.chat,
                                    size: 30, color: Colors.red[900]),
                                trailing: null,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: null,
                            child: Container(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new Articles()));
                                },
                                title: Text(
                                  "مقالات",
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                leading: Icon(Icons.description,
                                    size: 30, color: Colors.red[900]),
                                trailing: null,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: null,
                            child: Container(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new AboutTheApp()));
                                },
                                title: Text(
                                  "عن التطبيق",
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                leading: Icon(Icons.apps,
                                    size: 30, color: Colors.red[900]),
                                trailing: null,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: null,
                            child: Container(
                              child: ListTile(
                                onTap: () {
                                  _auth.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginPage()));
                                },
                                title: Text(
                                  "تسجيل الخروج",
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                leading: Icon(
                                  Icons.lock_outline,
                                  size: 30,
                                  color: Colors.red[900],
                                ),
                                trailing: null,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dx > 20)
                  print("Dragging in +X direction");
                else
                  _key.currentState?.openDrawer();
                print("Dragging in -X direction");
              },
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 120,
                        child: Wavyyyy(
                          title: "طلبات التبرع",
                          backGroundColor: Colors.grey[300],
                          leftIcon: null,
                          onPressedLeft: null,
                          onPressedRight: () {
                            _key.currentState?.openDrawer();
                          },
                          directionOfRightIcon: TextDirection.ltr,
                          rightIcon: Icons.dehaze,
                        )),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 0, right: 10, left: 10),
                      child: DropdownButtonFormField<String>(
                        isDense: true,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            prefixIcon: Icon(
                              Icons.local_hospital,
                              color: Colors.red[900],
                              size: 24,
                            )),
                        validator: (value) => value == "حدد فصيلتك"
                            ? 'برجاء اختيار الفصيلة'
                            : null,
                        items: _fasila.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Center(
                                child: Text(
                              dropDownStringItem,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 18,
                                fontFamily: 'Tajawal',
                              ),
                            )),
                          );
                        }).toList(),
                        onChanged: (String? newValueSelected) {
                          // Your code to execute, when a menu item is selected from drop down
                          if (newValueSelected != null) {
                            _onDropDownItemSelected(newValueSelected);
                            setTheSearch();
                          }
                        },
                        initialValue: _currentFasilaSelected,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: search,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 150,
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.red[900],
                              ),
                            ),
                          );
                        }
                        final posts = snapshot.data!.docs;
                        List<PostBubble> postBubbles = [];
                        for (var post in posts) {
                          final date = post.get("date").toDate();
                          final dateThatSignsThePost =
                              post.get("dateThatSignsThePost");
                          final name = post.get("name");
                          final fasila = post.get("fasila");
                          final akias = post.get("akias");
                          final government = post.get("government");
                          final city = post.get("city");
                          final hospital = post.get("hospital");
                          final hospitalAddress = post.get("hospitalAddress");
                          final phone = post.get("phone");
                          final note = post.get("note");
                          final postSender = post.get("postSender");
                          final postColor = post.get("postColor");

                          final postBubble = PostBubble(
                            name: name,
                            fasila: fasila,
                            akias: akias,
                            government: government,
                            city: city,
                            hospital: hospital,
                            hospitalAddress: hospitalAddress,
                            phone: phone,
                            note: note,
                            date: date,
                            postSender: postSender,
                            postColor: postColor,
                            dateThatSignsThePost: dateThatSignsThePost,
                          );
                          postBubbles.add(postBubble);
                        }
                        return Expanded(
                          child: SizedBox(
//                              height: 170.0,
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 15),
                              children: postBubbles,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class PostBubble extends StatefulWidget {
  PostBubble({
    this.name,
    this.fasila,
    this.akias,
    this.government,
    this.city,
    this.phone,
    this.hospital,
    this.date,
    this.hospitalAddress,
    this.note,
    this.postSender,
    this.postColor,
    this.dateThatSignsThePost,
  });

  final String? name;
  final String? fasila;
  final String? akias;
  final String? government;
  final String? city;
  final String? phone;
  final String? hospital;
  final String? hospitalAddress;
  final String? note;
  final dynamic date;
  final String? postSender;
  final bool? postColor;
  final String? dateThatSignsThePost;

  @override
  _PostBubbleState createState() => _PostBubbleState();
}

class _PostBubbleState extends State<PostBubble> {
  changeDateFormat() {
    String formattedDate =
        intl.DateFormat.yMMMMd('en_US').add_jm().format(widget.date);
    return formattedDate;
  }

  changeColor() {
    if (widget.postColor == true) {
      return widget.postSender == _loggedInUser?.email
          ? Colors.yellow[600]
          : Colors.white;
    }
    return Colors.green[200];
  }

  updatePostStateEnd() async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.dateThatSignsThePost)
        .update({'postColor': false});
  }

  updatePostStateContinue() async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.dateThatSignsThePost)
        .update({'postColor': true});
  }

  deletePost() async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.dateThatSignsThePost)
        .delete();
  }

  GlobalKey _globalKey = new GlobalKey();

  Future capturePNG() async {
    if (kIsWeb) {
      showNotification("هذه الميزة غير متوفرة علي الويب حاليا", _key);
      return;
    }
    // Mobile logic remains but stubs out dependencies if they fail
    try {
      // boundary = _globalKey.currentContext.findRenderObject();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String fasilaText = widget.postColor == true
        ? (widget.fasila ?? "")
        : "طلب التبرع هذا قد تم";

    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(2, 5),
              blurRadius: 6)
        ], borderRadius: BorderRadius.circular(25), color: changeColor()),
        width: double.infinity,
//      height: 159,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  fasilaText,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red[700],
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                        "${widget.government} -- ${widget.city}",
                                        style: TextStyle(
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[500],
                                            fontSize: 16,
                                            letterSpacing: .3)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.account_circle,
                                  color: Colors.red[700],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: 'اسم الحالة :',
                                        style: TextStyle(
                                            fontFamily: 'Tajawal',
                                            color: Colors.grey[800],
                                            fontSize: 16,
                                            letterSpacing: .3),
                                      ),
                                      TextSpan(
                                        text: ' ${widget.name}',
                                        style: TextStyle(
                                            fontFamily: 'Tajawal',
                                            color: Colors.red[500],
                                            fontSize: 16,
                                            letterSpacing: .3),
                                      ),
                                    ]),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Text(
                                    changeDateFormat(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            ExpandChild(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: <Widget>[
                                          widget.postColor == true
                                              ? Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.phone,
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: SelectableText(
                                                          "${widget.phone}",
                                                          onTap: () {
                                                        call();
                                                      },
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .lightBlueAccent,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  .3)),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.phone,
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text("-----------",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .lightBlueAccent,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  .3)),
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.accessibility_new,
                                                color: Colors.red[700],
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: RichText(
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'عدد الأكياس :',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Tajawal',
                                                              color: Colors
                                                                  .grey[800],
                                                              fontSize: 14,
                                                              letterSpacing:
                                                                  .3),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              ' ${widget.akias}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Tajawal',
                                                              color: Colors
                                                                  .red[500],
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  .3),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.local_hospital,
                                                color: Colors.red[700],
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    'اسم المستشفي :',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Tajawal',
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    fontSize:
                                                                        14,
                                                                    letterSpacing:
                                                                        .3),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text:
                                                              '${widget.hospital}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Tajawal',
                                                              color: Colors
                                                                  .red[500],
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  .3),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.home,
                                                color: Colors.red[700],
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Row(
                                                  children: <Widget>[
                                                    RichText(
                                                      text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  'عنوان المستشفي :',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Tajawal',
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      .3),
                                                            ),
                                                          ]),

//
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text:
                                                              '${widget.hospitalAddress}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Tajawal',
                                                              color: Colors
                                                                  .red[500],
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  .3),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.content_paste,
                                                color: Colors.red[700],
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Row(
                                                  children: <Widget>[
                                                    RichText(
                                                      text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: 'ملاحظة :',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Tajawal',
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      .3),
                                                            ),
                                                          ]),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Flexible(
                                                        child: RichText(
                                                      text: TextSpan(
                                                        text: '${widget.note}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Tajawal',
                                                            color:
                                                                Colors.red[500],
                                                            fontSize: 16,
                                                            letterSpacing: .3),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text("_ شارك طلب التبرع _",
                                                  style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.grey[800],
                                                      fontSize: 16,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                      onTap: () async {
                                                        if (kIsWeb) {
                                                          showNotification(
                                                              "سيتم اضافة دعم تويتر قريبا للويب",
                                                              _key);
                                                          return;
                                                        }
                                                        // await SocialSharePlugin.shareToTwitterLink(...)
                                                      },
                                                      child: Tab(
                                                        icon: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: Image.asset(
                                                              "assets/72.jpg",
                                                              height: 40,
                                                              width: 40,
                                                            )),
                                                      )),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (kIsWeb) {
                                                        showNotification(
                                                            "سيتم اضافة دعم واتساب قريبا للويب",
                                                            _key);
                                                        return;
                                                      }
                                                      // FlutterShareMe().shareToWhatsApp(...)
                                                    },
                                                    child: Tab(
                                                        icon: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: Image.asset(
                                                              "assets/73.jpg",
                                                              height: 40,
                                                              width: 40,
                                                            ))),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      print("kkkkkkk");

                                                      capturePNG();
                                                    },
                                                    child: Tab(
                                                        icon: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Container(
                                                              color: Colors
                                                                  .cyan[300],
                                                              child:
                                                                  Image.asset(
                                                                "assets/ssch.png",
                                                                color: Colors
                                                                    .black,
                                                                height: 39,
                                                                width: 39,
                                                              ),
                                                            ))),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Opacity(
                                                opacity: .9,
                                                child: Image.asset(
                                                  "assets/fainallogo.png",
                                                  height: 45,
                                                  width: 45,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.postSender == _loggedInUser?.email
                          ? Positioned(
                              left: -28,
                              top: -8,
                              child: MaterialButton(
                                  height: 27,
                                  onPressed: () {
                                    editTlabState(context);
                                  },
                                  color: Colors.red[700],
                                  shape: CircleBorder(),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                            )
                          : Container(),
                      widget.postSender == _loggedInUser?.email
                          ? Positioned(
                              left: -28,
                              top: 30,
                              child: MaterialButton(
                                  height: 27,
                                  onPressed: () {
                                    deleteTlab(context);
                                  },
                                  color: Colors.red[700],
                                  shape: CircleBorder(),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  call() {
    String phoneNumber = "tel:" + (widget.phone ?? "");
    launch(phoneNumber);
  }

  editTlabState(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Center(
              child: Text(
                "تعديل حالة طلب التبرع",
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: Colors.red[900],
                  fontSize: 20,
                ),
              ),
            ),
            elevation: 10,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'مستمر',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    updatePostStateContinue();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'انتهي',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  onPressed: () async {
                    updatePostStateEnd();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  deleteTlab(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Center(
              child: Text(
                "مسح طلب التبرع",
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: Colors.red[900],
                  fontSize: 20,
                ),
              ),
            ),
            elevation: 10,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'تراجع',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'مسح',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    deletePost();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}

showNotification(msg, _key) {
  ScaffoldMessenger.of(_key.currentContext!).showSnackBar(
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

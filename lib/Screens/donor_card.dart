import 'package:flutter/material.dart';

import '../user_model.dart';
import 'donor_profile_screen.dart';

class DonorCard extends StatefulWidget {
  const DonorCard(
      {super.key,
      this.fasila,
      this.address,
      this.governorate,
      this.displayName,
      this.phone,
      this.email,
      this.dateOfDonation,
      this.docId,
      this.isCurrentUser = false});

  final String? fasila;
  final String? address;
  final String? governorate;
  final String? displayName;
  final String? phone;
  final String? email;
  final String? dateOfDonation;
  final String? docId;
  final bool isCurrentUser;

  @override
  DonorCardState createState() => DonorCardState();
}

class DonorCardState extends State<DonorCard> {
  User? _user;

  makeMapForUserInfo() {
    Map<String, dynamic> userMap = {
      'displayName': widget.displayName,
      'email': widget.email,
      'phone': widget.phone,
      'fasila': widget.fasila,
      'address': widget.address,
      'governorate': widget.governorate,
      'dateOfDonation': widget.dateOfDonation
    };
    return User.fromMap(userMap);
  }

  updateInternData() {
    makeMapForUserInfo();
    setState(() {
      var userInfo = makeMapForUserInfo();
      _user = userInfo;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateInternData();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 15, right: 20, left: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: widget.isCurrentUser ? Colors.red[50] : Colors.white,
      child: ListTile(
        leading: Text(
          widget.fasila ?? "",
          textDirection: TextDirection.ltr,
          style: TextStyle(
              color: Colors.red[900],
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DonorProfileScreen(
                        user: _user!,
                        docId: widget.docId,
                      )));
        },
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.address ?? '',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 18),
              ),
              Text(
                widget.displayName ?? "",
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: Colors.grey[700],
                    fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

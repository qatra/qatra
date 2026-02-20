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
      this.docId});

  final String? fasila;
  final String? address;
  final String? governorate;
  final String? displayName;
  final String? phone;
  final String? email;
  final String? dateOfDonation;
  final String? docId;

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: null,
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
                  _buildAddressDisplay(),
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
      ),
    );
  }

  String _buildAddressDisplay() {
    final gov = widget.governorate;
    final addr = widget.address;
    if (gov != null && gov.isNotEmpty) {
      if (addr != null && addr.isNotEmpty) {
        return '$gov - $addr';
      }
      return gov;
    }
    return addr ?? "";
  }
}

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icandoit/helpers/utils_helper.dart';
import 'package:intl/intl.dart' as intl;

import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import '../bloc/post_cubit.dart';
import '../repositories/firebase_repository.dart';

class PostBubble extends StatefulWidget {
  const PostBubble({
    super.key,
    this.name,
    this.fasila,
    this.akias,
    this.government,
    this.city,
    this.phone,
    this.hospital,
    this.date,
    this.note,
    this.postSender,
    this.postColor,
    this.dateThatSignsThePost,
    this.loggedInUser,
  });

  final auth.User? loggedInUser;

  final String? name;
  final String? fasila;
  final String? akias;
  final String? government;
  final String? city;
  final String? phone;
  final String? hospital;
  final String? note;
  final dynamic date;
  final String? postSender;
  final bool? postColor;
  final String? dateThatSignsThePost;

  @override
  PostBubbleState createState() => PostBubbleState();
}

class PostBubbleState extends State<PostBubble> {
  final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;
  bool isExpanded = false;
  changeDateFormat() {
    String formattedDate = intl.DateFormat.yMMMMd('en_US').format(widget.date);
    return formattedDate;
  }

  changeColor() {
    if (widget.postColor == true) {
      return widget.postSender == widget.loggedInUser?.email
          ? Colors.yellow[600]
          : Colors.white;
    }
    return Colors.green[200];
  }

  Future<void> updatePostStateEnd() async {
    await _firebaseRepo.updatePostStatus(widget.dateThatSignsThePost!, false);
    if (mounted) {
      context.read<PostCubit>().fetchPosts(refresh: true);
    }
  }

  Future<void> updatePostStateContinue() async {
    await _firebaseRepo.updatePostStatus(widget.dateThatSignsThePost!, true);
    if (mounted) {
      context.read<PostCubit>().fetchPosts(refresh: true);
    }
  }

  Future<void> deletePost() async {
    await _firebaseRepo.deleteDonationRequest(widget.dateThatSignsThePost!);
    if (mounted) {
      context.read<PostCubit>().fetchPosts(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    String fasilaText = widget.postColor == true
        ? (widget.fasila ?? "")
        : "(طلب التبرع هذا قد تم) ${widget.fasila ?? ""}";

    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedSize(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
          final bool isOwner = widget.postSender == widget.loggedInUser?.email;
          final bool isAdmin = state is AppAuthenticated && state.isAdmin;
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          offset: Offset(0, 0),
                          blurRadius: 6)
                    ],
                    borderRadius: BorderRadius.circular(25),
                    color: changeColor()),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              fontSize: 23,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 30),
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red[700],
                                size: 20,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                              text: "${widget.government} -- ${widget.city}",
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Colors.red[500],
                                  fontSize: 16,
                                  letterSpacing: .3),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 30),
                        child: RichText(
                          textDirection: TextDirection.rtl,
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.local_hospital,
                                color: Colors.red[700],
                                size: 20,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                              text: 'اسم المستشفي :',
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                  letterSpacing: .3),
                            ),
                            TextSpan(
                              text: ' ${widget.hospital}',
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Colors.red[500],
                                  fontSize: 16,
                                  letterSpacing: .3),
                            )
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 30),
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.red[700],
                                size: 20,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                            ),
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              changeDateFormat(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      if (isExpanded)
                        Column(
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
                                                color: Colors.lightBlueAccent,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: SelectableText(
                                                    "${widget.phone}",
                                                    onTap: () {
                                                  if (widget.phone != null &&
                                                      widget.phone!
                                                          .trim()
                                                          .isNotEmpty) {
                                                    makePhoneCall(
                                                        widget.phone!);
                                                  }
                                                },
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                        fontSize: 16,
                                                        letterSpacing: .3)),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.phone,
                                                color: Colors.lightBlueAccent,
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
                                                        letterSpacing: .3)),
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      height: 1,
                                      color: Colors.grey[300],
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
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: 'عدد الأكياس :',
                                                style: TextStyle(
                                                    fontFamily: 'Tajawal',
                                                    color: Colors.grey[800],
                                                    fontSize: 14,
                                                    letterSpacing: .3),
                                              ),
                                              TextSpan(
                                                text: ' ${widget.akias}',
                                                style: TextStyle(
                                                    fontFamily: 'Tajawal',
                                                    color: Colors.red[500],
                                                    fontSize: 16,
                                                    letterSpacing: .3),
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
                                      color: Colors.grey[300],
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
                                                                .grey[800],
                                                            fontSize: 14,
                                                            letterSpacing: .3),
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
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.red[500],
                                                      fontSize: 16,
                                                      letterSpacing: .3),
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      Center(
                        child: AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0.0,
                          // 0.5 turn = 180 degrees
                          duration: const Duration(milliseconds: 300),

                          curve: Curves.easeInOut,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (isOwner || isAdmin) ...[
                Positioned(
                  left: 10,
                  top: 45,
                  child: InkWell(
                      onTap: () {
                        editTlabState(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      )),
                ),
                Positioned(
                  left: 10,
                  top: 82,
                  child: InkWell(
                      onTap: () {
                        deleteTlab(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      )),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  editTlabState(BuildContext context) {
    bool isContinueLoading = false;
    bool isEndLoading = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
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
                    onPressed: (isContinueLoading || isEndLoading)
                        ? null
                        : () async {
                            setDialogState(() => isContinueLoading = true);
                            await updatePostStateContinue();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                    child: isContinueLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'مستمر',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                    onPressed: (isContinueLoading || isEndLoading)
                        ? null
                        : () async {
                            setDialogState(() => isEndLoading = true);
                            await updatePostStateEnd();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                    child: isEndLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'انتهي',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                  ),
                ],
              ),
            );
          });
        });
  }

  deleteTlab(BuildContext context) {
    bool isDeleteLoading = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
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
                    onPressed: isDeleteLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: Text(
                      'تراجع',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
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
                    onPressed: isDeleteLoading
                        ? null
                        : () async {
                            setDialogState(() => isDeleteLoading = true);
                            await deletePost();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                    child: isDeleteLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'مسح',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            );
          });
        });
  }
}

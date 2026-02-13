import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icandoit/wavyyy.dart';
import 'package:intl/intl.dart' as intl;
import '../appBar_widget.dart';
import '../user_model.dart' as model;
import 'user_profile_page.dart';
import 'package:icandoit/message_model.dart';

final _auth = auth.FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;
auth.User? loggedInUser;
String? messageText;

Future<auth.User?> getCurrentUser() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  } catch (e) {
    print(e);
  }
  return null;
}

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageController = TextEditingController();
  late MessageModel messageModel;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
                height: 120,
                child: Wavyyyy(
                  title: "الشات العام  ",
                  backGroundColor: Colors.white,
                  leftIcon: null,
                  onPressedLeft: null,
                  onPressedRight: () {
                    Navigator.pop(context);
                  },
                  directionOfRightIcon: TextDirection.rtl,
                  rightIcon: Icons.arrow_back_ios,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 85),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MessagesStream(),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.only(top: 7),
                            padding: EdgeInsets.only(bottom: 5, left: 3),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 14, left: 16),
                                hintText: 'اكتب هنا',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              controller: messageController,
                              onChanged: (value) {
                                messageText = value;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              backgroundColor: Colors.red[900],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.0, vertical: 4.0),
                            ),
                            // gi

                            onPressed: () {
                              var now = new DateTime.now();
                              setState(() {
                                messageModel = MessageModel(
                                  messageText: messageText,
                                  sender: loggedInUser?.email,
                                  now: now,
                                );
                              });

                              if (messageController.text != "") {
                                _fireStore
                                    .collection("messages")
                                    .doc(now.toString())
                                    .set(messageModel.toMap());

                                messageController.clear();
                              }
                            },
                            child: Text(
                              "Send",
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection("messages")
            .orderBy('date', descending: true)
            .snapshots(),
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
          final messages = snapshot.data!.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final data = message.data() as Map<String, dynamic>;
            final messageText = data["text"];
            final messageSender = data["sender"];
            final date = (data["date"] as Timestamp?)?.toDate();
            final currentUser = loggedInUser?.email;

            final messageBubble = MessageBubble(
              date: date,
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );

            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatefulWidget {
  MessageBubble(
      {required this.sender,
      required this.text,
      required this.isMe,
      this.date});

  final String sender;
  final date;
  final String text;
  final bool isMe;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  model.User? user;

  changeDateFormat() {
    String formattedDate = intl.DateFormat.yMd().add_jm().format(widget.date);
    return formattedDate;
  }

  creatAlertDialog(BuildContext context, senderName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new UserProfile(
                                user: user!,
                              )));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                      size: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        senderName,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            elevation: 10,
            content: Text(
              changeDateFormat(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        });
  }

  Future<model.User> getSenderData() async {
    var _querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: widget.sender)
        .get();

    return model.User.fromMap(_querySnapshot.docs[0].data());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          InkWell(
            onTap: () async {
              var _user = await getSenderData();
              setState(() {
                user = _user;
              });

              creatAlertDialog(context, user?.displayName ?? "Unknown");
            },
            child: Container(
              child: Material(
                borderRadius: widget.isMe
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30))
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30)),
                elevation: 5,
                color: widget.isMe ? Colors.blue : Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Padding(
                    padding: widget.isMe
                        ? const EdgeInsets.only(left: 10)
                        : const EdgeInsets.only(right: 10),
                    child: Text(
                      widget.text,
                      style: TextStyle(
                          fontSize: 15,
                          color: widget.isMe ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

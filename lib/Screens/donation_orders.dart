import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icandoit/Screens/post_bubble.dart';

import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import '../bloc/post_cubit.dart';
import 'donation_request_screen.dart';

final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

class DonationOrders extends StatefulWidget {
  const DonationOrders({super.key});

  @override
  DonationOrdersState createState() => DonationOrdersState();
}

class DonationOrdersState extends State<DonationOrders> {
  final ScrollController _scrollController = ScrollController();

  DonationOrdersState();

  final _fasila = [
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

  void _onDropDownItemSelected(String newValueSelected) {
    context.read<PostCubit>().setFilter(newValueSelected);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PostCubit>().fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        auth.User? loggedInUser;
        if (state is AppAuthenticated) {
          loggedInUser = state.firebaseUser;
        }

        return Scaffold(
            key: _key,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 18, right: 20, left: 20),
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
                    validator: (value) =>
                        value == "حدد فصيلتك" ? 'برجاء اختيار الفصيلة' : null,
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
                      if (newValueSelected != null) {
                        _onDropDownItemSelected(newValueSelected);
                      }
                    },
                    initialValue: context.watch<PostCubit>().state.bloodType,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<PostCubit, PostState>(
                    builder: (context, state) {
                      if (state.error != null) {
                        return SizedBox(
                          height: 150,
                          child: Center(
                            child: SelectableText(
                              "Error: ${state.error}",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                      if (state.posts.isEmpty && state.isLoading) {
                        return SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.red[900],
                            ),
                          ),
                        );
                      }
                      if (state.posts.isEmpty && !state.isLoading) {
                        return const Center(child: Text("لا توجد طلبات"));
                      }

                      final posts = state.posts;
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 15),
                        itemCount:
                            state.hasMore ? posts.length + 1 : posts.length,
                        itemBuilder: (context, index) {
                          if (index >= posts.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                    color: Colors.red[900]),
                              ),
                            );
                          }

                          final post = posts[index];
                          return PostBubble(
                            name: post.get("name"),
                            fasila: post.get("fasila"),
                            akias: post.get("akias"),
                            government: post.get("government"),
                            city: post.get("city"),
                            hospital: post.get("hospital"),
                            phone: post.get("phone"),
                            note: post.get("note"),
                            date: post.get("date")?.toDate(),
                            postSender: post.get("postSender"),
                            postColor: post.get("postColor"),
                            dateThatSignsThePost:
                                post.get("dateThatSignsThePost"),
                            loggedInUser: loggedInUser,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: SizedBox(
              height: 80,
              width: 70,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DonationRequestScreen()));
                },
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/drop.png',
                      width: 70,
                    ),
                    Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}

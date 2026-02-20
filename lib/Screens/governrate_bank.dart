import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icandoit/Screens/donor_card.dart';
import 'package:icandoit/bloc/donor_cubit.dart';
import 'package:icandoit/helpers/utils_helper.dart';

import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import '../user_model.dart';
import 'add_doner_to_bank.dart';
import '../repositories/firebase_repository.dart';

final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;

class GovernrateBank extends StatefulWidget {
  final String governrate;

  const GovernrateBank({super.key, required this.governrate});

  @override
  GovernrateBankState createState() => GovernrateBankState();
}

class GovernrateBankState extends State<GovernrateBank> {
  final GlobalKey<ScaffoldState> _scafold = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = "";

  User? _user;

  final __fasila = [
    ' - عرض كل الفصائل -  ',
    'AB+',
    "AB-",
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
  ];

  void _onDropDownItemSelected(String newValueSelected) {
    context.read<DonorCubit>().setFilter(newValueSelected, widget.governrate);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonorCubit>().fetchDonors(widget.governrate, refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DonorCubit>().fetchDonors(widget.governrate);
    }
  }

  addMyAccToBank() async {
    try {
      auth.User? firebaseUser = _firebaseRepo.currentUser;
      if (firebaseUser != null) {
        await _firebaseRepo.updateUserBank(firebaseUser.uid, widget.governrate);

        if (_user != null) {
          final updatedUser =
              _user!.copyWith(governrateBank: widget.governrate);
          await _firebaseRepo.addDonorToBank(widget.governrate, updatedUser);

          if (mounted) {
            context.read<AppCubit>().updateProfile(updatedUser);
            context
                .read<DonorCubit>()
                .fetchDonors(widget.governrate, refresh: true);
            showNotification("تم اضافة حسابك بنجاح", context);
          }
        }
      }
    } catch (_) {
      if (mounted) {
        showNotification("حدث خطأ ما", context);
      }
    }
  }

  makeUserObject() async {
    final state = context.read<AppCubit>().state;
    if (state is AppAuthenticated && state.userProfile != null) {
      _user = state.userProfile;
      var now = DateTime.now();
      if (_user != null) {
        _user!.date = now;
      }
      addMyAccToBank();
    }
  }

  creatAlertDialog(BuildContext context, city) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(
              child: Text(
                "سيتم اضافتك كمتبرع في محافظة $city",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontFamily: "Tajawal",
                    height: 1.5),
              ),
            ),
            elevation: 10,
            content: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text("تراجع",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "Tajawal")),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        makeUserObject();
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text("موافق",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "Tajawal")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafold,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.governrate,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // _buildAdminSearchField(),
                  const SizedBox(height: 10),
                  _buildBloodTypeFilter(),
                  _buildActionButtons(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            BlocBuilder<DonorCubit, DonorState>(
              builder: (context, state) {
                if (state.error != null) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text("Error: ${state.error}")),
                  );
                }
                if (state.donors.isEmpty && state.isLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.donors.isEmpty && !state.isLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text("لا يوجد متبرعين حتي الان")),
                  );
                }

                return _buildSliverDonorList(state);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildAdminSearchField() {
  //   return BlocBuilder<AppCubit, AppState>(
  //     builder: (context, state) {
  //       if (state is AppAuthenticated && state.isAdmin) {
  //         return Padding(
  //           padding: const EdgeInsets.only(top: 10),
  //           child: TextField(
  //             controller: _searchController,
  //             onChanged: (value) {
  //               setState(() {
  //                 _searchQuery = value.trim();
  //               });
  //             },
  //             decoration: InputDecoration(
  //               isDense: true,
  //               hintText: "بحث بالرقم أو العنوان",
  //               hintStyle: const TextStyle(fontFamily: "Tajawal"),
  //               prefixIcon: Icon(
  //                 Icons.search,
  //                 size: 24,
  //               ),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //       return const SizedBox.shrink();
  //     },
  //   );
  // }

  Widget _buildActionButtons() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final bool isUserInBank = (state is AppAuthenticated) &&
            (state.userProfile?.governrateBank == widget.governrate);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!isUserInBank)
              ElevatedButton(
                onPressed: () {
                  creatAlertDialog(context, widget.governrate);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.red,
                ),
                child: const SizedBox(
                  width: 135,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'اضف حسابك\nالي بنك الدم',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (!isUserInBank) const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddDonerToBank(widget.governrate))).then((_) {
                  if (context.mounted) {
                    context
                        .read<DonorCubit>()
                        .fetchDonors(widget.governrate, refresh: true);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.green,
              ),
              child: const SizedBox(
                width: 135,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'أضف متبرع\nالي بنك الدم',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBloodTypeFilter() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        isDense: true,
        decoration: InputDecoration(
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            prefixIcon: Icon(
              Icons.local_hospital,
              color: Colors.red[900],
              size: 24,
            )),
        validator: (value) =>
            value == "حدد فصيلتك" ? 'برجاء اختيار الفصيلة' : null,
        items: __fasila.map((String dropDownStringItem) {
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
        initialValue: context.watch<DonorCubit>().state.bloodType,
      ),
    );
  }

  Widget _buildSliverDonorList(DonorState state) {
    final usersData = state.donors;
    List<DonorCard> donorsCards = [];
    for (var user in usersData) {
      final data = user.data() as Map<String, dynamic>;
      final displayName = data["displayName"];
      final address = data["address"];
      final governorate = data["governorate"];
      final fasila = data["fasila"];
      final phone = data["phone"];
      final email = data["email"];
      final dateOfDonation = data["dateOfDonation"];

      final messageBubble = DonorCard(
        fasila: fasila,
        address: address,
        governorate: governorate ?? widget.governrate,
        displayName: displayName,
        phone: phone,
        email: email,
        dateOfDonation: dateOfDonation,
        docId: user.id,
      );

      if (_searchQuery.isNotEmpty) {
        final appState = context.read<AppCubit>().state;
        final bool canSearch = appState is AppAuthenticated && appState.isAdmin;

        if (canSearch) {
          final phoneMatch =
              phone != null && phone.toString().contains(_searchQuery);
          final addressMatch = address != null &&
              address
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());

          if (phoneMatch || addressMatch) {
            donorsCards.add(messageBubble);
          }
        } else {
          donorsCards.add(messageBubble);
        }
      } else {
        donorsCards.add(messageBubble);
      }
    }

    if (donorsCards.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: Text(
              "لا يوجد متبرعين حتي الان",
              style: TextStyle(fontSize: 20, fontFamily: "Tajawal"),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= donorsCards.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return donorsCards[index];
        },
        childCount: state.hasMore ? donorsCards.length + 1 : donorsCards.length,
      ),
    );
  }
}

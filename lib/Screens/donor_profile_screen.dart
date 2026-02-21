import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icandoit/helpers/utils_helper.dart';
import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import '../repositories/firebase_repository.dart';
import '../user_model.dart';
import '../bloc/donor_cubit.dart';

final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;

class DonorProfileScreen extends StatefulWidget {
  final User user;
  final String? docId;

  const DonorProfileScreen({super.key, required this.user, this.docId});

  @override
  DonorProfileScreenState createState() => DonorProfileScreenState();
}

class DonorProfileScreenState extends State<DonorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.red[900],
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.red[900],
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  if (state is AppAuthenticated) {
                    final bool isAdmin = state.isAdmin;
                    final bool isOwner =
                        state.firebaseUser.email == widget.user.email;
                    if (isAdmin || isOwner) {
                      return IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => _showDeleteConfirmation(context),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              widget.user.displayName ?? "No Name",
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 27),
//                          textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          UserInfo(
                            user: widget.user,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            const Text("حذف المتبرع", style: TextStyle(fontFamily: "Tajawal")),
        content: const Text("هل أنت متأكد من حذف هذا المتبرع من بنك الدم؟",
            style: TextStyle(fontFamily: "Tajawal")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", style: TextStyle(fontFamily: "Tajawal")),
          ),
          TextButton(
            onPressed: () async {
              if (widget.docId != null && widget.user.governorate != null) {
                await _firebaseRepo.deleteDonorFromBank(
                  widget.user.governorate!,
                  widget.docId!,
                );

                // Sync with user profile if deleting self
                final appCubit = context.read<AppCubit>();
                final appState = appCubit.state;
                if (appState is AppAuthenticated &&
                    appState.firebaseUser.email == widget.user.email) {
                  await _firebaseRepo.removeUserBank(
                      appState.firebaseUser.uid, widget.user.governorate!);

                  final currentUserProfile = appState.userProfile;
                  if (currentUserProfile != null) {
                    final updatedBanks = List<String>.from(
                        currentUserProfile.registeredBanks ?? []);
                    updatedBanks.remove(widget.user.governorate!);
                    appCubit.updateProfile(currentUserProfile.copyWith(
                        registeredBanks: updatedBanks));
                  }
                }

                if (context.mounted) {
                  context
                      .read<DonorCubit>()
                      .fetchDonors(widget.user.governorate!, refresh: true);
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to list
                  showNotification("تم حذف المتبرع بنجاح", context);
                }
              }
            },
            child: const Text("حذف",
                style: TextStyle(color: Colors.red, fontFamily: "Tajawal")),
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  final User user;

  const UserInfo({super.key, required this.user});

  @override
  UserInfoState createState() => UserInfoState();
}

class UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(15),
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 5),
              alignment: Alignment.topLeft,
              child: Text(
                "بيانات المتبرع",
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(
              color: Colors.black38,
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.accessibility_new),
                  title: Text("فصيلة الدم :",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                      )),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.user.fasila ?? "-",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: Colors.red[900],
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("رقم الهاتف :",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                      )),
                  subtitle: SelectableText(widget.user.phone ?? "-", onTap: () {
                    if (widget.user.phone != null) {
                      makePhoneCall(widget.user.phone!);
                    }
                  },
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18)),
                ),
                ListTile(
                  leading: Icon(Icons.my_location),
                  title: Text("العنوان :",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                      )),
                  subtitle: Text(_buildFullAddress(widget.user),
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 19)),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text("البريد الالكتروني :",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                      )),
                  subtitle: Text(widget.user.email ?? "-",
                      style: TextStyle(
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                ListTile(
                    leading: Icon(Icons.person),
                    title: Text("موعد اخر تبرع :",
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                        )),
                    subtitle: Text(widget.user.dateOfDonation ?? "-",
                        style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18))),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _buildFullAddress(User user) {
    final gov = user.governorate;
    final addr = user.address;
    if (gov != null && gov.isNotEmpty) {
      if (addr != null && addr.isNotEmpty) {
        return '$gov - $addr';
      }
      return gov;
    }
    return addr ?? "-";
  }
}

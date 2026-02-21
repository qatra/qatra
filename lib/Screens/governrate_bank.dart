import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icandoit/Screens/donor_card.dart';
import 'package:icandoit/bloc/donor_cubit.dart';
import 'package:icandoit/helpers/utils_helper.dart';
import 'package:icandoit/widgets/fasila_selector.dart';

import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import '../user_model.dart';
import 'add_doner_to_bank.dart';
import 'main_screen.dart';
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
  Timer? _searchDebounce;

  User? _user;

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
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DonorCubit>().fetchDonors(widget.governrate);
    }
  }

  bool _isProfileComplete(User? user) {
    if (user == null) return false;
    // Check for "----" or null/empty
    bool isInvalid(String? value) =>
        value == null || value.isEmpty || value == "----";

    if (isInvalid(user.displayName)) return false;
    if (isInvalid(user.phone)) return false;
    if (isInvalid(user.fasila)) return false;
    if (isInvalid(user.governorate)) return false;
    if (isInvalid(user.address)) return false;

    return true;
  }

  Future<void> addMyAccToBank() async {
    try {
      auth.User? firebaseUser = _firebaseRepo.currentUser;
      if (firebaseUser != null) {
        await _firebaseRepo.updateUserBank(firebaseUser.uid, widget.governrate);

        if (_user != null) {
          List<String> banks = List.from(_user!.registeredBanks ?? []);
          if (!banks.contains(widget.governrate)) banks.add(widget.governrate);
          final updatedUser = _user!.copyWith(registeredBanks: banks);
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

  Future<void> makeUserObject() async {
    final state = context.read<AppCubit>().state;
    if (state is AppAuthenticated && state.userProfile != null) {
      final currentUser = state.userProfile;

      _user = currentUser;
      var now = DateTime.now();
      if (_user != null) {
        _user!.date = now;
      }
      await addMyAccToBank();
    }
  }

  creatAlertDialog(BuildContext context, city) {
    bool isDialogLoading = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
                        onPressed: isDialogLoading
                            ? null
                            : () {
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
                        onPressed: isDialogLoading
                            ? null
                            : () async {
                                setDialogState(() => isDialogLoading = true);
                                await makeUserObject();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        child: Center(
                          child: isDialogLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text("موافق",
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
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildActionButtons(),
                const SizedBox(height: 10),
                _buildAddressSearchField(),
                const SizedBox(height: 10),
                _buildBloodTypeFilter(),
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
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildAddressSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SizedBox(
        // height: 42,
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              // Refresh suffixIcon visibility
            });
            if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
            _searchDebounce = Timer(const Duration(milliseconds: 500), () {
              context
                  .read<DonorCubit>()
                  .setSearchQuery(value.trim(), widget.governrate);
            });
          },
          decoration: InputDecoration(
            isDense: true,
            hintText: "ابحث بالعنوان",
            prefixIcon: Icon(
              Icons.search,
              size: 24,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(end: 5),
                    child: IconButton(
                      icon: const Icon(Icons.clear, size: 24),
                      onPressed: () {
                        _searchController.clear();
                        if (_searchDebounce?.isActive ?? false) {
                          _searchDebounce!.cancel();
                        }
                        context
                            .read<DonorCubit>()
                            .setSearchQuery("", widget.governrate);
                        setState(() {});
                      },
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final bool isUserInBank = (state is AppAuthenticated) &&
              (state.userProfile?.registeredBanks
                      ?.contains(widget.governrate) ??
                  false);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!isUserInBank)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final currentUser =
                          (state as AppAuthenticated).userProfile;
                      if (!_isProfileComplete(currentUser)) {
                        showNotification(
                            "يجب عليك إكمال بياناتك أولاً", context);
                        if (context.mounted) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          MainScreen.changeTabNotifier.value =
                              2; // MyProfilePage is at index 2
                        }
                      } else {
                        creatAlertDialog(context, widget.governrate);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.red,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
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
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddDonerToBank(widget.governrate)))
                        .then((result) {
                      if (result == true && context.mounted) {
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
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
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
      ),
    );
  }

  Widget _buildBloodTypeFilter() {
    final currentFasila = context.watch<DonorCubit>().state.bloodType;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: FasilaSelector(
        selectedFasila: currentFasila,
        onFasilaSelected: (value) {
          _onDropDownItemSelected(value);
        },
        customFasilaList: const [
          ' - عرض كل الفصائل - ',
          'AB+',
          "AB-",
          "A+",
          "A-",
          "B+",
          "B-",
          "O+",
          "O-",
        ],
      ),
    );
  }

  Widget _buildSliverDonorList(DonorState state) {
    final usersData = state.donors;
    List<DonorCard> donorsCards = [];
    final appState = context.read<AppCubit>().state;
    final String? currentUserId =
        appState is AppAuthenticated ? appState.userProfile?.uid : null;

    for (var user in usersData) {
      final data = user.data() as Map<String, dynamic>;
      final displayName = data["displayName"];
      final address = data["address"];
      final governorate = data["governorate"];
      final fasila = data["fasila"];
      final phone = data["phone"];
      final email = data["email"];
      final dateOfDonation = data["dateOfDonation"];

      final bool isCurrentUser =
          currentUserId != null && user.id == currentUserId;

      final messageBubble = DonorCard(
        fasila: fasila,
        address: address,
        governorate: governorate ?? widget.governrate,
        displayName: displayName,
        phone: phone,
        email: email,
        dateOfDonation: dateOfDonation,
        docId: user.id,
        isCurrentUser: isCurrentUser,
      );

      donorsCards.add(messageBubble);
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

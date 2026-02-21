import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../repositories/firebase_repository.dart';
import 'package:icandoit/user_model.dart';
import 'package:icandoit/widgets/fasila_selector.dart';
import '../utils/phone_formatter.dart';
import '../widgets/governorate_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import '../helpers/utils_helper.dart';
import 'login_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  MyProfilePageState createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;

  String? _newPhone;
  String? _newName;
  String? _newAddress;
  String? _newGovernorate;
  String? _newFasila;
  String? _newDateOfDonation;
  final _addressFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  var myFormat = intl.DateFormat('d-MM-yyyy');

  /// Helper: get the current user from cubit state
  User? _getCurrentUser() {
    final state = context.read<AppCubit>().state;
    if (state is AppAuthenticated) return state.userProfile;
    return null;
  }

  /// Helper: update user locally in cubit
  void _updateUserLocally(User updatedUser) {
    context.read<AppCubit>().updateProfile(updatedUser);
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    showNotification(msg, context);
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    String? value,
    bool isOptional = false,
    VoidCallback? onEdit,
    TextDirection valueDirection = TextDirection.rtl,
  }) {
    return ListTile(
      onTap: onEdit,
      minVerticalPadding: 0,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.red[900]),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Tajawal', color: Colors.black, fontSize: 15),
      ),
      subtitle: Text(
        value ?? '',
        textDirection: valueDirection,
        style: TextStyle(
          color: Colors.red[900],
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      trailing: onEdit != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value == null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: Text(isOptional ? '(اختياري)' : ''),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
              ],
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        User? user;
        String? name;
        String? phone;
        String? address;
        String? governorate;
        String? fasila;
        String? dateOfDonation;

        if (state is AppAuthenticated) {
          user = state.userProfile;
          name = user?.displayName;
          phone = user?.phone;
          address = user?.address;
          governorate = user?.governorate;
          fasila = user?.fasila;
          dateOfDonation = user?.dateOfDonation;
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            _buildProfileTile(
                              icon: Icons.person,
                              title: "الاسم :",
                              value: name,
                              onEdit: () => editName(context),
                            ),
                            Divider(),
                            _buildProfileTile(
                              icon: Icons.bloodtype,
                              title: "فصيلة الدم :",
                              value: fasila,
                              onEdit: () => _showFasilaPicker(context),
                            ),
                            Divider(),
                            _buildProfileTile(
                              icon: Icons.phone,
                              title: "رقم الهاتف :",
                              value: phone,
                              onEdit: () => editPhone(context),
                            ),
                            Divider(),
                            _buildProfileTile(
                              icon: Icons.location_city,
                              title: "المحافظة :",
                              value: governorate,
                              onEdit: () => editAddress(context),
                            ),
                            Divider(),
                            _buildProfileTile(
                              icon: Icons.my_location,
                              title: "المنطقة :",
                              value: address,
                              onEdit: () => editAddress(context),
                            ),
                            Divider(),
                            _buildProfileTile(
                              icon: Icons.calendar_today,
                              title: "موعد اخر تبرع :",
                              value: dateOfDonation,
                              isOptional: true,
                              onEdit: () => editDateOfDonation(context),
                            ),
                            Divider(),
                            _buildProfileTile(
                              icon: Icons.email,
                              title: "البريد الالكتروني :",
                              value: user?.email,
                            ),
                            if (user?.registeredBanks != null &&
                                user!.registeredBanks!.isNotEmpty) ...[
                              const Divider(),
                              _buildRegisteredBanksHeader(),
                              _buildRegisteredBanksList(user.registeredBanks!),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () async {
                      await auth.FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.red[900], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "تسجيل الخروج",
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFasilaPicker(BuildContext context) {
    final currentUser = _getCurrentUser();
    final String? currentFasila = currentUser?.fasila;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            title: const Center(
              child: Text(
                "تعديل فصيلة الدم",
                style: TextStyle(
                    fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FasilaSelector(
                  selectedFasila: currentFasila,
                  onFasilaSelected: (fasila) async {
                    if (isLoading) return;
                    setDialogState(() => isLoading = true);
                    _newFasila = fasila;
                    try {
                      await upFasila();
                      final updated = currentUser?.copyWith(fasila: fasila);
                      if (updated != null) _updateUserLocally(updated);
                      if (context.mounted) {
                        Navigator.pop(context);
                        showNotification('تم تحديث البيانات بنجاح', context);
                      }
                    } catch (_) {
                      setDialogState(() => isLoading = false);
                    }
                  },
                ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        });
      },
    );
  }

  editName(BuildContext context) {
    final currentUser = _getCurrentUser();
    _newName = currentUser?.displayName ?? "---";
    bool isLoading = false;
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setDialogState) {
            return AlertDialog(
                backgroundColor: Colors.white,
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!(_nameFormKey.currentState?.validate() ??
                                false)) return;
                            setDialogState(() => isLoading = true);
                            try {
                              await uploadName();
                              final updated =
                                  currentUser?.copyWith(displayName: _newName);
                              if (updated != null) _updateUserLocally(updated);
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                              showNotification(
                                  'تم تحديث البيانات بنجاح', context);
                            } catch (_) {
                              setDialogState(() => isLoading = false);
                              _showSnackBar("حدث خطأ أثناء تعديل الاسم",
                                  isError: true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.green,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'حفظ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                title: Center(
                  child: Text(
                    "تعديل الاسم",
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.red[900],
                      fontSize: 20,
                    ),
                  ),
                ),
                titlePadding: EdgeInsets.only(bottom: 5, top: 15),
                elevation: 10,
                content: Form(
                  key: _nameFormKey,
                  child: TextFormField(
                    initialValue: _newName,
                    validator: (text) {
                      if (text == null || text.trim() == "") {
                        return "الاسم لا يمكن ان يكون فارغة .";
                      }
                      if (text.length < 2) {
                        return "الاسم قصير جدا";
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    onChanged: (text) {
                      _newName = text;
                    },
                    decoration: InputDecoration(
                      hintText: "الاسم",
                      labelStyle: TextStyle(
                        fontFamily: 'Tajawal',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  uploadName() async {
    auth.User? firebaseUser = _firebaseRepo.currentUser;
    if (firebaseUser == null) return;

    final userData = await _firebaseRepo.getUserProfile(firebaseUser.uid);
    if (userData != null) {
      final banks = userData.registeredBanks;
      if (banks != null) {
        for (final bank in banks) {
          await _firebaseRepo.updateDonorInBank(
              firebaseUser.uid, bank, {'displayName': _newName});
        }
      }
    }

    await _firebaseRepo
        .updateUserProfile(firebaseUser.uid, {'displayName': _newName});
  }

  Future<void> upFasila() async {
    final currentUser = _getCurrentUser();
    try {
      await uploadFasila();
      final updated = currentUser?.copyWith(fasila: _newFasila);
      if (updated != null) _updateUserLocally(updated);
      _showSnackBar("تم تعديل فصيلة الدم بنجاح");
    } catch (_) {
      _showSnackBar("حدث خطأ أثناء تعديل الفصيلة", isError: true);
    }
  }

  uploadFasila() async {
    auth.User? firebaseUser = _firebaseRepo.currentUser;
    if (firebaseUser == null) return;

    final userData = await _firebaseRepo.getUserProfile(firebaseUser.uid);
    if (userData != null) {
      final banks = userData.registeredBanks;
      if (banks != null) {
        for (final bank in banks) {
          await _firebaseRepo.updateDonorInBank(
              firebaseUser.uid, bank, {'fasila': _newFasila});
        }
      }
    }

    await _firebaseRepo
        .updateUserProfile(firebaseUser.uid, {'fasila': _newFasila});
  }

  editPhone(BuildContext context) {
    final currentUser = _getCurrentUser();
    _newPhone = currentUser?.phone ?? "---";
    bool isLoading = false;
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setDialogState) {
            return AlertDialog(
                backgroundColor: Colors.white,
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!(_phoneFormKey.currentState?.validate() ??
                                false)) return;
                            setDialogState(() => isLoading = true);
                            try {
                              await uploadPhone();
                              final updated =
                                  currentUser?.copyWith(phone: _newPhone);
                              if (updated != null) _updateUserLocally(updated);
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                              _showSnackBar("تم تعديل رقم الهاتف بنجاح");
                            } catch (_) {
                              setDialogState(() => isLoading = false);
                              _showSnackBar("حدث خطأ أثناء تعديل رقم الهاتف",
                                  isError: true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.green,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'حفظ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                title: Center(
                  child: Text(
                    "تعديل رقم الموبايل",
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.red[900],
                      fontSize: 20,
                    ),
                  ),
                ),
                titlePadding: EdgeInsets.only(bottom: 5, top: 15),
                elevation: 10,
                content: Form(
                  key: _phoneFormKey,
                  child: TextFormField(
                    initialValue: _newPhone == "---" ? "" : _newPhone,
                    textDirection: TextDirection.rtl,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "برجاء كتابة رقم الهاتف جديد";
                      } else if (text.length != 11) {
                        return "رقم الهاتف غير صحيح";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [EnglishNumeralsFormatter()],
                    textAlign: TextAlign.center,
                    onChanged: (text) {
                      _newPhone = text;
                    },
                    decoration: InputDecoration(
                      hintText: "رقم الموبايل",
                      labelStyle: TextStyle(
                        fontFamily: 'Tajawal',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  uploadPhone() async {
    auth.User? firebaseUser = _firebaseRepo.currentUser;
    if (firebaseUser == null) return;

    final userData = await _firebaseRepo.getUserProfile(firebaseUser.uid);

    if (userData != null) {
      final banks = userData.registeredBanks;
      if (banks != null) {
        for (final bank in banks) {
          await _firebaseRepo.updateDonorInBank(
              firebaseUser.uid, bank, {'phone': _newPhone ?? ''});
        }
      }
    }

    await _firebaseRepo
        .updateUserProfile(firebaseUser.uid, {'phone': _newPhone});
  }

  editAddress(BuildContext context) {
    final currentUser = _getCurrentUser();
    _newGovernorate = currentUser?.governorate ?? "---";
    _newAddress = currentUser?.address ?? "---";
    bool isLoading = false;
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setDialogState) {
            return AlertDialog(
                backgroundColor: Colors.white,
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!(_addressFormKey.currentState?.validate() ??
                                false)) return;
                            setDialogState(() => isLoading = true);
                            try {
                              await uploadAddressFB();
                              final updated = currentUser?.copyWith(
                                address: _newAddress,
                                governorate: _newGovernorate,
                              );
                              if (updated != null) _updateUserLocally(updated);
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                              showNotification(
                                  'تم تحديث العنوان بنجاح', context);
                            } catch (e) {
                              setDialogState(() => isLoading = false);
                              _showSnackBar("حدث خطأ أثناء تعديل العنوان",
                                  isError: true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.green,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'حفظ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                title: Center(
                  child: Text(
                    "تعديل العنوان",
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.red[900],
                      fontSize: 20,
                    ),
                  ),
                ),
                titlePadding: EdgeInsets.only(bottom: 5, top: 15),
                elevation: 10,
                content: Form(
                  key: _addressFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GovernorateSelector(
                        selectedGovernorate: _newGovernorate ?? "---",
                        isShowIcon: false,
                        onGovernorateSelected: (value) {
                          setDialogState(() {
                            _newGovernorate = value;
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == "---") {
                            return "برجاء اختيار المحافظة";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        initialValue: _newAddress,
                        validator: (text) {
                          if (text == null || text.isEmpty || text == "---") {
                            return "برجاء كتابة المنطقة الجديدة";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          _newAddress = text;
                        },
                        decoration: InputDecoration(
                          hintText: "المنطقة",
                          labelStyle: const TextStyle(
                            fontFamily: 'Tajawal',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  uploadAddressFB() async {
    auth.User? firebaseUser = _firebaseRepo.currentUser;
    if (firebaseUser == null) return;

    Map<String, dynamic> updateData = {};
    if (_newAddress != null) updateData['address'] = _newAddress;
    if (_newGovernorate != null) updateData['governorate'] = _newGovernorate;

    if (updateData.isNotEmpty) {
      final userData = await _firebaseRepo.getUserProfile(firebaseUser.uid);
      if (userData != null) {
        final banks = userData.registeredBanks;
        if (banks != null) {
          for (final bank in banks) {
            await _firebaseRepo.updateDonorInBank(
                firebaseUser.uid, bank, updateData);
          }
        }
      }
      await _firebaseRepo.updateUserProfile(firebaseUser.uid, updateData);
    }
  }

  editDateOfDonation(BuildContext context) {
    final currentUser = _getCurrentUser();
    String currentDateOfDonation = currentUser?.dateOfDonation ?? "---";
    _newDateOfDonation = currentDateOfDonation;
    bool isLoading = false;
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setDialogState) {
            return AlertDialog(
                backgroundColor: Colors.white,
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setDialogState(() => isLoading = true);
                            try {
                              await uploadDateOfDonation();
                              final dateStr = myFormat.format(selectedDate);
                              final updated = currentUser?.copyWith(
                                  dateOfDonation: dateStr);
                              if (updated != null) _updateUserLocally(updated);
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                              _showSnackBar("تم تعديل تاريخ اخر تبرع بنجاح");
                            } catch (_) {
                              setDialogState(() => isLoading = false);
                              _showSnackBar("حدث خطأ أثناء تعديل تاريخ التبرع",
                                  isError: true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.green,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'حفظ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                title: Center(
                  child: Text(
                    "تعديل تاريخ اخر تبرع",
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.red[900],
                      fontSize: 20,
                    ),
                  ),
                ),
                titlePadding: EdgeInsets.only(bottom: 5, top: 15),
                elevation: 10,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "التاريخ الحالي: $currentDateOfDonation",
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _newDateOfDonation == "---"
                              ? "اختار التاريخ"
                              : _newDateOfDonation ?? '---',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                            context: dialogContext,
                            locale: const Locale('ar'),
                            initialDate: selectedDate,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime.now());
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                            _newDateOfDonation = myFormat.format(picked);
                          });
                        }
                      },
                    ),
                  ],
                ));
          });
        });
  }

  uploadDateOfDonation() async {
    auth.User? firebaseUser = _firebaseRepo.currentUser;
    if (firebaseUser == null) return;

    final userData = await _firebaseRepo.getUserProfile(firebaseUser.uid);

    if (userData != null) {
      final banks = userData.registeredBanks;

      if (banks != null) {
        for (final bank in banks) {
          await _firebaseRepo.updateDonorInBank(firebaseUser.uid, bank,
              {'dateOfDonation': myFormat.format(selectedDate)});
        }
      }
    }

    await _firebaseRepo.updateUserProfile(
        firebaseUser.uid, {'dateOfDonation': myFormat.format(selectedDate)});
  }

  Widget _buildRegisteredBanksHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.account_balance, color: Colors.red[900], size: 20),
          const SizedBox(width: 10),
          const Text(
            "المحافظات المشترك في بنكها :",
            style: TextStyle(
                fontFamily: 'Tajawal', color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisteredBanksList(List<String> banks) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: banks.map((bank) {
        bool isDeleting = false;
        return StatefulBuilder(builder: (context, setChipState) {
          return Chip(
            backgroundColor: Colors.red[50],
            label: Text(
              bank,
              style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: Colors.red[900],
                  fontWeight: FontWeight.bold),
            ),
            deleteIcon: isDeleting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                : const Icon(Icons.cancel, size: 18, color: Colors.red),
            onDeleted: isDeleting
                ? null
                : () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("تأكيد الحذف",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontFamily: 'Tajawal')),
                        content: Text(
                            "هل انت متأكد من حذف تسجيلك في بنك $bank؟",
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontFamily: 'Tajawal')),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("تراجع")),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("حذف",
                                  style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      setChipState(() => isDeleting = true);
                      await _deleteBankRegistration(bank);
                    }
                  },
          );
        });
      }).toList(),
    );
  }

  Future<void> _deleteBankRegistration(String governrate) async {
    final user = _getCurrentUser();
    if (user == null || user.uid == null) return;

    try {
      await _firebaseRepo.deleteDonorFromBank(governrate, user.uid!);
      await _firebaseRepo.removeUserBank(user.uid!, governrate);

      final updatedBanks = List<String>.from(user.registeredBanks ?? []);
      updatedBanks.remove(governrate);
      _updateUserLocally(user.copyWith(registeredBanks: updatedBanks));

      _showSnackBar("تم حذف التسجيل بنجاح");
    } catch (e) {
      debugPrint("Error deleting bank registration: $e");
      _showSnackBar("حدث خطأ أثناء حذف التسجيل", isError: true);
    }
  }
}

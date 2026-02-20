class User {
  String? displayName;
  String? email;
  String? uid;
  String? phone;
  String? fasila;
  String? address;
  String? governorate;
  String? governrateBank;
  String? dateOfDonation;
  String? imageUrl;
  dynamic date;

  User(
      {this.displayName,
      this.email,
      this.uid,
      this.phone,
      this.fasila,
      this.address,
      this.governorate,
      this.governrateBank,
      this.imageUrl,
      this.dateOfDonation,
      this.date});

  factory User.fromMap(Map<String, dynamic> map) => User(
        displayName: map['displayName'],
        email: map['email'],
        uid: map['uid'],
        phone: map['phone'],
        fasila: map['fasila'],
        address: map['address'],
        governorate: map['governorate'],
        governrateBank: map['governrateBank'],
        imageUrl: map['imageUrl'],
        dateOfDonation: map['dateOfDonation'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'displayName': displayName,
        'email': email,
        'uid': uid,
        'phone': phone,
        'fasila': fasila,
        'address': address,
        'governorate': governorate,
        'governrateBank': governrateBank,
        'imageUrl': imageUrl,
        'dateOfDonation': dateOfDonation,
        'date': date,
      };

  User copyWith({
    String? displayName,
    String? email,
    String? uid,
    String? phone,
    String? fasila,
    String? address,
    String? governorate,
    String? governrateBank,
    String? imageUrl,
    String? dateOfDonation,
    dynamic date,
  }) {
    return User(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      fasila: fasila ?? this.fasila,
      address: address ?? this.address,
      governorate: governorate ?? this.governorate,
      governrateBank: governrateBank ?? this.governrateBank,
      imageUrl: imageUrl ?? this.imageUrl,
      dateOfDonation: dateOfDonation ?? this.dateOfDonation,
      date: date ?? this.date,
    );
  }
}

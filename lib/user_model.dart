class User {
  String? displayName;
  String? email;
  String? uid;
  String? phone;
  String? fasila;
  String? address;
  String? dateOfDonation;
  String? imageUrl;
  var date;

  User(
      {this.displayName,
      this.email,
      this.uid,
      this.phone,
      this.fasila,
      this.address,
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
        'imageUrl': imageUrl,
        'dateOfDonation': dateOfDonation,
        'date': date,
      };
}

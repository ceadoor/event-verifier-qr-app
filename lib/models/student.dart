class Student {

  final bool status;
  final String message;
  final Map<String,dynamic> user;


  Student({this.status, this.message, this.user});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      status: json['status'],
      message: json['promoCode'],
      user: json['brand'],
    );
  }
}
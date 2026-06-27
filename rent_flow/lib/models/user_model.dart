class UserModel {

  String _id;
  String _email;
  String _name;
  String _phone;
  String _bankName;
  String _bankAccountNumber;

  UserModel({
    required String id,
    required String email,
    required String name,
    required String phone,
    String bankName = '',
    String bankAccountNumber = '',
  }) : _id = id,
    _email = email,
    _name = name,
    _phone = phone,
    _bankName = bankName,
    _bankAccountNumber = bankAccountNumber;

  String get id => _id;
  String get email => _email;
  String get name => _name;
  String get phone => _phone;
  String get bankName => _bankName;
  String get bankAccountNumber => _bankAccountNumber;

  set name(String value){
    if(value.trim().isEmpty) throw Exception("Name cannot be empty!");
    _name = value;
  }

  set phone(String value){
    if(value.trim().isEmpty || value.length != 10) throw Exception("Invalid phone number!");
    _phone = value;
  }

  set bankName(String value){
    _bankName = value;
  }

  set bankAccountNumber(String value){
    _bankAccountNumber = value;
  }
}
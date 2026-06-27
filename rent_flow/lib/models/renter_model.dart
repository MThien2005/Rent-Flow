class RenterModel {
  String _id;
  String _name;
  String _phone;
  String _cccd;
  String _permanentAddress;
  bool _isValid;

  RenterModel({
    required String id,
    required String name, 
    required String phone, 
    required String cccd, 
    required String permanentAddress, 
    bool isValid = true
  }) : _id = id,
      _name = name,
      _phone = phone,
      _cccd = cccd,
      _permanentAddress = permanentAddress,
      _isValid = isValid;
  
  String get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get cccd => _cccd;
  String get permanentAddress => _permanentAddress;
  bool get isValid => _isValid;

  set name(String value){
    if(value.trim().isEmpty) throw Exception("Name cannot be empty!");
    _name = value;
  }

  set phone(String value){
    if(value.trim().isEmpty || value.length != 10) throw Exception("Invalid phone number!");
    _phone = value;
  }

  set cccd(String value){
    if(value.trim().isEmpty || value.length != 12 ) throw Exception("Invalid CCCD!");
    _cccd = value;
  }

  set permanentAddress(String value){
    if(value.trim().isEmpty) throw Exception("Permanent address cannot be empty!");
    _permanentAddress = value;
  }

  void checkout() => _isValid = false;
}
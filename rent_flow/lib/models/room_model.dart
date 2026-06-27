class RoomModel {
  String _id;
  String _houseId;
  String _name;
  double _price;
  bool _isRented;
  int _lastElectricIndex;
  int _lastWaterIndex;

  RoomModel({
    required String id,
    required String houseId,
    required String name, 
    required double price, 
    bool isRented = false,
    int lastElectricIndex = 0,
    int lastWaterIndex = 0,
  }) : _id = id,
      _houseId = houseId,
      _name = name,
      _price = price,
      _isRented = isRented,
      _lastElectricIndex = lastElectricIndex,
      _lastWaterIndex = lastWaterIndex;

  String get id => _id;
  String get houseId => _houseId;
  String get name => _name;
  double get price => _price;
  bool get isRented => _isRented;
  int get lastElectricIndex => _lastElectricIndex;
  int get lastWaterIndex => _lastWaterIndex;

  set name (String value){
    if(value.trim().isEmpty) throw Exception("Name room canot be empty!");
    _name = value;
  }

  set price (double value){
    if(value < 0) throw Exception("Error: Room price cannot be negative!");
    _price = value;
  }

  set lastElectricIndex (int value){
    if(value < 0) throw Exception("Error: LastElectricIndex cannot be negative!");
    _lastElectricIndex = value;
  }

  set lastWaterIndex (int value){
    if(value < 0) throw Exception("Error: lastWaterIndex cannot be negative!");
    _lastWaterIndex = value;
  }

  void toggleStatus(){
    _isRented = !_isRented;
  }

}
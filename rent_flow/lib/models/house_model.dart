class HouseModel {

  String _id;
  String _name;
  String _address;
  int _roomCount;

  HouseModel({required String id, required String name, required String address, int roomCount = 0 })
            : _id = id,
            _name = name,
            _address = address,
            _roomCount = roomCount;
  
  String get id => _id;
  String get name => _name;
  String get address => _address;
  int get roomCount => _roomCount;

  set name(String value){
    if(value.trim().isEmpty) throw Exception("Name house cannot be empty!");
    _name = value;
  }

  set address(String value){
    if(value.trim().isEmpty) throw Exception("Address cannot be empty!");
    _address = value;
  }

  void increaseRoomCount(){
    _roomCount++;
  }

  void decreaseRoomCount(){
    if(_roomCount > 0){
      _roomCount--;
    }else{
      print("Error: The number of rooms cannot be less than 0!");
    }
  }


}
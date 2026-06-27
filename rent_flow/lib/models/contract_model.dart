class ContractModel {

  String _id;
  String _roomId;
  String _renterId;
  double _deposit;
  DateTime _startDate;
  bool _isValid;

  ContractModel({
    required String id,
    required String roomId,
    required String renterId,
    required double deposit,
    required DateTime startDate,
    bool isValid = true,
  }) : _id = id,
    _roomId = roomId,
    _renterId = renterId,
    _deposit = deposit,
    _startDate = startDate,
    _isValid = isValid;

  String get id => _id;
  String get roomId => _roomId;
  String get renterId => _renterId;
  double get deposit => _deposit;
  DateTime get startDate => _startDate;
  bool get isValid => _isValid;

  set deposit(double value){
    if(value < 0) throw Exception("Deposit cannot be negative!");
    _deposit = value;
  }

  void terminateContract() => _isValid = false;
}
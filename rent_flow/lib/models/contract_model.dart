class ContractModel {
  String _id;
  String _roomId;
  String _renterId;
  double _deposit;
  DateTime _startDate;
  bool _isValid;

  // 📌 1. THÊM CÁC BIẾN LƯU THỎA THUẬN GIÁ CẢ
  double _elecUnitPrice;
  double _waterUnitPrice;
  double _serviceFee;

  ContractModel({
    required String id,
    required String roomId,
    required String renterId,
    required double deposit,
    required DateTime startDate,
    // 📌 2. BẮT BUỘC TRUYỀN VÀO KHI TẠO HỢP ĐỒNG (Chủ trọ tự nhập)
    required double elecUnitPrice,
    required double waterUnitPrice,
    required double serviceFee,
    bool isValid = true,
  }) : _id = id,
    _roomId = roomId,
    _renterId = renterId,
    _deposit = deposit,
    _startDate = startDate,
    _elecUnitPrice = elecUnitPrice,
    _waterUnitPrice = waterUnitPrice,
    _serviceFee = serviceFee,
    _isValid = isValid;

  // ... (Giữ nguyên các getter cũ) ...
  String get id => _id;
  String get roomId => _roomId;
  String get renterId => _renterId;
  double get deposit => _deposit;
  DateTime get startDate => _startDate;
  bool get isValid => _isValid;

  // 📌 3. THÊM GETTER CHO CÁC GIÁ TRỊ MỚI
  double get elecUnitPrice => _elecUnitPrice;
  double get waterUnitPrice => _waterUnitPrice;
  double get serviceFee => _serviceFee;

  set deposit(double value){
    if(value < 0) throw Exception("Deposit cannot be negative!");
    _deposit = value;
  }

  // 📌 4. THÊM SETTER ĐỂ CHẶN LỖI NHẬP SỐ ÂM
  set elecUnitPrice(double value){
    if(value < 0) throw Exception("Giá điện không được âm!");
    _elecUnitPrice = value;
  }

  set startDate(DateTime value){
    _startDate = value;
  } 
  set waterUnitPrice(double value){
    if(value < 0) throw Exception("Giá nước không được âm!");
    _waterUnitPrice = value;
  }

  set serviceFee(double value){
    if(value < 0) throw Exception("Phí dịch vụ không được âm!");
    _serviceFee = value;
  }

  void terminateContract() => _isValid = false;
}
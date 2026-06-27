abstract class FeeItem{
  String _name;
  double _amount;

  FeeItem(this._name, this._amount);

  String get name => _name;
  double get amount => _amount;

  void calculate();
}

class FixedFee extends FeeItem{
  String _description;
  FixedFee({
    required String name,
    required double amount,
    String description = '',
  }) : _description = description,
      super(name, amount);

  String get description => _description;

  @override
  void calculate(){

  }
}

class UtilityFee extends FeeItem{
  int _oldIndex;
  int _newIndex;
  double _unitPrice;
  
  UtilityFee({
    required String name,
    required int oldIndex,
    required int newIndex,
    required double unitPrice,
  }) : _oldIndex = oldIndex,
    _newIndex = newIndex,
    _unitPrice = unitPrice,
    super(name, 0);
  
  int get oldIndex => _oldIndex;
  int get newIndex => _newIndex;
  double get unitPrice => _unitPrice;

  @override
  void calculate(){
    if(_newIndex < _oldIndex) throw Exception("The new meter reading cannot be less than the previous meter reading!");
    _amount = (_newIndex - _oldIndex) * _unitPrice;
  }
}

class QuantityFee extends FeeItem{
  double _quantity;
  double _unitPrice;
  String _unit;

  QuantityFee({
    required String name,
    required double quantity,
    required double unitPrice,
    required String unit,
  }) : _quantity = quantity,
      _unitPrice = unitPrice,
      _unit = unit,
      super(name, 0);
  
  double get quantity => _quantity;
  double get unitPrice => _unitPrice;
  String get unit => _unit;

  @override
  void calculate() => _amount = _quantity * _unitPrice;
}

class DiscountFee extends FeeItem{
  String _reason;
  double _discountValue;

  DiscountFee({
    required String name,
    required String reason,
    required double discountValue,
  }) : _reason = reason,
      _discountValue = discountValue,
      super(name, 0);
  
  String get reason =>_reason;
  double get discountValue => _discountValue;

  @override
  void calculate() => _amount = -_discountValue;
}

class BillModel {
  String _id;
  String _contractId;
  String _monthYear;
  List<FeeItem> _fees;
  double _totalAmount;
  double _paidAmount;
  bool _isPaid;

  BillModel({
    required String id,
    required String contractId,
    required String monthYear,
    List<FeeItem>? fees,
    double paidAmount = 0,
  }) : _id = id,
      _contractId = contractId,
      _monthYear = monthYear,
      _fees = fees ?? [],
      _totalAmount = 0,
      _paidAmount = paidAmount,
      _isPaid = false{
        calculateTotal();
      }
  
  String get id => _id;
  String get contractId => _contractId;
  String get monthYear => _monthYear;
  List<FeeItem> get fees => _fees;
  double get totalAmount => _totalAmount;
  double get paidAmount => _paidAmount;
  bool get isPaid => _isPaid;

  double get remainingAmount => _totalAmount - _paidAmount;

  void addFee(FeeItem fee){
    _fees.add(fee);
    calculateTotal();
  }

  void calculateTotal(){
    _totalAmount = 0;
    for(var fee in _fees){
      fee.calculate();
      _totalAmount += fee.amount;
    }
    _checkPaidStatus();
  }

  void pay(double amount){
    if(amount <= 0) throw Exception("Payment amount must be greater than 0!");
    _paidAmount += amount;
    _checkPaidStatus();
  }

  void _checkPaidStatus(){
    _isPaid = _paidAmount >= _totalAmount;
  }
}
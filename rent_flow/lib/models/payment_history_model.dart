class PaymentHistoryModel {

  String _id;
  String _billId;
  double _amount;
  DateTime _payDate;
  String _method;

  PaymentHistoryModel({
    required String id,
    required String billId,
    required double amount,
    required DateTime payDate,
    String method = 'Tiền mặt',
  }) : _id = id,
    _billId = billId,
    _amount = amount,
    _payDate = payDate,
    _method = method;
  
  String get id => _id;
  String get billId => _billId;
  double get amount => _amount;
  DateTime get payDate => _payDate;
  String get method => _method;

  set amount(double value){
    if(value <= 0) throw Exception("Amount must be greater than zero!");
    _amount = value;
  }

  set method(String value){
    if(value.trim().isEmpty) throw Exception("Method cannot be empty!");
    _method = value;
  }
}
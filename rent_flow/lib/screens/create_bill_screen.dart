import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rent_flow/models/bill_model.dart';
import 'package:rent_flow/models/room_model.dart';
import 'package:rent_flow/models/contract_model.dart';
import 'package:rent_flow/screens/bill_detail_screen.dart';

// 📌 1. CLASS FORMATTER
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    
    String cleanText = newValue.text.replaceAll('.', '');
    cleanText = cleanText.replaceFirst(RegExp(r'^0+'), '');
    if (cleanText.isEmpty) cleanText = '0';

    final intValue = int.tryParse(cleanText);
    if (intValue == null) return oldValue;
    
    final formatted = NumberFormat.decimalPattern('vi_VN').format(intValue);
    
    int selectionIndex = newValue.selection.end;
    if (selectionIndex > formatted.length) {
      selectionIndex = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// 📌 2. CLASS QUẢN LÝ DỮ LIỆU ĐỘNG (Dành cho thêm nhiều khoản phí)
class DynamicFeeItem {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void dispose() {
    nameController.dispose();
    amountController.dispose();
  }
}

class CreateBillScreen extends StatefulWidget {
  final RoomModel room;
  final ContractModel contract;

  const CreateBillScreen({super.key, required this.room, required this.contract});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _newElecController;
  late TextEditingController _elecPriceController;
  
  late TextEditingController _newWaterController;
  late TextEditingController _waterPriceController;
  
  late TextEditingController _serviceFeeController;

  // 📌 3. DANH SÁCH CHỨA CÁC KHOẢN PHÍ & GIẢM GIÁ (Có thể thêm/xóa vô hạn)
  List<DynamicFeeItem> customFees = [];
  List<DynamicFeeItem> customDiscounts = [];

  @override
  void initState() {
    super.initState();
    _newElecController = TextEditingController();
    _newWaterController = TextEditingController();
    _elecPriceController = TextEditingController(text: NumberFormat.decimalPattern('vi_VN').format(widget.contract.elecUnitPrice));
    _waterPriceController = TextEditingController(text: NumberFormat.decimalPattern('vi_VN').format(widget.contract.waterUnitPrice));
    _serviceFeeController = TextEditingController(text: NumberFormat.decimalPattern('vi_VN').format(widget.contract.serviceFee));
    
  }

  @override
  void dispose() {
    _newElecController.dispose();
    _elecPriceController.dispose();
    _newWaterController.dispose();
    _waterPriceController.dispose();
    _serviceFeeController.dispose();
    
    // Xóa bộ nhớ của các danh sách động
    for (var item in customFees) { item.dispose(); }
    for (var item in customDiscounts) { item.dispose(); }
    
    super.dispose();
  }

  double _parseAmount(String text) {
    if (text.trim().isEmpty) return 0;
    return double.tryParse(text.replaceAll('.', '')) ?? 0;
  }

  void _generateBill() {
    if (_formKey.currentState!.validate()) {
      try {
        int newElec = int.tryParse(_newElecController.text.trim()) ?? 0;
        double elecPrice = _parseAmount(_elecPriceController.text);
        
        int newWater = int.tryParse(_newWaterController.text.trim()) ?? 0;
        double waterPrice = _parseAmount(_waterPriceController.text);
        
        double serviceFee = _parseAmount(_serviceFeeController.text);

        if (_newElecController.text.isNotEmpty && newElec < widget.room.lastElectricIndex) {
          throw Exception("Số điện mới không được nhỏ hơn số cũ!");
        }
        if (_newWaterController.text.isNotEmpty && newWater < widget.room.lastWaterIndex) {
          throw Exception("Số nước mới không được nhỏ hơn số cũ!");
        }

        final newBill = BillModel(
          id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
          contractId: widget.contract.id,
          monthYear: 'T.${DateTime.now().month}, ${DateTime.now().year}',
        );

        newBill.addFee(FixedFee(
          name: 'Tiền thuê phòng', 
          amount: widget.room.price * 1000000, 
          description: '1 tháng'
        ));

        if (_newElecController.text.isNotEmpty && newElec > widget.room.lastElectricIndex) {
          newBill.addFee(UtilityFee(name: 'Tiền điện', oldIndex: widget.room.lastElectricIndex, newIndex: newElec, unitPrice: elecPrice));
        }

        if (_newWaterController.text.isNotEmpty && newWater > widget.room.lastWaterIndex) {
          newBill.addFee(UtilityFee(name: 'Tiền nước', oldIndex: widget.room.lastWaterIndex, newIndex: newWater, unitPrice: waterPrice));
        }

        if (serviceFee > 0) {
          newBill.addFee(FixedFee(name: 'Phí dịch vụ', amount: serviceFee, description: 'Rác, Wifi...'));
        }

        // 📌 XỬ LÝ LƯU TẤT CẢ PHÍ TÙY CHỈNH
        for (var item in customFees) {
          double customAmount = _parseAmount(item.amountController.text);
          if (item.nameController.text.isNotEmpty && customAmount > 0) {
            newBill.addFee(FixedFee(name: item.nameController.text.trim(), amount: customAmount));
          }
        }

        // 📌 XỬ LÝ LƯU TẤT CẢ GIẢM GIÁ
        for (var item in customDiscounts) {
          double discountAmount = _parseAmount(item.amountController.text);
          if (discountAmount > 0) {
            newBill.addFee(DiscountFee(
              name: 'Giảm giá / Khấu trừ', 
              reason: item.nameController.text.trim().isEmpty ? 'Điều chỉnh hóa đơn' : item.nameController.text.trim(), 
              discountValue: discountAmount
            ));
          }
        }
        
        // TODO: Gọi lệnh update widget.room lên Firebase tại đây để lưu vào database

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BillDetailScreen(bill: newBill, room: widget.room, contract: widget.contract,)),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", "")), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nhập Chỉ Số Tháng Này', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSectionHeader('ĐIỆN (Số cũ: ${widget.room.lastElectricIndex})'),
            Row(
              children: [
                Expanded(child: _buildTextField(controller: _newElecController, label: 'Số điện MỚI', icon: Icons.bolt, isNumber: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(controller: _elecPriceController, label: 'Đơn giá (đ)', icon: Icons.money, isCurrency: true)),
              ],
            ),
            const SizedBox(height: 32),

            _buildSectionHeader('NƯỚC (Số cũ: ${widget.room.lastWaterIndex})'),
            Row(
              children: [
                Expanded(child: _buildTextField(controller: _newWaterController, label: 'Số nước MỚI', icon: Icons.water_drop, isNumber: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(controller: _waterPriceController, label: 'Đơn giá (đ)', icon: Icons.money, isCurrency: true)),
              ],
            ),
            const SizedBox(height: 32),

            _buildSectionHeader('DỊCH VỤ CỐ ĐỊNH'),
            _buildTextField(controller: _serviceFeeController, label: 'Tổng phí dịch vụ (VNĐ)', icon: Icons.cleaning_services, isCurrency: true),
            
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            // 📌 KHU VỰC: THÊM KHOẢN THU KHÁC (ĐỘNG)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('THÊM KHOẢN THU KHÁC'),
                TextButton.icon(
                  onPressed: () {
                    setState(() { customFees.add(DynamicFeeItem()); });
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm phí'),
                )
              ],
            ),
            ...customFees.asMap().entries.map((entry) {
              int index = entry.key;
              DynamicFeeItem item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(child: _buildTextField(controller: item.nameController, label: 'Tên phí', hint: 'VD: Gửi xe', icon: Icons.add_circle_outline)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildTextField(controller: item.amountController, label: 'Số tiền', icon: Icons.money, isCurrency: true)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          item.dispose();
                          customFees.removeAt(index);
                        });
                      },
                    )
                  ],
                ),
              );
            }),
            
            const SizedBox(height: 24),

            // 📌 KHU VỰC: THÊM GIẢM GIÁ (ĐỘNG)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('GIẢM GIÁ / KHẤU TRỪ'),
                TextButton.icon(
                  onPressed: () {
                    setState(() { customDiscounts.add(DynamicFeeItem()); });
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm giảm giá'),
                )
              ],
            ),
            ...customDiscounts.asMap().entries.map((entry) {
              int index = entry.key;
              DynamicFeeItem item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(child: _buildTextField(controller: item.nameController, label: 'Lý do', hint: 'VD: Lễ', icon: Icons.remove_circle_outline)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildTextField(controller: item.amountController, label: 'Số tiền', icon: Icons.money, isCurrency: true)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          item.dispose();
                          customDiscounts.removeAt(index);
                        });
                      },
                    )
                  ],
                ),
              );
            }),

            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: _generateBill,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1a1a1a),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('TẠO HÓA ĐƠN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String label, 
    String? hint,
    required IconData icon, 
    bool isNumber = false, 
    bool isCurrency = false
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: (isNumber || isCurrency) ? TextInputType.number : TextInputType.text,
      inputFormatters: isCurrency ? [CurrencyInputFormatter()] : (isNumber ? [FilteringTextInputFormatter.digitsOnly] : null),
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22),
        prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.black87, width: 1.5)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:rent_flow/models/renter_model.dart';
import 'package:rent_flow/models/contract_model.dart';

class AddTenantScreen extends StatefulWidget {
  final String roomId; 

  const AddTenantScreen({super.key, required this.roomId});

  @override
  State<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cccdController = TextEditingController();
  final _addressController = TextEditingController();
  final _depositController = TextEditingController();
  DateTime _startDate = DateTime.now(); 

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cccdController.dispose();
    _addressController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      try {
        final renterId = 'r_${DateTime.now().millisecondsSinceEpoch}';
        final contractId = 'c_${DateTime.now().millisecondsSinceEpoch}';

        final renter = RenterModel(
          id: renterId,
          name: 'Temp',
          phone: '0123456789',
          cccd: '012345678901',
          permanentAddress: 'Temp',
        );

        renter.name = _nameController.text.trim();
        renter.phone = _phoneController.text.trim();
        renter.cccd = _cccdController.text.trim();
        renter.permanentAddress = _addressController.text.trim();

        final contract = ContractModel(
          id: contractId,
          roomId: widget.roomId,
          renterId: renterId,
          deposit: 0,
          startDate: _startDate,
        );

        contract.deposit = double.parse(_depositController.text.trim());

        Navigator.pop(context, {
          'renter': renter,
          'contract': contract,
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bổ Sung Khách Thuê', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('THÔNG TIN KHÁCH', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 16),
              
              _buildTextField(controller: _nameController, label: 'Họ và tên *', icon: Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField(controller: _phoneController, label: 'Số điện thoại *', icon: Icons.phone_outlined, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(controller: _cccdController, label: 'Số CCCD *', icon: Icons.badge_outlined, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(controller: _addressController, label: 'Địa chỉ thường trú *', icon: Icons.home_outlined),
              
              const SizedBox(height: 32),
              const Text('THÔNG TIN HỢP ĐỒNG', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 16),

              _buildTextField(controller: _depositController, label: 'Tiền cọc (Triệu VNĐ) *', icon: Icons.monetization_on_outlined, isNumber: true),
              const SizedBox(height: 16),
              
              InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, color: Colors.grey.shade500),
                      const SizedBox(width: 16),
                      Text(
                        'Ngày dọn vào: ${_startDate.day}/${_startDate.month}/${_startDate.year}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1a1a1a),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'LƯU THÔNG TIN',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.black87, width: 1.5)),
      ),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập $label' : null,
    );
  }
}
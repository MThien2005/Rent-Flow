import 'package:flutter/material.dart';
import 'package:rent_flow/models/renter_model.dart';
import 'package:rent_flow/models/contract_model.dart';

class EditTenantScreen extends StatefulWidget {
  final RenterModel renter;
  final ContractModel contract;

  const EditTenantScreen({
    super.key,
    required this.renter,
    required this.contract,
  });

  @override
  State<EditTenantScreen> createState() => _EditTenantScreenState();
}

class _EditTenantScreenState extends State<EditTenantScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _cccdController;
  late TextEditingController _addressController;
  late TextEditingController _depositController;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    // 📌 Đổ dữ liệu cũ của khách vào các controller
    _nameController = TextEditingController(text: widget.renter.name);
    _phoneController = TextEditingController(text: widget.renter.phone);
    _cccdController = TextEditingController(text: widget.renter.cccd);
    _addressController = TextEditingController(text: widget.renter.permanentAddress);
    _depositController = TextEditingController(text: widget.contract.deposit.toString());
    _startDate = widget.contract.startDate;
  }

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
        // Cập nhật dữ liệu vào chính object model hiện tại
        widget.renter.name = _nameController.text.trim();
        widget.renter.phone = _phoneController.text.trim();
        widget.renter.cccd = _cccdController.text.trim();
        widget.renter.permanentAddress = _addressController.text.trim();

        widget.contract.deposit = double.parse(_depositController.text.trim());
        widget.contract.startDate = _startDate;

        // Trả về true để báo cho màn hình trước biết là đã sửa thành công
        Navigator.pop(context, true);

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff1a1a1a), // Đổi màu bộ chọn ngày cho hợp tone đen
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
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
        title: const Text('Sửa Thông Tin Khách', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
                    'CẬP NHẬT THÔNG TIN',
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
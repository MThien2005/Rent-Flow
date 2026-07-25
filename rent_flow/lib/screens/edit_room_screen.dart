import 'package:flutter/material.dart';
import 'package:rent_flow/models/room_model.dart'; // Đảm bảo đường dẫn import đúng

class EditRoomScreen extends StatefulWidget {
  final RoomModel room;

  const EditRoomScreen({super.key, required this.room});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _electricityController;
  late TextEditingController _waterController;
  late bool _isRented;

  @override
  void initState() {
    super.initState();
    // 📌 Điền sẵn dữ liệu cũ từ model khớp với các thuộc tính mới
    _nameController = TextEditingController(text: widget.room.name);
    _priceController = TextEditingController(text: widget.room.price.toString());
    _electricityController = TextEditingController(text: widget.room.lastElectricIndex.toString());
    _waterController = TextEditingController(text: widget.room.lastWaterIndex.toString());
    _isRented = widget.room.isRented;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _electricityController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  void _updateRoom() {
    if (_formKey.currentState!.validate()) {
      try {
        // 📌 Kích hoạt các hàm "set" trong RoomModel để tự động bắt lỗi
        widget.room.name = _nameController.text.trim();
        widget.room.price = double.parse(_priceController.text.trim());
        widget.room.lastElectricIndex = int.parse(_electricityController.text.trim());
        widget.room.lastWaterIndex = int.parse(_waterController.text.trim());

        // 📌 Xử lý trạng thái thuê bằng hàm toggleStatus() 
        // Do model của bạn đóng gói biến _isRented và chỉ cho đổi qua toggleStatus()
        if (widget.room.isRented != _isRented) {
          widget.room.toggleStatus();
        }

        // Trả kết quả về màn hình trước đó
        Navigator.pop(context, widget.room);
      } catch (e) {
        // Hứng lỗi (ví dụ nhập số âm) và hiển thị màu đỏ
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Phòng', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
              _buildTextField(controller: _nameController, label: 'Tên / Số phòng *'),
              const SizedBox(height: 20),
              _buildTextField(controller: _priceController, label: 'Giá thuê (Triệu VNĐ) *', isNumber: true),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildTextField(controller: _electricityController, label: 'Số điện chốt', isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(controller: _waterController, label: 'Số nước chốt', isNumber: true)),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Phòng đã có người thuê', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Switch(
                      value: _isRented,
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xff1a1a1a),
                      onChanged: (value) {
                        setState(() {
                          _isRented = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1a1a1a), 
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'CẬP NHẬT PHÒNG',
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
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
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
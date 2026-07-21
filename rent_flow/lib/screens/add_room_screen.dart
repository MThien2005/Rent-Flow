import 'package:flutter/material.dart';
import 'package:rent_flow/models/room_model.dart';

class AddRoomScreen extends StatefulWidget{

  final String houseId;

  const AddRoomScreen({super.key, required this.houseId});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _electricController = TextEditingController(text: '0');
  final TextEditingController _waterCotroller = TextEditingController(text: '0');
  bool _isRented = false;

  @override
  void dispose(){
    _nameController.dispose();
    _priceController.dispose();
    _electricController.dispose();
    _waterCotroller.dispose();
    super.dispose();
  }

  void _saveRoom(){
    if(_formKey.currentState!.validate()){
      double parsedPrice = double.tryParse(_priceController.text) ?? 0.0;
      int parsedElectric = int.tryParse(_electricController.text) ?? 0;
      int parsedWater = int.tryParse(_waterCotroller.text) ?? 0;

     // 📌 SỬA Ở ĐÂY: Khởi tạo một đối tượng RoomModel thực thụ thay vì dùng Map {}
     final newRoomData = RoomModel(
        id: 'r_${DateTime.now().millisecondsSinceEpoch}',
        houseId: widget.houseId,
        name: _nameController.text,
        price: parsedPrice, // Truyền số double vào
        isRented: _isRented,
        lastElectricIndex: parsedElectric,
        lastWaterIndex: parsedWater,
      );

      print("✅ Đang gửi dữ liệu về: ${newRoomData.name}");
      
      // Mang Object RoomModel về làm quà
      Navigator.pop(context, newRoomData);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thêm Phòng Mới', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding:  const EdgeInsets.all(24),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text('Tên / Số phòng *', style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 8,),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('vd: P.101'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập tên phòng' : null,
              ),
              const SizedBox(height: 20,),

              const Text('Giá thuê (Triệu VND) *', style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 8,),
              TextFormField(
                controller: _priceController,
                decoration: _buildInputDecoration('vd: 1.5'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập giá phòng' : null,
              ),
              const SizedBox(height: 20,),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Số điện cũ', style: TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 8,),
                        TextFormField(
                          controller: _electricController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration('Kwh'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Số nước cũ', style: TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 8,),
                        TextFormField(
                          controller: _waterCotroller,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration('Khối'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Phòng đã có người thuê', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                    Switch(
                      value: _isRented, 
                      activeColor: const Color(0xff2a86ff),
                      onChanged: (bool value){
                        setState(() {
                          _isRented = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40,),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('LƯU PHÒNG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white ),),
                ),
              ),
            ],
          ),
        ), 
      ),
    );
  }
  InputDecoration _buildInputDecoration(String hint){
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xff3a86ff), width: 2)),
    );
  }
}
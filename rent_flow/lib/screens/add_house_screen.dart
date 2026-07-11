import 'package:flutter/material.dart';
import 'package:rent_flow/models/house_model.dart';

class AddHouseScreen extends StatefulWidget{
  const AddHouseScreen({super.key});

  @override
  State<AddHouseScreen> createState () => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose(){
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveHouse(){
    if(_formKey.currentState!.validate()){
      final newHouse = HouseModel(
        id: 'h_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        roomCount: 0,
      );

      Navigator.pop(context, newHouse);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Thêm Khu Nhà Mới',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child:  Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700,),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Text(
                        'Điên thông tin cơ bản để tạo khu trọ mới. Bạn có thể thêm phòng trọ sau khi đã tạo khu trọ.',
                        style: TextStyle(color: Colors.blue.shade900, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32,),

              const Text('Tên khu nhà *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration(
                  hint: 'vd: Nhà trọ Tạ Quang Bửu', 
                  icon: Icons.maps_home_work_outlined
                ),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập tên khu nhà' : null,
              ),
              const SizedBox(height: 24),
              
              const Text('Địa chỉ chi tiết *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
              const SizedBox( height: 8,),
              TextFormField(
                controller: _addressController,
                decoration:_buildInputDecoration(
                  hint: 'vd: 735 Tạ Quang Bửu, Phường 4, Quận 8, TP.HCM', 
                  icon: Icons.location_on_outlined
                ) ,
                validator: (value) => (value == null || value.trim().isEmpty)? 'Vui lòng nhập địa chỉ' : null,
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saveHouse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1a1a1a),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'LƯU KHU NHÀ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                  )
                ),
              )
            ],
          ),
        ),

      ),
    );
  }

}

InputDecoration _buildInputDecoration({required String hint, required IconData icon}){
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    prefixIcon: Icon(icon, color: Colors.grey.shade500,),
    filled:  true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Color(0xff1a1a1a), width: 1.5)),
  );
}
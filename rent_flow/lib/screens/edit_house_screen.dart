import 'package:flutter/material.dart';
import 'package:rent_flow/models/house_model.dart';

class EditHouseScreen extends StatefulWidget {

  final HouseModel house;

  const EditHouseScreen({super.key, required this.house});

  @override
  State<EditHouseScreen> createState() => _EditHouseScreenState();
}

class _EditHouseScreenState extends State<EditHouseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController(text: widget.house.name);
    _addressController = TextEditingController(text: widget.house.address);
  }

  @override
  void dispose(){
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void _udateHouse(){
    if(_formKey.currentState!.validate()){
      try{
        widget.house.name = _nameController.text.trim();
        widget.house.address = _addressController.text.trim();

        Navigator.pop(context, widget.house);
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.red.shade600, 
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Chỉnh Sửa Khu Nhà',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tên khu nhà *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8,),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration(icon: Icons.maps_home_work_outlined),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập tên khu nhà' : null,
              ),
              const SizedBox(height: 24,),
              const Text(
                'Địa chỉ chi tiết *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8,),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: _buildInputDecoration(icon: Icons.location_on_outlined),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập địa chỉ' : null,
              ),
              const SizedBox(height: 48,),
               Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff3a86ff), Color(0xff4facfe)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff3a86ff).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _udateHouse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, 
                    shadowColor: Colors.transparent,    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_as_outlined, color: Colors.white, size: 22), 
                      SizedBox(width: 10),
                      Text(
                        'CẬP NHẬT', 
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white, 
                          letterSpacing: 1.0 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _buildInputDecoration({required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), 
        borderSide: BorderSide(color: Colors.grey.shade200)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), 
        borderSide: BorderSide(color: Colors.grey.shade200)
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)), 
        borderSide: BorderSide(color: Color(0xff3a86ff), width: 1.5)
      ),
    );
  }

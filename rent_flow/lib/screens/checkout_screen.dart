
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_flow/models/contract_model.dart';
import 'package:rent_flow/models/renter_model.dart';
import 'package:rent_flow/models/room_model.dart';

class CheckoutScreen extends StatefulWidget {
  
  final RoomModel room;
  final ContractModel contract;
  final RenterModel renter;

  const CheckoutScreen({
    super.key,
    required this.room,
    required this.contract,
    required this.renter,
  });

  @override
  State<CheckoutScreen> createState() => _checkoutScreenState();

}

class _checkoutScreenState extends State<CheckoutScreen>{
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _finalElecController;
  late TextEditingController _finalWaterController;

  @override
  void initState(){
    super.initState();
    _finalElecController = TextEditingController(text: widget.room.lastElectricIndex.toString());
    _finalWaterController = TextEditingController(text: widget.room.lastWaterIndex.toString());
  }

  @override
  void dispose(){
    _finalElecController.dispose();
    _finalWaterController.dispose();
    super.dispose();
  }

  void _processCheckout(){
    if(_formKey.currentState!.validate()){
      try{
        int finalElec = int.parse(_finalElecController.text.trim());
        int finalWater = int.parse(_finalWaterController.text.trim());
        
        if(finalElec < widget.room.lastElectricIndex ){
          throw Exception("Số điện cuối không được nhỏ hơn số điện củ (${widget.room.lastElectricIndex})");
        }

        if(finalWater < widget.room.lastWaterIndex ){
          throw Exception("Số nước cuối không được nhỏ hơn số nước củ (${widget.room.lastWaterIndex})");
        }

        widget.room.lastElectricIndex = finalElec;
        widget.room.lastWaterIndex = finalWater;

        if(widget.room.isRented){
          widget.room.toggleStatus();
        }

        widget.contract.terminateContract();
        widget.renter.checkout();

        Navigator.pop(context, true);
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("eception: ", "")),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Thanh Lý Hợp Đồng',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 28,),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xác nhận trả phòng ${widget.room.name}',
                            style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4), 
                          Text(
                            'Khách hàng: ${widget.renter.name}\nNgày dọn đi: $today',
                            style: TextStyle(color: Colors.red.shade900, fontSize: 14, height: 1.4),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('CHỈ SỐ CUỐI CÙNG', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),),
              const SizedBox(height: 16,),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _finalElecController ,
                      label: 'Số điện chốt', 
                      isNumber: true,
                      icon: Icons.bolt
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _finalWaterController ,
                      label: 'Số nước chốt', 
                      isNumber: true,
                      icon: Icons.water_drop
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'XÁC NHẬN TRẢ PHÒNG',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  )
                ),
              )
            ],
          ),
        )
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
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.black87, width: 1.5)),
      ),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Bắt buộc nhập' : null,
    );
  }
} 


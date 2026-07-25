import 'package:flutter/material.dart';
import 'package:rent_flow/models/contract_model.dart';
import 'package:rent_flow/models/renter_model.dart';
import 'package:rent_flow/models/room_model.dart';
import 'package:rent_flow/screens/add_tenant_screen.dart';
import 'package:rent_flow/screens/checkout_screen.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomModel room;
  const RoomDetailScreen({super.key, required this.room});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  ContractModel? currentContract;
  bool hasContract = false;
  RenterModel? currentRenter;

  void _handleCheckout() async {
    if (currentRenter != null && currentContract != null) {
      final bool? isSuccess = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            room: widget.room,
            contract: currentContract!,
            renter: currentRenter!,
          ),
        ),
      );

      // Nếu màn hình Checkout trả về true (Thanh lý thành công)
      if (isSuccess == true) {
        setState(() {
          hasContract = false;
          currentRenter = null;
          currentContract = null;
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đã thanh lý hợp đồng phòng ${widget.room.name} thành công!',
              ),
              backgroundColor: Colors.green.shade700,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMissingInfo = widget.room.isRented && !hasContract;

    return Scaffold(
      backgroundColor: Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text(
          'Phòng ${widget.room.name}',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        // 📌 THAY THẾ TOÀN BỘ PHẦN ACTIONS BẰNG ĐOẠN CODE SAU:
        actions: [
          // 📌 Chỉ hiện menu 3 chấm khi phòng ĐÃ CÓ KHÁCH
          if (widget.room.isRented && hasContract)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onSelected: (value) async {
                if (value == 'edit_renter') {
                  if (currentRenter != null && currentContract != null) {
                    // TODO: Mở trang EditTenantScreen
                  }
                } else if (value == 'checkout') {
                  _handleCheckout(); 
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit_renter',
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, size: 18),
                      SizedBox(width: 8),
                      Text("Sửa thông tin khách"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'checkout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Trả phòng', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMissingInfo) _buildWarningCard(),
            if (isMissingInfo) const SizedBox(height: 16),

            _buildStatusCard(),
            const SizedBox(height: 24),

            if (widget.room.isRented &&
                hasContract &&
                currentRenter != null) ...[
              const Text(
                'THÔNG TIN KHÁCH THUÊ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 12),
              _buildTenantCard(currentRenter!),
              const SizedBox(height: 24),
            ],
            const Text(
              'THÔNG TIN CƠ BẢN',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 12),
            _buildInfoSection(),
            const SizedBox(height: 24),

            const Text(
              'CHỈ SỐ DỊCH VỤ CỦ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _buildUtilitySection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(isMissingInfo),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade800,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chưa có thông tin khách thuê!',
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Phòng này được đánh dấu là đang có người ở nhưng chưa có dữ liệu hợp đồng. Vui lòng bổ sung.',
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final bool isRented = widget.room.isRented;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isRented ? const Color(0xff163020) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isRented ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isRented
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRented ? Icons.check_circle : Icons.door_front_door_outlined,
              color: isRented ? Colors.white : Colors.green.shade700,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trạng Thái',
                style: TextStyle(
                  color: isRented ? Colors.white70 : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isRented ? 'Đã có khách thuê' : 'Phòng trống',
                style: TextStyle(
                  color: isRented ? Colors.white : Colors.green.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTenantCard(RenterModel renter) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            radius: 24,
            child: Icon(Icons.person, color: Colors.blue.shade600),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                renter.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                renter.phone,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.payments_outlined,
            'Giá thuê',
            '${widget.room.price} Tr / tháng',
          ),
        ],
      ),
    );
  }

  Widget _buildUtilitySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.bolt_outlined,
            'Số điện cũ',
            '${widget.room.lastElectricIndex} kWh',
            hasDivider: true,
          ),
          _buildInfoRow(
            Icons.water_drop_outlined,
            'Số nước cũ',
            '${widget.room.lastWaterIndex} m³',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value, {
    bool hasDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (hasDivider) const Divider(height: 1, indent: 56),
      ],
    );
  }

  Widget _buildBottomActions(bool isMissingInfo) {
    String buttonText = '';
    IconData buttonIcon = Icons.receipt_long;

    if (!widget.room.isRented) {
      buttonText = 'TẠO HỢP ĐỒNG THUÊ';
      buttonIcon = Icons.post_add;
    } else if (isMissingInfo) {
      buttonText = 'BỔ SUNG KHÁCH THUÊ';
      buttonIcon = Icons.person_add_alt_1;
    } else {
      buttonText = 'LẬP HÓA ĐƠN THÁNG';
      buttonIcon = Icons.receipt_long;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: () async {
            if (isMissingInfo || !widget.room.isRented) {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTenantScreen(roomId: widget.room.id),
                ),
              );

              if (result != null) {
                final newRenter = result['renter'] as RenterModel;
                final newContract = result['contract'] as ContractModel; 
                
                setState(() {
                  hasContract = true; 
                  currentRenter = newRenter;
                  currentContract = newContract;
                  
                  // 📌 THÊM ĐOẠN NÀY: Nếu phòng đang trống thì chuyển sang trạng thái Đã thuê
                  if (!widget.room.isRented) {
                    widget.room.toggleStatus(); 
                  }
                });

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã thêm khách ${newRenter.name} thành công!')),
                  );
                }
              }
            } else {
              // TODO: Xử lý Lập hóa đơn
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1a1a1a),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(buttonIcon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rent_flow/models/bill_model.dart';
import 'package:rent_flow/models/contract_model.dart';
import 'package:rent_flow/models/payment_history_model.dart'; // 📌 Thêm dòng này
import 'package:rent_flow/screens/create_bill_screen.dart'; // 📌 Import để xài ké CurrencyInputFormatter
import 'package:rent_flow/models/room_model.dart';

class BillDetailScreen extends StatefulWidget {
  final BillModel bill;
  final RoomModel room;
  final ContractModel contract;

  const BillDetailScreen({super.key, required this.bill, required this.room, required this.contract,});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  // Biến lưu trữ lịch sử đóng tiền (giả lập)
  List<PaymentHistoryModel> paymentHistories = [];

  // Hàm mở Popup thu tiền
  void _showPaymentBottomSheet() {
    // 1. Tự động điền sẵn số tiền CÒN NỢ vào ô nhập để chủ trọ đỡ phải gõ
    final amountController = TextEditingController(
      text: NumberFormat.decimalPattern('vi_VN').format(widget.bill.remainingAmount)
    );
    String selectedMethod = 'Tiền mặt'; // Mặc định là Tiền mặt

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép đẩy popup lên khi bàn phím xuất hiện
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder( // Dùng StatefulBuilder để màn hình nhỏ này tự đổi nút Tiền mặt/Chuyển khoản
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Đẩy lên theo bàn phím
                left: 24, right: 24, top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Xác nhận thu tiền', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Ô nhập tiền
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    decoration: InputDecoration(
                      labelText: 'Số tiền khách đưa (đ)',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Chọn hình thức thanh toán
                  const Text('Hình thức thanh toán:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Tiền mặt'),
                          value: 'Tiền mặt',
                          groupValue: selectedMethod,
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xff00a854),
                          onChanged: (value) => setModalState(() => selectedMethod = value!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Chuyển khoản'),
                          value: 'Chuyển khoản',
                          groupValue: selectedMethod,
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xff00a854),
                          onChanged: (value) => setModalState(() => selectedMethod = value!),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Nút Xác nhận lưu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        double payAmount = double.tryParse(amountController.text.replaceAll('.', '')) ?? 0;
                        
                        if (payAmount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Số tiền không hợp lệ!')));
                          return;
                        }

                        if (payAmount > widget.bill.remainingAmount) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không được thu lố số tiền còn nợ!')));
                          return;
                        }

                        // 📌 LƯU VẾT & CẬP NHẬT GIAO DIỆN
                        // 📌 LƯU VẾT & CẬP NHẬT GIAO DIỆN
                        setState(() {
                          widget.bill.pay(payAmount);

                          // 📌 LƯU SỐ CŨ VÀ CẬP NHẬT LUÔN MẪU HÓA ĐƠN VÀO HỢP ĐỒNG
                          for (var fee in widget.bill.fees) {
                            if (fee is UtilityFee) {
                              if (fee.name == 'Tiền điện') {
                                widget.room.lastElectricIndex = fee.newIndex;
                                widget.contract.elecUnitPrice = fee.unitPrice; // Lưu giá điện mới
                              }
                              if (fee.name == 'Tiền nước') {
                                widget.room.lastWaterIndex = fee.newIndex;
                                widget.contract.waterUnitPrice = fee.unitPrice; // Lưu giá nước mới
                              }
                            }
                            if (fee is FixedFee && fee.name == 'Phí dịch vụ') {
                              widget.contract.serviceFee = fee.amount; // Lưu phí dịch vụ mới
                            }
                          }

                          paymentHistories.add(PaymentHistoryModel(
                            id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
                            billId: widget.bill.id,
                            amount: payAmount,
                            payDate: DateTime.now(),
                            method: selectedMethod,
                          ));
                        });

                        // 📌 LỆNH POPUNTIL: ĐÓNG LIÊN TỤC 3 MÀN HÌNH (BottomSheet -> BillDetail -> CreateBill)
                        int count = 0;
                        Navigator.popUntil(context, (route) {
                          return count++ == 2;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thanh toán và cập nhật mẫu hóa đơn!'), backgroundColor: Colors.green));

                        Navigator.pop(context); // Đóng popup
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã ghi nhận thanh toán thành công!'), backgroundColor: Colors.green));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00a854),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('XÁC NHẬN THU TIỀN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    // 📌 Xử lý Logic hiển thị Tag Trạng thái (Đa dạng hóa màu sắc)
    String statusText = 'Chưa thu';
    Color statusColor = Colors.orange;
    if (widget.bill.isPaid) {
      statusText = 'Đã thu đủ';
      statusColor = Colors.green;
    } else if (widget.bill.paidAmount > 0) {
      statusText = 'Thu 1 phần';
      statusColor = Colors.blue;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chi tiết hóa đơn', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Vui lòng đóng tiền thuê đúng hạn', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildActionButton(Icons.share, 'Chia sẻ', Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildActionButton(Icons.phone, 'Gọi điện', Colors.green)),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDateInfo('Hóa đơn tháng', widget.bill.monthYear),
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  _buildDateInfo('Ngày lập phiếu', DateFormat('dd/MM/yyyy').format(DateTime.now())),
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  _buildDateInfo('Hạn nạp tiền', DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 5)))),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lý do thu', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          SizedBox(height: 4),
                          Text('Thu tiền hàng tháng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      // 📌 Tag Trạng thái thay đổi linh hoạt theo số tiền đã đóng
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: statusColor),
                            const SizedBox(width: 6),
                            Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1, thickness: 1)),
                  
                  ...widget.bill.fees.map((fee) => _buildFeeItemRow(fee, currencyFormat)),

                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1, thickness: 1)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng cộng kỳ này', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text(currencyFormat.format(widget.bill.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Đã thanh toán', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      // 📌 Hiển thị số tiền khách đã trả
                      Text(currencyFormat.format(widget.bill.paidAmount), style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Số tiền còn nợ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      // 📌 Hiển thị số tiền còn nợ
                      Text(currencyFormat.format(widget.bill.remainingAmount), style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 📌 ẨN NÚT THANH TOÁN NẾU KHÁCH ĐÃ TRẢ ĐỦ TIỀN
              if (!widget.bill.isPaid) 
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showPaymentBottomSheet, // Gọi hàm mở Popup
                    icon: const Icon(Icons.attach_money, color: Colors.white),
                    label: const Text('Thanh toán hóa đơn', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00a854),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color, radius: 20, child: Icon(icon, color: Colors.white, size: 20)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildFeeItemRow(dynamic fee, NumberFormat currencyFormat) {
    bool isDiscount = fee is DiscountFee;
    String subtitle = '';
    Widget? extraWidget;

    if (fee is UtilityFee) {
      subtitle = 'Số mới: ${fee.newIndex}, Số cũ: ${fee.oldIndex}';
      extraWidget = Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
        child: Text(
          '${fee.newIndex - fee.oldIndex} KWh x ${currencyFormat.format(fee.unitPrice)}',
          style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.bold),
        ),
      );
    } else if (fee is QuantityFee) {
      subtitle = '${fee.quantity} ${fee.unit}';
    } else if (fee is DiscountFee) {
      subtitle = fee.reason;
    } else if (fee is FixedFee) {
      subtitle = fee.description ?? '';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fee.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDiscount ? Colors.red.shade700 : Colors.black87)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
                if (extraWidget != null) extraWidget,
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Thành tiền', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                isDiscount ? '- ${currencyFormat.format(fee.discountValue)}' : currencyFormat.format(fee.amount),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDiscount ? Colors.red.shade700 : Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
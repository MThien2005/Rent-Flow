import 'package:flutter/material.dart';
import 'package:rent_flow/models/room_model.dart';
import 'package:rent_flow/screens/add_room_screen.dart';
import 'package:rent_flow/screens/edit_room_screen.dart';
import 'package:rent_flow/screens/room_detail_screen.dart'; 

// 📌 TRỌNG TÂM: Đưa danh sách ra NGOÀI CLASS để nó trở thành Biến Toàn Cục (Global State)
// Nó sẽ sống trong suốt quá trình app chạy, không bị reset khi thoát màn hình.
final List<RoomModel> globalMockRooms = [
  RoomModel(
    id: 'r1', 
    houseId: 'h1', 
    name: 'P.101', 
    price: 2.5, 
    isRented: true, 
    lastElectricIndex: 1200, 
    lastWaterIndex: 50
  ),
];

class RoomListScreen extends StatefulWidget {
  final String houseId;
  final String houseName;

  const RoomListScreen({super.key, required this.houseId, required this.houseName});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  // Đã xóa mockRooms ở đây đi

  @override
  Widget build(BuildContext context) {
    // 📌 LỌC PHÒNG THEO NHÀ: 
    // Vì globalMockRooms chứa tất cả phòng của TẤT CẢ các nhà,
    // ta chỉ lấy ra những phòng thuộc về cái nhà đang được chọn (houseId)
    final roomsOfThisHouse = globalMockRooms.where((room) => room.houseId == widget.houseId).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa), 
      appBar: AppBar(
        title: Text(
          widget.houseName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
        centerTitle: true,
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRoom = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRoomScreen(houseId: widget.houseId),
            ),
          );

          if (newRoom != null) {
            setState(() {
              // Thêm phòng mới vào danh sách toàn cục
              globalMockRooms.add(newRoom as RoomModel); 
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đã thêm phòng ${(newRoom as RoomModel).name} thành công!')),
            );
          }
        },
        backgroundColor: Colors.black87,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm số phòng, tên người thuê...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              // Dùng danh sách đã được lọc theo houseId
              itemCount: roomsOfThisHouse.length, 
              itemBuilder: (context, index) {
                // Lấy phòng từ danh sách đã lọc
                final room = roomsOfThisHouse[index]; 

                Color statusColor;
                String statusText;
                
                if (room.isRented) {
                  statusColor = const Color(0xff457b9d);
                  statusText = 'Đang thuê';
                } else {
                  statusColor = const Color(0xff2ec4b6);
                  statusText = 'Phòng trống';
                }
                
                return Container(
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomDetailScreen(room: room),
                          ),
                        );
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.door_front_door, color: statusColor, size: 20),
                                        const SizedBox(width: 6),
                                        Text(
                                          room.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                        )
                                      ],
                                    ),
                                    
                                    SizedBox(
                                      width: 24,
                                      child: PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                                        onSelected: (value) async {
                                          if (value == 'edit') {
                                            // Điều hướng sang trang EditRoomScreen
                                            final updatedRoom = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditRoomScreen(room: room),
                                              ),
                                            );
                                            // Nếu có cập nhật thành công thì build lại UI
                                            if (updatedRoom != null) {
                                              setState(() {});
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Cập nhật phòng ${room.name} thành công!')),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit_outlined, size: 18),
                                                SizedBox(width: 8),
                                                Text("Sửa thông tin"),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                                SizedBox(width: 8),
                                                Text('Xóa phòng', style: TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                
                                Row(
                                  children: [
                                    Icon(Icons.payments_outlined, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${room.price} Tr', 
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700]
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            Divider(color: statusColor.withValues(alpha: 0.2), height: 16),
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (room.isRented) ...[
                                  Row(
                                    children: [
                                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Đã có khách thuê',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ) 
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    statusText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12, 
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          )
        ],
      ),
    );
  }
}
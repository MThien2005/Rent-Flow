import 'package:flutter/material.dart';
import 'package:rent_flow/screens/room_list_screen.dart';
import 'package:rent_flow/models/house_model.dart'; 
import 'package:rent_flow/screens/add_house_screen.dart'; 
import 'package:rent_flow/screens/edit_house_screen.dart'; // 📌 1. ĐÃ THÊM IMPORT MÀN HÌNH SỬA

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 📌 Khởi tạo dữ liệu. Thuộc tính roomCount lúc này chỉ là tượng trưng, 
  // vì ta sẽ đếm thực tế bằng code ở hàm build.
  final List<HouseModel> mockHouses = [
    HouseModel(
      id: 'h1',
      name: 'Nhà Tạ Quang Bửu',
      address: '735 Tạ Quang Bửu, Phường 4, Quận 8',
      roomCount: 0, 
    ),
    HouseModel(
      id: 'h2',
      name: 'Nhà Khánh Hội',
      address: '12 Khánh Hội, Phường 3, Quận 4',
      roomCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildHouseList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          final newHouse = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHouseScreen(), 
            ),
          );
          if(newHouse != null && newHouse is HouseModel){
            setState(() {
              mockHouses.add(newHouse);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đã thêm khu nhà ${newHouse.name} thành công!')),
            );
          }
        },
        backgroundColor: const Color(0xff1a1a1a),
        icon: const Icon(Icons.add_business, color: Colors.white),
        label: const Text(
          'Thêm nhà',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 24.0,
        bottom: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, Minh Thiện 👋',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Khu nhà của bạn',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 22),
                  color: Colors.black87,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm khu nhà...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 18),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: mockHouses.length,
      itemBuilder: (context, index) {
        final house = mockHouses[index]; 
        
        // 📌 TÍNH TOÁN DỮ LIỆU ĐỘNG TỪ globalMockRooms
        final roomsOfThisHouse = globalMockRooms.where((r) => r.houseId == house.id).toList();
        final actualRoomCount = roomsOfThisHouse.length;
        final actualAvailableCount = roomsOfThisHouse.where((r) => !r.isRented).length;

        // Xử lý UI linh hoạt theo số phòng đếm được
        Color tagColor;
        Color textColor;
        String tagText;

        if (actualRoomCount == 0) {
          tagColor = Colors.grey.shade100;
          textColor = Colors.grey.shade700;
          tagText = '🏠 Chưa có phòng nào';
        } else if (actualAvailableCount > 0) {
          tagColor = Colors.green.shade50;
          textColor = Colors.green.shade700;
          tagText = '🟢 Trống $actualAvailableCount/$actualRoomCount phòng';
        } else {
          tagColor = Colors.red.shade50;
          textColor = Colors.red.shade700;
          tagText = '🔴 Đã kín $actualRoomCount phòng';
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent, 
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () async {
                // 📌 Dùng await để màn hình đứng đợi ở đây
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoomListScreen(houseName: house.name, houseId: house.id), 
                  ),
                );
                // 📌 Khi quay lại từ RoomListScreen, gọi setState để tải lại số phòng mới nhất
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.maps_home_work,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                house.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                house.address,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // 📌 2. ĐÃ THÊM NÚT MENU SỬA/XÓA VÀO ĐÂY (Nằm cạnh Expanded)
                        SizedBox(
                          width: 32,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.more_vert, color: Colors.grey),
                            onSelected: (value) async {
                              if (value == 'edit') {
                                // Mở màn hình sửa và chờ kết quả
                                final updatedHouse = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditHouseScreen(house: house),
                                  ),
                                );

                                // Nếu sửa thành công, load lại giao diện
                                if (updatedHouse != null) {
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Đã cập nhật ${house.name}!')),
                                  );
                                }
                              } else if (value == 'delete') {
                                // Logic xóa nhà
                                setState(() {
                                  mockHouses.removeWhere((h) => h.id == house.id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đã xóa khu nhà!')),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 20),
                                    SizedBox(width: 8),
                                    Text('Sửa thông tin'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Text('Xóa khu nhà', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 📌 KẾT THÚC PHẦN NÚT 3 CHẤM
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                    ),
                    Row(
                      children: [
                        // 📌 THẺ HIỂN THỊ ĐỘNG
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tagText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
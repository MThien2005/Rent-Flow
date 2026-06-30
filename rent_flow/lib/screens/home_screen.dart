import 'package:flutter/material.dart';
import 'package:rent_flow/screens/room_list_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List mockHouse = [
    {
      'id': 'h1',
      'name': 'Nhà Tạ Quang Bửu',
      'address': '735 Tạ Quang Bửu, Phường 4, Quận 8',
      'roomCount': 14,
      'availableCount': 3,
    },
    {
      'id': 'h2',
      'name': 'Nhà Khánh Hội',
      'address': '12 Khánh Hội, Phường 3, Quận 4',
      'roomCount': 19,
      'availableCount': 0,
    },
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
        onPressed: () {
          print("chuyen sang man hinh them tro");
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

  // Hàm vẽ khu vực Header mới (Lời chào + Search Bar)
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
          // --- DÒNG 1: LỜI CHÀO & NÚT CHUÔNG ---
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

              // Nút chuông thông báo
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

          const SizedBox(height: 24), // Tạo không gian thở trước thanh Search
          // --- DÒNG 2: THANH TÌM KIẾM (SEARCH BAR) ---
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

                // Thêm icon Lọc (Filter) ở cuối thanh search nhìn rất Pro
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors
                        .black87, // Nút màu đen tone-sur-tone với nút Thêm nhà
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 18),
                ),

                border: InputBorder
                    .none, // Ẩn đường kẻ xấu xí mặc định của TextField
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
      itemCount: mockHouse.length,
      itemBuilder: (context, index) {
        final house = mockHouse[index];
        final bool hasAvailable = house['availableCount'] > 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Material(
            color: Colors.transparent, 
            child: InkWell(
              borderRadius: BorderRadius.circular(
                20,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoomListScreen(houseName: house['name']),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hàng 1: Icon, Tên nhà, Địa chỉ
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
                                house['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                house['address'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // Cắt bớt nếu chữ quá dài
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: Color(0xffeeeee)),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: hasAvailable
                                ? Colors.green[50]
                                : Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hasAvailable
                                ? '🟢 Trống ${house['availableCount']} phòng'
                                : '🔴 Đã kín phòng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: hasAvailable
                                  ? Colors.green[700]
                                  : Colors.red[700],
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

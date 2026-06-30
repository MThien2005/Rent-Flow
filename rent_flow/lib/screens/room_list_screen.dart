import 'package:flutter/material.dart';

class RoomListScreen extends StatefulWidget {

  final String houseName;

  const RoomListScreen({super.key, required this.houseName});

  @override
 State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final List <Map<String, dynamic>> mockRooms = [
    {'id': 'r1','name': 'P.101', 'status': 'rented', 'price': '2.5tr', 'tenant': 'Nguyễn Văn A'},
    {'id': 'r2', 'name': 'P.102', 'status': 'available', 'price': '2.5 Tr', 'tenant': ''},
    {'id': 'r3', 'name': 'P.103', 'status': 'debt', 'price': '3.0 Tr', 'tenant': 'Trần Thị B'},
    {'id': 'r4', 'name': 'P.104', 'status': 'rented', 'price': '2.5 Tr', 'tenant': 'Lê Văn C'},
    {'id': 'r5', 'name': 'P.201', 'status': 'available', 'price': '2.8 Tr', 'tenant': ''},
    {'id': 'r6', 'name': 'P.202', 'status': 'available', 'price': '2.8 Tr', 'tenant': ''},
  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xffff8f9fa),
      appBar: AppBar(
        title: Text(
          widget.houseName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor:  Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){print("chuyển sang màn hình form thêm phòng");},
        backgroundColor: const Color(0xff3a86ff),
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
              child:  const TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm số phòng, tên người thuê...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
              itemCount: mockRooms.length,
              itemBuilder: (context, index) {
                final room = mockRooms[index];

                Color statusColor;
                String statusText;
                if(room['status'] == 'available'){
                  statusColor = const Color(0xff2ec4b6);
                  statusText = 'Phòng trống';
                }else if(room['status'] == 'debt'){
                  statusColor = const Color(0xffe63946);
                  statusText = 'Đang nợ tiền';
                }else{
                  statusColor = const Color(0xff457b9d);
                  statusText = 'Đang thuê';
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
                      onTap: (){
                        print("Xem chi tiết phòng ${room['name']}");
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
                                        Icon(Icons.door_front_door, color: statusColor, size: 20,),
                                        const SizedBox(width: 6,),
                                        Text(
                                          room['name'],
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
                                        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20,),
                                        onSelected: (value){
                                          if(value == 'edit'){
                                            setState(() {
                                              mockRooms.removeAt(index);
                                            });
                                            print("Đã xóa phòng ${room['name']}");
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit_outlined, size: 18,),
                                                SizedBox(width: 8,),
                                                Text("sửa thông tin"),
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
                                const SizedBox( height: 8,),
                                Row(
                                  children: [
                                    Icon(Icons.payment_outlined, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 6,),
                                    Text(
                                      room['price'],
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
                            Divider( color: statusColor.withValues(alpha: 0.2), height: 16),
                            Column(
                              crossAxisAlignment:  CrossAxisAlignment.start,
                              children: [
                                if(room['tenant'] != '') ...[
                                  Row(
                                    children: [
                                      Icon(Icons.person, size: 16, color:  Colors.grey[600]),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          room['tenant'],
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
                                  const SizedBox(height: 8,),
                                ],
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius:  BorderRadius.circular(6),
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
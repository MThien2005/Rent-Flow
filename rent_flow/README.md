# 🏢 RentFlow - Ứng dụng Quản lý Nhà Trọ Thông Minh

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

**RentFlow** là ứng dụng di động được xây dựng bằng Flutter và Firebase, giúp các chủ nhà trọ số hóa hoàn toàn quy trình vận hành, tự động hóa tính toán chi phí điện nước và minh bạch hóa thông tin thanh toán với người thuê.

Dự án được phát triển theo kiến trúc **MVC**, áp dụng triệt để các nguyên lý **OOP** và sử dụng **Firebase NoSQL** làm nền tảng lưu trữ thời gian thực (Realtime Database).

---

## 🎯 1. Mục Tiêu Dự Án
- Thay thế hoàn toàn sổ sách ghi chép thủ công bằng hệ thống lưu trữ Cloud an toàn.
- Tự động hóa công thức tính toán hóa đơn (Tiền phòng + Điện + Nước + Dịch vụ).
- Cung cấp tính năng phân quyền chặt chẽ giữa Chủ trọ (Admin) và Người thuê (Renter).
- **Mục tiêu cá nhân:** Xây dựng một sản phẩm thực tế có thể sử dụng ngay (MVP) và làm Portfolio chứng minh năng lực phát triển Mobile App toàn diện.

---

## 🛠 2. Công Nghệ & Kiến Trúc
- **Frontend:** Flutter, Dart.
- **Backend (BaaS):** Firebase Authentication, Cloud Firestore (NoSQL), Firebase Storage.
- **Kiến trúc phần mềm:** MVC (Model - View - Controller).
- **Quy trình làm việc:** Quản lý mã nguồn qua Git/GitHub, phát triển theo mô hình Cuốn chiếu (Vertical Slicing) của Solo Developer.

---

## 👥 3. Phân Quyền Hệ Thống (RBAC)

### 👑 Chủ trọ (Owner)
Có toàn quyền (CRUD) trên dữ liệu thuộc sở hữu của mình:
- **Quản lý Tài sản:** Thêm/Sửa/Xóa Nhà và Phòng. Cập nhật trạng thái (Trống/Đang thuê).
- **Quản lý Vận hành:** Làm thủ tục Check-in/Check-out, tạo hợp đồng thuê nhà.
- **Quản lý Tài chính:** Ghi chỉ số điện nước hàng tháng, sinh hóa đơn tự động, xác nhận thanh toán.
- **Dashboard:** Thống kê doanh thu, số lượng phòng trống/đang thuê.

### 👤 Người thuê (Renter)
Quyền truy cập hạn chế (Chỉ xem - View Only) nhằm đảm bảo tính bảo mật:
- Xem thông tin phòng đang thuê và chi tiết hợp đồng.
- Nhận và xem chi tiết Hóa đơn hàng tháng (công khai chỉ số điện/nước).
- Gửi thông báo xác nhận đã thanh toán tiền.
- Tuyệt đối không xem được dữ liệu của các phòng khác.

---

## 🗄 4. Mô Hình Dữ Liệu (Firestore Structure)

Dự án sử dụng cơ sở dữ liệu NoSQL với cấu trúc phân cấp linh hoạt:

```text
Owner (User)
 └── House
      └── Room
           ├── CurrentRenter
           ├── Contract
           ├── MeterReading (Chỉ số điện nước)
           ├── Bill (Hóa đơn)
           └── PaymentHistory (Lịch sử thanh toán)

lib/
│
├── models/         # Chứa các lớp dữ liệu, định nghĩa OOP (House, Room, Bill)
├── screens/        # Chứa giao diện người dùng (UI) chia theo tính năng
├── services/       # Chứa các lớp xử lý logic và gọi API Firebase
├── utils/          # Các hàm tiện ích dùng chung (Format tiền tệ, Format ngày tháng)
└── main.dart       # Điểm bắt đầu của ứng dụng

Tổng cộng dự án RentFlow của chúng ta có **7 Models cốt lõi**.


### 🏠 1. Nhóm Cơ sở vật chất (Assets)

Đây là "phần cứng", những thứ có thể nhìn thấy được.

* **1. `HouseModel`:** Quản lý tòa nhà/khu trọ (Ví dụ: Nhà A - 10 phòng).
* **2. `RoomModel`:** Quản lý từng căn phòng cụ thể (Ví dụ: Phòng P.101, Giá 3 triệu/tháng). Nó chứa ID của tòa nhà nó thuộc về (`houseId`).

### 👥 2. Nhóm Pháp lý & Con người (Legal & People)

Đây là phần liên quan đến khách hàng và sự ràng buộc.

* **3. `RenterModel`:** Lưu thông tin người thuê (Họ tên, SĐT, CCCD).
* **4. `ContractModel` (Hợp đồng):** Đây là **cầu nối cực kỳ quan trọng**. Nó gắn kết một vị khách cụ thể (`renterId`) vào một căn phòng cụ thể (`roomId`). Nhờ có nó, ta biết ai đang ở phòng nào mà không sợ mất lịch sử khi khách dọn đi.

### 💰 3. Nhóm Kế toán (Accounting)

Đây là "bộ não" tính toán tiền bạc, quyết định sự thông minh của App.

* **5. `BillModel` (Hóa đơn):** Nó gom tất cả các loại phí (Tiền phòng, điện, nước, rác...) của một phòng trong một tháng lại thành một tổng tiền.
* **6. `PaymentHistoryModel` (Lịch sử thanh toán):** Ghi nhận dòng tiền thực tế chạy vào túi chủ trọ (Trả lúc nào? Trả bằng tiền mặt hay chuyển khoản?).

### 👑 4. Nhóm Quản trị (Admin)

Phần này gắn trực tiếp với hệ thống Đăng nhập của Firebase.

* **7. `UserModel` (Chủ trọ):** Nắm quyền cao nhất (`ownerId`). Tất cả các Nhà (`HouseModel`) đều phải chứa cái `ownerId` này để chủ trọ chỉ nhìn thấy nhà của mình, không thấy nhà của người khác.

---
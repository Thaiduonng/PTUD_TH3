# BÀI THỰC HÀNH 3: CALL API APP (PRO VERSION)

## Chủ đề: Gọi dữ liệu Firebase Real-time - Giao diện Material Design 3

---

### 1. TỔNG QUAN DỰ ÁN
Ứng dụng Flutter quản lý danh sách người dùng được tích hợp với **Firebase Firestore**. Ứng dụng không chỉ xử lý các luồng dữ liệu bất đồng bộ mà còn mang lại trải nghiệm người dùng hiện đại với phong cách thiết kế **Material Design 3**.

- **Định danh**: `TH3 - Nguyễn Thái Dương - 2351060435`
- **Công nghệ**: Flutter, Firebase Firestore, Material Design 3.

### 2. CÁC TÍNH NĂNG CHÍNH
- **CRUD đầy đủ**:
    - **Xem**: Danh sách người dùng được cập nhật thời gian thực (Real-time). Hiển thị Tên, Email và Tuổi trên thẻ.
    - **Thêm**: Form thêm người dùng mới với đầy đủ thông tin (Tên, Email, Tuổi, SĐT, Địa chỉ, Avatar).
    - **Chi tiết & Chỉnh sửa**: Nhấn vào thẻ để xem chi tiết và chỉnh sửa toàn bộ thông tin người dùng.
    - **Xóa**: Chức năng xóa người dùng kèm hộp thoại xác nhận an toàn.

- **Tìm kiếm thông minh**: Thanh tìm kiếm (SearchBar) chuẩn M3 cho phép lọc người dùng theo tên hoặc email ngay lập tức.
- **Xử lý trạng thái (State Handling)**:
    - **Loading**: Hiệu ứng chờ khi tải dữ liệu.
    - **Error**: Thông báo lỗi chuyên nghiệp và hỗ trợ "Thử lại".
    - **Success**: Hiển thị thẻ người dùng (User Card) tinh tế.

### 3. ĐIỂM NHẤN MATERIAL DESIGN 3 (M3)
Ứng dụng được tối ưu hóa theo tiêu chuẩn thiết kế mới nhất của Google:
- **Hệ màu Indigo**: Sử dụng `ColorScheme.fromSeed` tạo bảng màu hiện đại và đồng nhất.
- **Thẻ Card cải tiến**: Góc bo tròn lớn (24px), màu sắc Surface tinh tế.
- **SearchBar & Buttons**: Sử dụng widget SearchBar và FilledButton mới nhất của M3.
- **Typography**: Phông chữ được tối ưu hóa cho khả năng đọc và thẩm mỹ.

### 4. CẤU TRÚC THƯ MỤC
- `lib/models/`: Chứa `UserModel.dart` định nghĩa cấu trúc dữ liệu.
- `lib/services/`: Chứa `FirebaseService.dart` xử lý logic Firestore.
- `lib/views/`:
    - `home_screen.dart`: Màn hình chính với luồng dữ liệu Stream.
    - `add_user_screen.dart`: Màn hình thêm người dùng với form validation.
    - `widgets/user_card.dart`: Widget hiển thị thông tin người dùng.

### 5. HƯỚNG DẪN CÀI ĐẶT
1.  Đảm bảo đã thêm file `google-services.json` vào thư mục `android/app/`.
2.  Chạy lệnh `flutter pub get` để tải các thư viện cần thiết.
3.  Sử dụng `flutter run` để khởi động ứng dụng trên thiết bị.

### 6. TÀI LIỆU KÈM THEO
- Xem file `memory.md` để hiểu về các kiến thức đã sử dụng trong dự án.


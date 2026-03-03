# Dự án Call API App - Memory & Knowledge Map

Tài liệu này ghi lại các bước phát triển và kiến thức tương ứng đã được áp dụng trong suốt quá trình xây dựng ứng dụng.

## 1. Thiết lập & Cấu hình Firebase
*   **Bước làm**: Cấu hình Firebase cho Android, xử lý lỗi trùng lặp package name, và cài đặt plugin Google Services.
*   **Kiến thức sử dụng**:
    *   **Android Build System**: Hiểu cấu trúc file `build.gradle`, `settings.gradle`, và cách quản lý `applicationId`, `namespace`.
    *   **Firebase SDK Integration**: Cách tích hợp file `google-services.json` và khởi tạo Firebase trong ứng dụng Flutter bằng `Firebase.initializeApp()`.

## 2. Xây dựng Model & Service
*   **Bước làm**: Tạo lớp `UserModel` và `FirebaseService` để thực hiện các thao tác CRUD (Create, Read, Update, Delete).
*   **Kiến thức sử dụng**:
    *   **Data Modeling**: Cách ánh xạ dữ liệu (mapping) từ Firestore (Map) sang đối tượng Dart (Object-Oriented Programming).
    *   **Asynchronous Programming**: Sử dụng `Future` và `async/await` để xử lý các tác vụ mạng không gây treo ứng dụng.
    *   **Firestore CRUD**: Sử dụng các phương thức `collection()`, `add()`, `doc().delete()`, `get()` để tương tác với cơ sở dữ liệu NoSQL.

## 3. Quản lý trạng thái & UI Real-time
*   **Bước làm**: Sử dụng `FutureBuilder` và sau đó nâng cấp lên `StreamBuilder` để hiển thị dữ liệu và cập nhật ngay lập tức.
*   **Kiến thức sử dụng**:
    *   **State Management**: Sử dụng các widget Builder của Flutter để quản lý vòng đời dữ liệu.
    *   **Streams & Snapshots**: Hiển thị dữ liệu dạng luồng (real-time data flow) từ Firestore để UI tự động thay đổi khi DB thay đổi.
    *   **UI States**: Thiết kế các màn hình tương ứng với 3 trạng thái: Loading, Success, và Error (UX Best Practices).

## 4. Chức năng mở rộng (Search & Filtering)
*   **Bước làm**: Thêm thanh tìm kiếm để lọc danh sách người dùng.
*   **Kiến thức sử dụng**:
    *   **Search Logic**: Kỹ thuật lọc danh sách (`where` filtering) dựa trên dữ liệu nhập từ người dùng (`TextEditingController`).
    *   **Event Handling**: Xử lý sự kiện `onChanged` để cập nhật UI ngay khi người dùng gõ phím.

## 5. Nâng cấp Material Design 3 (M3)
*   **Bước làm**: Chuyển đổi toàn bộ giao diện sang phong cách M3 với `ColorScheme`, `SearchBar`, và `Card` mới.
*   **Kiến thức sử dụng**:
    *   **Modern Theming**: Hiểu về `ThemeData`, `useMaterial3`, và cách tạo bảng màu tự động từ `ColorScheme.fromSeed`.
    *   **Material 3 Design System**: Áp dụng các khái niệm về Surface, Elevation, và Corner Radius (góc bo) theo tiêu chuẩn thiết kế mới nhất của Google.
    *   **Component Styling**: Tùy chỉnh (customize) các widget như `FilledButton`, `FloatingActionButton.extended`, và `SearchBar`.

## 6. Xử lý lỗi & Tối ưu hóa UX
*   **Bước làm**: Thêm hộp thoại xác nhận khi xóa, kiểm tra dữ liệu form (validation).
*   **Kiến thức sử dụng**:
    *   **Exception Handling**: Sử dụng khối `try-catch` để bắt lỗi và hiển thị `SnackBar` hoặc `Dialog` thông báo cho người dùng.
## 7. Mở rộng hồ sơ & Tính năng Chỉnh sửa
*   **Bước làm**: Thêm các trường dữ liệu mới (tuổi, SĐT, địa chỉ), hợp nhất màn hình Thêm/Sửa thành `UserFormScreen`.
*   **Kiến thức sử dụng**:
    *   **Conditional UI Logic**: Cách sử dụng cùng một Form cho hai mục đích khác nhau (Create vs Update) dựa trên việc có truyền đối tượng `user` vào hay không.
    *   **Navigation & Data Passing**: Kỹ thuật truyền dữ liệu qua constructor của Widget khi điều hướng bằng `Navigator.push`.
    *   **Complex Forms**: Xử lý nhiều trường nhập liệu, phân chia section trong Form và sử dụng các loại bàn phím (keyboardType) phù hợp cho từng loại dữ liệu (Số, Điện thoại).
    *   **Firestore Update**: Sử dụng phương thức `update()` của Firestore để chỉ cập nhật các trường thay đổi mà không ghi đè toàn bộ document nếu không cần thiết.

## 8. Xử lý Ảnh & Ràng buộc dữ liệu nâng cao
*   **Bước làm**: Thêm cơ chế fallback cho ảnh lỗi, bổ sung kiểm tra tuổi (1-120) và SĐT (10 số, đầu 0).
*   **Kiến thức sử dụng**:
    *   **Image Error Handling**: Sử dụng `errorBuilder` và `loadingBuilder` trong `Image.network` để quản lý các trạng thái tải ảnh và hiển thị ảnh thay thế khi URL hỏng.
    *   **Regular Expressions (Regex)**: Sử dụng biểu thức chính quy để kiểm tra định dạng chuỗi phức tạp như số điện thoại Việt Nam.
    *   **Data Constrainst**: Thiết lập các quy tắc logic nghiệp vụ (business rules) trực tiếp trên giao diện để đảm bảo tính toàn vẹn của dữ liệu trước khi gửi lên máy chủ.

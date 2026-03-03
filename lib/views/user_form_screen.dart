import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? user; // Null means "Add Mode", Not null means "Edit Mode"

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  bool get isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _avatarController.text = widget.user!.avatar;
      _ageController.text = widget.user!.old;
      _phoneController.text = widget.user!.phone;
      _addressController.text = widget.user!.home;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final userModel = UserModel(
          id: isEditMode ? widget.user!.id : '',
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          avatar: _avatarController.text.trim().isEmpty 
              ? 'https://via.placeholder.com/150' 
              : _avatarController.text.trim(),
          old: _ageController.text.trim(),
          phone: _phoneController.text.trim(),
          home: _addressController.text.trim(),
        );

        if (isEditMode) {
          await _firebaseService.updateUser(widget.user!.id, userModel);
        } else {
          await _firebaseService.addUser(userModel);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEditMode ? 'Cập nhật thành công!' : 'Thêm người dùng thành công!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(isEditMode ? 'Chỉnh sửa người dùng' : 'Thêm người dùng mới'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(colorScheme, 'Thông tin cơ bản'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Họ và tên',
                    hint: 'Nhập tên đầy đủ',
                    icon: Icons.person_outline,
                    colorScheme: colorScheme,
                    validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'example@domain.com',
                    icon: Icons.email_outlined,
                    colorScheme: colorScheme,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Vui lòng nhập email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildTextField(
                          controller: _ageController,
                          label: 'Tuổi',
                          hint: 'Vd: 25',
                          icon: Icons.cake_outlined,
                          colorScheme: colorScheme,
                          keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Nhập tuổi';
                        final age = int.tryParse(value);
                        if (age == null) return 'Phải là số';
                        if (age < 1 || age > 120) return '1-120';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _phoneController,
                      label: 'Số điện thoại',
                      hint: '0123xxx',
                      icon: Icons.phone_outlined,
                      colorScheme: colorScheme,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Nhập SĐT';
                        if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                          return 'SĐT 10 số, bắt đầu bằng 0';
                        }
                        return null;
                      },
                    ),
                  ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader(colorScheme, 'Địa chỉ & Hình ảnh'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Địa chỉ nhà',
                    hint: 'Nhập địa chỉ cư trú',
                    icon: Icons.home_outlined,
                    colorScheme: colorScheme,
                    validator: (value) => value!.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _avatarController,
                    label: 'Link ảnh Avatar',
                    hint: 'https://...',
                    icon: Icons.image_outlined,
                    colorScheme: colorScheme,
                    helperText: 'Để trống để dùng ảnh mặc định',
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _saveUser,
                      icon: Icon(isEditMode ? Icons.edit_outlined : Icons.save_outlined),
                      label: Text(isEditMode ? 'Cập nhật thông tin' : 'Lưu thông tin', 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionHeader(ColorScheme colorScheme, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ColorScheme colorScheme,
    TextInputType keyboardType = TextInputType.text,
    String? helperText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

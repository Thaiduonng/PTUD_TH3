import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';
import 'widgets/user_card.dart';
import 'widgets/connection_error_widget.dart';
import 'user_form_screen.dart'; // Update this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firebaseService.deleteUser(user.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa người dùng')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi khi xóa: $e')),
                  );
                }
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'TH3 - Nguyễn Thái Dương - 2351060435',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              hintText: 'Tìm kiếm người dùng...',
              leading: Icon(Icons.search, color: colorScheme.primary),
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest.withOpacity(0.5)),
              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _firebaseService.usersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('Đang tải...', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return ConnectionErrorWidget(
              errorMessage: snapshot.error.toString(),
              onRetry: () {
                // For StreamBuilder with Firebase, we can trigger a rebuild
                // by calling setState, though Firebase streams usually auto-retry.
                setState(() {});
              },
            );
          }

          final users = snapshot.data ?? [];
          final filteredUsers = users.where((user) {
            return user.name.toLowerCase().contains(_searchQuery) ||
                user.email.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty ? 'Chưa có người dùng nào' : 'Không tìm thấy kết quả',
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return UserCard(
                user: user,
                onDelete: () => _confirmDelete(context, user),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserFormScreen()),
          );
        },
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Thêm người dùng'),
      ),
    );
  }
}



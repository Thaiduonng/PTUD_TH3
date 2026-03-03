import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Fetch all users from Firestore
  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(_collection).get();
      
      return querySnapshot.docs.map((doc) {
        return UserModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      // Re-throw or handle error as needed
      throw Exception('Failed to load users: $e');
    }
  }

  // Add a new user to Firestore
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection(_collection).add(user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  // Update a user in Firestore
  Future<void> updateUser(String id, UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(id).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete a user from Firestore
  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }


  // Stream version for real-time updates


  Stream<List<UserModel>> usersStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
}

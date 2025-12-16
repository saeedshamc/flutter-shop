import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/logger.dart';

class FirebaseService {
  // Singleton Pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();
  
  // Firebase Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  
  // Current User
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Auth State Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Collections
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get productsCollection => _firestore.collection('products');
  CollectionReference get categoriesCollection => _firestore.collection('categories');
  CollectionReference get ordersCollection => _firestore.collection('orders');
  
  // Initialize
  Future<void> initialize() async {
    try {
      AppLogger.info('Firebase Service initialized');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Firebase Service', e, stackTrace);
      rethrow;
    }
  }
}


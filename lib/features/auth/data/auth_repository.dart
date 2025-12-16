import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithEmail(String email, String password);
  Future<Either<Failure, UserModel>> signUpWithEmail(String name, String email, String password);
  Future<Either<Failure, UserModel>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, UserModel?>> getCurrentUser();
  Stream<User?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService;
  final StorageService _storageService;
  
  AuthRepositoryImpl({
    required FirebaseService firebaseService,
    required StorageService storageService,
  })  : _firebaseService = firebaseService,
        _storageService = storageService;
  
  @override
  Future<Either<Failure, UserModel>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        return const Left(AuthenticationFailure(message: 'ورود ناموفق'));
      }
      
      // Get user data from Firestore
      final userDoc = await _firebaseService.usersCollection
          .doc(credential.user!.uid)
          .get();
      
      if (!userDoc.exists) {
        return const Left(NotFoundFailure(message: 'کاربر یافت نشد'));
      }
      
      final user = UserModel.fromFirestore(userDoc);
      
      // Save token
      final token = await credential.user!.getIdToken();
      if (token != null) {
        await _storageService.saveAuthToken(token);
      }
      
      AppLogger.info('User signed in: ${user.email}');
      return Right(user);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign in error', e);
      return Left(_handleAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error('Sign in error', e, stackTrace);
      return const Left(UnknownFailure(message: 'خطای نامشخص در ورود'));
    }
  }
  
  @override
  Future<Either<Failure, UserModel>> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        return const Left(AuthenticationFailure(message: 'ثبت‌نام ناموفق'));
      }
      
      // Create user document
      final user = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        role: 'user',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _firebaseService.usersCollection
          .doc(user.id)
          .set(user.toFirestore());
      
      // Update display name
      await credential.user!.updateDisplayName(name);
      
      // Save token
      final token = await credential.user!.getIdToken();
      if (token != null) {
        await _storageService.saveAuthToken(token);
      }
      
      AppLogger.info('User signed up: ${user.email}');
      return Right(user);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign up error', e);
      return Left(_handleAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error('Sign up error', e, stackTrace);
      return const Left(UnknownFailure(message: 'خطای نامشخص در ثبت‌نام'));
    }
  }
  
  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      // This requires google_sign_in package and additional setup
      // For now, we'll return a failure
      return const Left(
        UnknownFailure(message: 'ورود با Google در حال توسعه است'),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Google sign in error', e, stackTrace);
      return const Left(UnknownFailure(message: 'خطا در ورود با Google'));
    }
  }
  
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseService.auth.signOut();
      await _storageService.clearAuthToken();
      AppLogger.info('User signed out');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Sign out error', e, stackTrace);
      return const Left(UnknownFailure(message: 'خطا در خروج'));
    }
  }
  
  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent to: $email');
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Reset password error', e);
      return Left(_handleAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error('Reset password error', e, stackTrace);
      return const Left(UnknownFailure(message: 'خطا در بازیابی رمز عبور'));
    }
  }
  
  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final currentUser = _firebaseService.currentUser;
      
      if (currentUser == null) {
        return const Right(null);
      }
      
      final userDoc = await _firebaseService.usersCollection
          .doc(currentUser.uid)
          .get();
      
      if (!userDoc.exists) {
        return const Right(null);
      }
      
      final user = UserModel.fromFirestore(userDoc);
      return Right(user);
    } catch (e, stackTrace) {
      AppLogger.error('Get current user error', e, stackTrace);
      return const Left(UnknownFailure(message: 'خطا در دریافت اطلاعات کاربر'));
    }
  }
  
  @override
  Stream<User?> get authStateChanges => _firebaseService.authStateChanges;
  
  // Handle Firebase Auth Exceptions
  Failure _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthenticationFailure(message: 'کاربری با این ایمیل یافت نشد');
      case 'wrong-password':
        return const AuthenticationFailure(message: 'رمز عبور اشتباه است');
      case 'email-already-in-use':
        return const AuthenticationFailure(message: 'این ایمیل قبلاً ثبت شده است');
      case 'invalid-email':
        return const ValidationFailure(message: 'ایمیل نامعتبر است');
      case 'weak-password':
        return const ValidationFailure(message: 'رمز عبور ضعیف است');
      case 'user-disabled':
        return const AuthenticationFailure(message: 'حساب کاربری غیرفعال شده است');
      case 'too-many-requests':
        return const AuthenticationFailure(message: 'درخواست‌های زیاد. لطفاً بعداً تلاش کنید');
      default:
        return AuthenticationFailure(message: e.message ?? 'خطای احراز هویت');
    }
  }
}


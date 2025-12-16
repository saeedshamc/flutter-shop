import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/auth_repository.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});

// Auth State Provider (Firebase Auth Stream)
final authStateProvider = StreamProvider<User?>((ref) {
  return getIt<AuthRepository>().authStateChanges;
});

// Current User Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final result = await getIt<AuthRepository>().getCurrentUser();
  return result.fold(
    (failure) => null,
    (user) => user,
  );
});

// Auth Controller State
class AuthState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  
  AuthState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });
  
  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

// Auth Controller
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  
  AuthController(this._authRepository) : super(AuthState());
  
  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authRepository.signInWithEmail(email, password);
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'خوش آمدید',
        );
        return true;
      },
    );
  }
  
  Future<bool> signUp(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authRepository.signUpWithEmail(name, email, password);
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'ثبت‌نام با موفقیت انجام شد',
        );
        return true;
      },
    );
  }
  
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authRepository.signInWithGoogle();
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'خوش آمدید',
        );
        return true;
      },
    );
  }
  
  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authRepository.resetPassword(email);
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'ایمیل بازیابی رمز عبور ارسال شد',
        );
        return true;
      },
    );
  }
  
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    await _authRepository.signOut();
    state = state.copyWith(isLoading: false);
  }
  
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

// Auth Controller Provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});


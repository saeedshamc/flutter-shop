import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String? email;
  final String? name;
  
  AuthState({
    this.isAuthenticated = false,
    this.email,
    this.name,
  });
  
  AuthState copyWith({
    bool? isAuthenticated,
    String? email,
    String? name,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());
  
  void register(String name, String email, String password) {
    // Mock register - در نسخه واقعی با Firebase کار می‌کند
    state = AuthState(
      isAuthenticated: true,
      email: email,
      name: name,
    );
  }
  
  void login(String email, String password) {
    // Mock login - در نسخه واقعی با Firebase کار می‌کنه
    state = AuthState(
      isAuthenticated: true,
      email: email,
      name: email.split('@')[0],
    );
  }
  
  void logout() {
    state = AuthState();
  }
}

final authProviderSimple = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});


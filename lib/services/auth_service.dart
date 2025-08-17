class AuthService {
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isEmpty || password.isEmpty) {
      return 'Email and password are required.';
    }
    if (!email.contains('@')) {
      return 'Please enter a valid email address.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  Future<String?> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return 'All fields are required.';
    }
    if (!email.contains('@')) {
      return 'Please enter a valid email address.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    if (email.toLowerCase().startsWith('taken')) {
      return 'Email address already registered.';
    }
    return null;
  }
}

class AuthService {
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // 🔹 TEMP LOGIN LOGIC (you can replace with Firebase later)
    if (email == "test@gmail.com" && password == "123456") {
      return null; // success
    } else {
      return "Invalid email or password";
    }
  }
}
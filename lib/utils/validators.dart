class Validators {
  const Validators._();

  static String? requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredText(value, 'Email');
    if (requiredError != null) return requiredError;

    final emailPattern = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredText(value, 'Password');
    if (requiredError != null) return requiredError;

    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    final passwordError = Validators.password(value);
    if (passwordError != null) return passwordError;

    if (value != originalPassword) {
      return 'Confirm password must match';
    }
    return null;
  }

  static String? phone(String? value) {
    final requiredError = requiredText(value, 'Phone number');
    if (requiredError != null) return requiredError;
    return null;
  }
}

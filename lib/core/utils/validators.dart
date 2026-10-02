// core/utils/validators.dart

class Validators {
  Validators._();

  // =========================
  // General Validators
  // =========================

  /// Checks if the value is empty.
  static String? required(
    String? value, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  /// Validates email format.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validates password.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  /// Validates password confirmation.
  static String? confirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates username/name.
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Validates phone number.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phone = value.trim();

    final phoneRegex = RegExp(
      r'^\+?[0-9]{10,15}$',
    );

    if (!phoneRegex.hasMatch(phone)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // =========================
  // Auth Validators
  // =========================

  /// Login validation.
  ///
  /// Returns an error message if email or password is invalid.
  static String? login({
    required String? email,
    required String? password,
  }) {
    final emailError = Validators.email(email);

    if (emailError != null) {
      return emailError;
    }

    final passwordError = Validators.password(password);

    if (passwordError != null) {
      return passwordError;
    }

    return null;
  }

  /// Register validation.
  ///
  /// Validates name, email, password and confirm password.
  static String? register({
    required String? name,
    required String? email,
    required String? password,
    required String? confirmPasswordValue,
  }) {
    final nameError = Validators.name(name);

    if (nameError != null) {
      return nameError;
    }

    final emailError = Validators.email(email);

    if (emailError != null) {
      return emailError;
    }

    final passwordError = Validators.password(password);

    if (passwordError != null) {
      return passwordError;
    }

    final confirmPasswordError = Validators.confirmPassword(
      confirmPasswordValue,
      password ?? '',
    );

    if (confirmPasswordError != null) {
      return confirmPasswordError;
    }

    return null;
  }

  /// Forgot password validation.
  static String? forgotPassword(String? email) {
    return Validators.email(email);
  }
}
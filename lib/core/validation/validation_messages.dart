/// Centralized validation error messages.
///
/// All user-facing validation strings live here for easy
/// localization and consistency across the app.
class ValidationMessages {
  const ValidationMessages._();

  // General
  static const String required = 'This field is required';

  // Name
  static const String nameRequired = 'Name is required';
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String nameInvalid =
      'Only letters, spaces, hyphens and dots are allowed';

  // Phone
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Enter a valid phone number';

  // Email
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email address';

  // OTP
  static const String otpRequired = 'OTP is required';
  static const String otpDigitsOnly = 'OTP must contain digits only';
  static const String otpLength = 'OTP must be 6 digits';

  // Password
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 8 characters';

  // Date of Birth
  static const String dobRequired = 'Date of Birth is required';
  static const String dobInvalid = 'Enter a valid date of birth';

  // Gender
  static const String genderRequired = 'Gender is required';
}

/// Centralized error messages and codes for the application
class AppErrors {
  AppErrors._(); // Private constructor to prevent instantiation

  // Network Errors
  static const String noInternet = 'No internet connection';
  static const String timeout = 'Request timeout. Please try again';
  static const String unknownNetwork = 'Network error occurred';
  static const String poorConnection = 'Poor internet connection';

  // Server Errors
  static const String serverError = 'Server error. Please try again later';
  static const String serviceUnavailable = 'Service temporarily unavailable';
  static const String badGateway = 'Bad gateway error';

  // Authentication Errors
  static const String unauthorized = 'Unauthorized access';
  static const String sessionExpired =
      'Your session has expired. Please login again';
  static const String invalidCredentials = 'Invalid email or password';
  static const String accountDisabled = 'Your account has been disabled';
  static const String emailAlreadyExists = 'Email already registered';
  static const String weakPassword = 'Password is too weak';

  // Validation Errors
  static const String invalidEmail = 'Please enter a valid email address';
  static const String requiredField = 'This field is required';
  static const String invalidPhoneNumber = 'Please enter a valid phone number';
  static const String passwordMismatch = 'Passwords do not match';

  // Resource Errors
  static const String notFound = 'Resource not found';
  static const String permissionDenied = 'Permission denied';
  static const String insufficientStorage = 'Insufficient storage space';

  // Cache Errors
  static const String cacheError = 'Failed to load cached data';
  static const String cacheWriteError = 'Failed to save data locally';

  // Parsing Errors
  static const String parsingError = 'Failed to process data';
  static const String invalidDataFormat = 'Invalid data format received';

  // Generic Errors
  static const String unknownError = 'An unexpected error occurred';
  static const String tryAgain = 'Something went wrong. Please try again';
  static const String requestCancelled = 'Request was cancelled';

  // Feature-specific errors (organize by feature)
  // Health Records
  static const String healthRecordNotFound = 'Health record not found';
  static const String healthRecordUploadFailed =
      'Failed to upload health record';

  // Appointments
  static const String appointmentBookingFailed = 'Failed to book appointment';
  static const String appointmentNotFound = 'Appointment not found';

  // Add more feature-specific errors as needed
}

/// Error codes for tracking and analytics
class AppErrorCodes {
  AppErrorCodes._();

  // Network
  static const String noInternet = 'NET_001';
  static const String timeout = 'NET_002';
  static const String unknownNetwork = 'NET_003';

  // Server
  static const String serverError = 'SRV_001';
  static const String serviceUnavailable = 'SRV_002';

  // Auth
  static const String unauthorized = 'AUTH_001';
  static const String sessionExpired = 'AUTH_002';
  static const String invalidCredentials = 'AUTH_003';

  // Add more codes as needed
}

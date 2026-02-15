/// Centralized error messages and codes for the application
class AppErrors {
  AppErrors._(); // Private constructor to prevent instantiation

  // Network Errors
  static const String noInternet = 'No internet connection';
  static const String networkConnectionFailed = 'Network connection failed';
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
  static const String cacheOperationFailed = 'Cache operation failed';
  static const String cacheDataNotFound = 'Data not found in cache';

  // Parsing Errors
  static const String parsingError = 'Failed to process data';
  static const String invalidDataFormat = 'Invalid data format received';

  // API Errors
  static const String apiRequestFailed = 'API request failed';

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
  static const String networkError = 'NETWORK_ERROR';
  static const String noInternet = 'NO_INTERNET';
  static const String timeout = 'TIMEOUT';
  static const String unknownNetwork = 'UNKNOWN_NETWORK';

  // Server
  static const String serverError = 'SERVER_ERROR';
  static const String serviceUnavailable = 'SERVICE_UNAVAILABLE';

  // Auth
  static const String authError = 'AUTH_ERROR';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String sessionExpired = 'SESSION_EXPIRED';
  static const String invalidCredentials = 'INVALID_CREDENTIALS';

  // Cache
  static const String cacheError = 'CACHE_ERROR';
  static const String cacheReadError = 'CACHE_READ_ERROR';
  static const String cacheWriteError = 'CACHE_WRITE_ERROR';
  static const String cacheNotFound = 'CACHE_NOT_FOUND';
  static const String forbidden = 'FORBIDDEN';

  // Parsing
  static const String parsingError = 'PARSING_ERROR';

  // API
  static const String apiError = 'API_ERROR';
  static const String badRequest = 'BAD_REQUEST';
  static const String notFound = 'NOT_FOUND';
  static const String validationError = 'VALIDATION_ERROR';
  static const String conflict = 'CONFLICT';
  static const String rateLimitExeeded = 'RATE_LIMIT_EXCEEDED';
  static const String accountLocked = 'ACCOUNT_LOCKED';

  // Custom
  static const String unknownError = 'UNKNOWN_ERROR';
  static const String customError = 'CUSTOM_ERROR';
}

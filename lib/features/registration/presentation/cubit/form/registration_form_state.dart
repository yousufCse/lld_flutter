part of 'registration_form_cubit.dart';

abstract class RegisterOperationState extends Equatable {
  const RegisterOperationState();
}

class RegisterInitiateIdle extends RegisterOperationState {
  const RegisterInitiateIdle();

  @override
  List<Object?> get props => [];
}

class RegisterInitiateLoading extends RegisterOperationState {
  const RegisterInitiateLoading();

  @override
  List<Object?> get props => [];
}

class RegisterInitiateSuccess extends RegisterOperationState {
  final RegisterEntity registerEntity;
  const RegisterInitiateSuccess(this.registerEntity);

  @override
  List<Object?> get props => [registerEntity];
}

class RegisterInitiateFailure extends RegisterOperationState {
  final String message;
  final String? code;
  const RegisterInitiateFailure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class RegistrationFormState extends Equatable {
  final String firstName;
  final String lastName;
  final String mobile;
  final DateTime? dob;
  final String gender;
  final bool termsAccepted;
  final RegisterOperationState registerState;

  /// Whether the user has attempted to submit the form.
  /// Errors are only displayed after the first submit attempt.
  final bool submitted;

  /// Computed validation errors — derived from field values + [submitted].
  /// Returns `null` (no error shown) until the form is submitted.
  String? get firstNameError =>
      submitted ? AppValidators.firstName(firstName) : null;

  String? get lastNameError =>
      submitted ? AppValidators.lastName(lastName) : null;

  String? get mobileError => submitted ? AppValidators.phone(mobile) : null;

  String? get dateOfBirthError =>
      submitted ? AppValidators.dateOfBirth(dob?.toIso8601String()) : null;

  String? get genderError => submitted ? AppValidators.gender(gender) : null;

  bool get isValid =>
      AppValidators.firstName(firstName) == null &&
      AppValidators.lastName(lastName) == null &&
      AppValidators.phone(mobile) == null &&
      AppValidators.dateOfBirth(dob?.toIso8601String()) == null &&
      AppValidators.gender(gender) == null;

  const RegistrationFormState({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.dob,
    required this.gender,
    required this.termsAccepted,
    required this.registerState,
    this.submitted = false,
  });

  RegistrationFormState copyWith({
    String? firstName,
    String? lastName,
    String? mobile,
    DateTime? dob,
    String? gender,
    bool? termsAccepted,
    RegisterOperationState? registerState,
    bool? submitted,
  }) {
    return RegistrationFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobile: mobile ?? this.mobile,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      registerState: registerState ?? this.registerState,
      submitted: submitted ?? this.submitted,
    );
  }

  const RegistrationFormState.initial()
    : firstName = '',
      lastName = '',
      mobile = '',
      dob = null,
      gender = '',
      termsAccepted = true,
      registerState = const RegisterInitiateIdle(),
      submitted = false;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    mobile,
    dob,
    gender,
    termsAccepted,
    registerState,
    submitted,
  ];
}

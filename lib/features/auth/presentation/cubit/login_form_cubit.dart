import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'login_form_state.dart';

@injectable
class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void emailChanged(String value) => emit(state.copyWith(email: value));

  void passwordChanged(String value) => emit(state.copyWith(password: value));

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));

  void clear() => emit(const LoginFormState());
}

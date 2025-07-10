import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  DashboardCubit({required this.getCurrentUserUseCase})
    : super(const DashboardState.initial());

  Future<void> fetchCurrentUser() async {
    emit(const DashboardState.loading());
    final result = await getCurrentUserUseCase(NoParams());
    result.fold(
      (failure) => emit(DashboardState.error(message: failure.toString())),
      (user) => emit(DashboardState.loaded(user: user)),
    );
  }
}

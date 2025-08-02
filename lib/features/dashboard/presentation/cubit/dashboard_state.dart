import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';

part 'dashboard_state.freezed.dart';

@freezed
sealed class DashboardState with _$DashboardState {
  const DashboardState._();
  const factory DashboardState.initial() = _DashboardInitial;
  const factory DashboardState.loading() = _DashboardLoading;
  const factory DashboardState.loaded({required User user}) = _DashboardLoaded;
  const factory DashboardState.error({required Failure failure}) =
      _DashboardError;
}

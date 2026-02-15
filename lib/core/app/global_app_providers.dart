import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/di/injectable_container.dart';
import 'package:niramoy_health_app/features/auth/presentation/cubits/auth/auth_cubit.dart';

final blocProviders = [BlocProvider(create: (context) => getIt<AuthCubit>())];

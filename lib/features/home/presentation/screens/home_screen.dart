import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exercise/core/config/app_config.dart';
import 'package:flutter_exercise/core/router/route_names.dart';
import 'package:flutter_exercise/core/services/storage_service.dart';
import 'package:flutter_exercise/core/theme/cubit/theme_cubit.dart';
import 'package:flutter_exercise/core/theme/extensions/app_spacing.dart';
import 'package:flutter_exercise/core/utils/app_logger/app_logger.dart';
import 'package:flutter_exercise/features/home/presentation/cubit/cubit/random_face_cubit.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.storageService,
    required this.appLogger,
  });

  final StorageService storageService;
  final AppLogger appLogger;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppLogger get appLogger => widget.appLogger;
  StorageService get storageService => widget.storageService;
  ThemeCubit get themeCubit => context.read<ThemeCubit>();
  RandomFaceCubit get randomFaceCubit => context.read<RandomFaceCubit>();

  @override
  initState() {
    super.initState();

    appLogger.i('HomeScreen initialized');
    appLogger.w('Flavor: ${AppConfig.instance.flavor.name}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Scaffold(
      appBar: AppBar(title: Text(AppConfig.instance.appName)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push(RouteNames.vitalSign);
              },
              child: const Text('Go to Vital Sign Screen'),
            ),
            SizedBox(height: spacing.large),
            ElevatedButton(
              onPressed: () {
                context.push(RouteNames.themeShowcase);
              },
              child: const Text('Go to Theme Showcase Screen'),
            ),
            SizedBox(height: spacing.large),

            ElevatedButton(
              onPressed: () async {
                randomFaceCubit.fetchRandomFace();
                final int counter = await storageService.getInt('counter') ?? 0;
                await storageService.saveInt('counter', counter + 1);
              },
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<RandomFaceCubit, RandomFaceState>(
              builder: (context, state) {
                if (state is RandomFaceInitial) {
                  return const Text('Press the button to fetch data');
                } else if (state is RandomFaceLoading) {
                  return const CircularProgressIndicator();
                } else if (state is RandomFaceError) {
                  return Text(state.message);
                }

                return Column(
                  children: [
                    Text(
                      state is RandomFaceLoaded
                          ? state.entity.name.toString()
                          : '0',
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                      state is RandomFaceLoaded ? state.entity.imageUrl : '',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

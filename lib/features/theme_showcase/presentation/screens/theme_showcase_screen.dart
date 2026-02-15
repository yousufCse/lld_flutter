import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exercise/core/theme/cubit/theme_cubit.dart';
import 'package:flutter_exercise/core/theme/extensions/app_gradient.dart';
import 'package:flutter_exercise/core/theme/extensions/app_spacing.dart';

class ThemeShowcaseScreen extends StatefulWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  State<ThemeShowcaseScreen> createState() => _ThemeShowcaseScreenState();
}

class _ThemeShowcaseScreenState extends State<ThemeShowcaseScreen> {
  ThemeCubit get themeCubit => context.read<ThemeCubit>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final gradients = theme.extension<AppGradients>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme\'s Widgets Showcase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              themeCubit.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography Examples
            Text('Display Large', style: theme.textTheme.displayLarge),
            SizedBox(height: spacing.small),
            Text('Headline Medium', style: theme.textTheme.headlineMedium),
            SizedBox(height: spacing.small),
            Text('Body Large', style: theme.textTheme.bodyLarge),
            SizedBox(height: spacing.large),

            // Buttons
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            SizedBox(height: spacing.small),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            SizedBox(height: spacing.large),

            // Input Field
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: spacing.large),

            // Card with Gradient
            Container(
              decoration: BoxDecoration(
                gradient: gradients.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(spacing.medium),
              child: Text(
                'Gradient Card',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lld_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:lld_flutter/features/dashboard/domain/entities/user.dart';
import 'package:lld_flutter/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:lld_flutter/features/dashboard/presentation/cubit/dashboard_state.dart';

import '../../../auth/data/models/token_model.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class DashboardPage extends StatefulWidget {
  final TokenModel token;

  const DashboardPage({super.key, required this.token});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? user;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    context.read<DashboardCubit>().fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: () => setState(() {
            isLoading = true;
          }),
          loaded: (user) => setState(() {
            this.user = user;
            isLoading = false;
          }),
          error: (message) => setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          }),
        );
      },
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              actions: [
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    state.maybeMap(
                      initial: (_) {
                        // After logout, we go back to initial state
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const LoginPage()),
                        // );
                      },

                      failure: (state) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    return IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildUserInfoCard(),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard() {
    if (user == null) {
      return const Center(
        child: Text(
          'User data not available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              icon: Icons.person,
              title: 'Name',
              value: user?.fullName ?? 'Not provided',
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.email,
              title: 'Email',
              value: user?.email ?? 'Not provided',
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.phone,
              title: 'Mobile',
              value: user?.mobile ?? 'Not provided',
            ),
            if (user?.dateOfBirth != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.cake,
                title: 'Date of Birth',
                value: user?.dateOfBirth ?? 'Not provided',
              ),
            ],
            if (user?.gender != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.person_outline,
                title: 'Gender',
                value: user?.gender ?? 'Not provided',
              ),
            ],
            if (user?.profession != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.work,
                title: 'Profession',
                value: user?.profession ?? 'Not provided',
              ),
            ],
            if (user?.relationship != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.people,
                title: 'Relationship',
                value: user?.relationship ?? 'Not provided',
              ),
            ],
            if (user?.bloodGroup != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.bloodtype,
                title: 'Blood Group',
                value: user?.bloodGroup ?? 'Not provided',
              ),
            ],
            if (user?.umrId != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.badge,
                title: 'UMR ID',
                value: user?.umrId ?? 'Not provided',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

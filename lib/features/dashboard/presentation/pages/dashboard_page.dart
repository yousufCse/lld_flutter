import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lld_flutter/features/vital_signs/presentation/pages/vital_signs_page.dart";

import "../../../../core/utils/failure_utils.dart";
import "../../../auth/data/models/token_model.dart";
import "../../../auth/presentation/cubit/auth_cubit.dart";
import "../../../auth/presentation/cubit/auth_state.dart";
import "../../../auth/presentation/pages/login_page.dart";
import "../../domain/entities/user.dart";
import "../cubit/dashboard_cubit.dart";
import "../cubit/dashboard_state.dart";

class DashboardPage extends StatefulWidget {
  final TokenModel token;

  const DashboardPage({super.key, required this.token});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? user;
  bool isLoading = true;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                initial: (_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
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
                },
              );
            },
          ),
        ],
      ),
      body: BlocListener<DashboardCubit, DashboardState>(
        listener: (context, state) {
          state.whenOrNull(
            loading: () => setState(() {
              isLoading = true;
            }),
            loaded: (user) => setState(() {
              this.user = user;
              isLoading = false;
            }),
            error: (failure) => setState(() {
              isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(FailureUtils.getFailureMessage(failure)),
                  backgroundColor: Colors.red,
                ),
              );
            }),
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (user != null)
                _buildUserProfileCard(),

              // Add vital signs button at the bottom
              if (user != null)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.favorite),
                      label: const Text(
                        "VIEW VITAL SIGNS",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // Use a simple placeholder for demonstration

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VitalSignsPage(userId: user!.id),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.person,
              title: "Name",
              value: user?.fullName ?? "Not provided",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.email,
              title: "Email",
              value: user?.email ?? "Not provided",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.phone,
              title: "Mobile",
              value: user?.mobile ?? "Not provided",
            ),
            if (user?.dateOfBirth != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.cake,
                title: "Date of Birth",
                value: user!.dateOfBirth!,
              ),
            ],
            if (user?.gender != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.person_outline,
                title: "Gender",
                value: user!.gender!,
              ),
            ],
            if (user?.bloodGroup != null) ...[
              const Divider(),
              _buildInfoRow(
                icon: Icons.bloodtype,
                title: "Blood Group",
                value: user!.bloodGroup!,
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

  // Now using the centralized FailureUtils instead
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/vital_sign.dart';
import '../cubit/vital_sign_cubit.dart';
import '../cubit/vital_sign_state.dart';

class VitalSignsPage extends StatefulWidget {
  final String userId;

  const VitalSignsPage({super.key, required this.userId});

  @override
  State<VitalSignsPage> createState() => _VitalSignsPageState();
}

class _VitalSignsPageState extends State<VitalSignsPage> {
  @override
  void initState() {
    super.initState();
    _fetchLatestVitalSign();
  }

  Future<void> _fetchLatestVitalSign() =>
      context.read<VitalSignCubit>().getLatestVitalSign(widget.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Vital Signs')),
      body: BlocBuilder<VitalSignCubit, VitalSignState>(
        builder: (context, state) {
          return state.when(
            initial: () =>
                const Center(child: Text('No vital sign data available')),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (vitalSign) => _buildVitalSignContent(vitalSign),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $message',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VitalSignCubit>().getLatestVitalSign(
                        widget.userId,
                      );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVitalSignContent(VitalSign vitalSign) {
    String formattedDate = '';
    if (vitalSign.createdDate != null) {
      try {
        final dateTime = DateTime.parse(vitalSign.createdDate!);
        formattedDate = DateFormat('MMMM dd, yyyy HH:mm').format(dateTime);
      } catch (e) {
        formattedDate = vitalSign.createdDate ?? 'N/A';
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vital Signs',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recorded on: $formattedDate',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Divider(),
                  _buildStatItem(
                    'Pulse Rate',
                    '${vitalSign.pulseRate ?? 'N/A'} bpm',
                    Icons.favorite,
                    Colors.red,
                  ),
                  _buildStatItem(
                    'Blood Pressure',
                    vitalSign.bloodPressure ?? 'N/A',
                    Icons.show_chart,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    'Oxygen Saturation',
                    '${vitalSign.oxygenSaturation ?? 'N/A'}%',
                    Icons.air,
                    Colors.lightBlue,
                  ),
                  _buildStatItem(
                    'Respiratory Rate',
                    '${vitalSign.respiratoryRate ?? 'N/A'} bpm',
                    Icons.wheelchair_pickup,
                    Colors.green,
                  ),
                  _buildStatItem(
                    'Hemoglobin',
                    '${vitalSign.hemoglobin ?? 'N/A'} g/dL',
                    Icons.bloodtype,
                    Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),

          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Physical Metrics',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildStatItem(
                    'Height',
                    vitalSign.height ?? 'N/A',
                    Icons.height,
                    Colors.indigo,
                  ),
                  _buildStatItem(
                    'Weight',
                    vitalSign.weight ?? 'N/A',
                    Icons.monitor_weight,
                    Colors.brown,
                  ),
                  _buildStatItem(
                    'BMI',
                    vitalSign.bmi ?? 'N/A',
                    Icons.pie_chart,
                    Colors.deepOrange,
                  ),
                ],
              ),
            ),
          ),

          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health Indicators',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildStatItem(
                    'Stress Level',
                    _capitalize(vitalSign.stressLevel ?? 'N/A'),
                    Icons.sentiment_dissatisfied,
                    Colors.amber,
                  ),
                  _buildStatItem(
                    'Diabetes Risk',
                    _capitalize(vitalSign.diabetesRisk ?? 'N/A'),
                    Icons.warning,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    'Hypertension Risk',
                    _capitalize(vitalSign.hypertensionRisk ?? 'N/A'),
                    Icons.health_and_safety,
                    Colors.red,
                  ),
                  _buildStatItem(
                    'Recovery Ability',
                    _capitalize(vitalSign.recoveryAbility ?? 'N/A'),
                    Icons.restore,
                    Colors.teal,
                  ),
                  _buildStatItem(
                    'Wellness Score',
                    _capitalize(vitalSign.wellnessScore ?? 'N/A'),
                    Icons.star,
                    Colors.amber,
                  ),
                ],
              ),
            ),
          ),

          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Advanced Metrics',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildStatItem(
                    'Mean RRI',
                    vitalSign.meanRri ?? 'N/A',
                    Icons.timeline,
                    Colors.deepPurple,
                  ),
                  _buildStatItem(
                    'LF/HF Ratio',
                    vitalSign.lfhf ?? 'N/A',
                    Icons.stacked_line_chart,
                    Colors.indigo,
                  ),
                  _buildStatItem(
                    'PNS Index',
                    vitalSign.pnsindex ?? 'N/A',
                    Icons.insights,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),

          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildStatItem(
                    'Location',
                    vitalSign.location ?? 'N/A',
                    Icons.location_on,
                    Colors.red,
                  ),
                  _buildStatItem(
                    'Temperature',
                    vitalSign.locationTemperature != null
                        ? '${vitalSign.locationTemperature}°C'
                        : 'N/A',
                    Icons.thermostat,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    'Coordinates',
                    '${vitalSign.latitude ?? 'N/A'}, ${vitalSign.longitude ?? 'N/A'}',
                    Icons.explore,
                    Colors.blueGrey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

import 'package:flutter/material.dart';

class VitalSignScreen extends StatefulWidget {
  const VitalSignScreen({super.key});

  @override
  State<VitalSignScreen> createState() => _VitalSignScreenState();
}

class _VitalSignScreenState extends State<VitalSignScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Vital Sign Screen'),
        ),
      ),
    );
  }
}

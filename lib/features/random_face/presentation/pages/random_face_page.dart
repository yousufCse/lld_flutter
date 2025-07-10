import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/failure_utils.dart';
import '../bloc/face_cubit.dart';
import '../bloc/face_state.dart';
import '../widgets/face_display_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display_widget.dart';

class RandomFacePage extends StatelessWidget {
  const RandomFacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Face Generator')),
      body: BlocBuilder<FaceCubit, FaceState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: MessageDisplayWidget(
                message: 'Press the button to get a random face!',
              ),
            ),
            loading: () => const LoadingWidget(),
            loaded: (face) => FaceDisplayWidget(face: face),
            error: (failure) => MessageDisplayWidget(
              message: FailureUtils.getFailureMessage(failure),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<FaceCubit>().fetchRandomFace();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // Now using the centralized FailureUtils instead
}

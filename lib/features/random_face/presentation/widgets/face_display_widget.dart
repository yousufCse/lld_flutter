import 'package:flutter/material.dart';

import '../../domain/entities/face.dart';

class FaceDisplayWidget extends StatelessWidget {
  final Face face;

  const FaceDisplayWidget({super.key, required this.face});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              face.imageUrl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 100, color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Age: ${face.age}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'Gender: ${face.gender}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text('ID: ${face.id}', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

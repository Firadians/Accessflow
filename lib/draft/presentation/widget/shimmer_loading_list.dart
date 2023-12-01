import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingList extends StatelessWidget {
  const ShimmerLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // You can adjust the number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 242, 242, 242),
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 60, // Adjust the height as needed
          ),
        );
      },
    );
  }
}

class ShimmerLoadingDroplist extends StatelessWidget {
  const ShimmerLoadingDroplist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1, // You can adjust the number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 242, 242, 242),
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 60, // Adjust the height as needed
          ),
        );
      },
    );
  }
}

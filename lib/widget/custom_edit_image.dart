import 'package:flutter/material.dart';

class CustomEditImage extends StatelessWidget {
  const CustomEditImage({
    super.key,
    required this.image,
    this.onTap,
  });

  final String image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Image.asset(
          image,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}

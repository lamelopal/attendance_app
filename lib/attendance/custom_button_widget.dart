import 'package:flutter/material.dart';

class custom_button_widget extends StatelessWidget {
  final String imageAssetPath;
  final String title;
  final Widget targetPage;

  const custom_button_widget({
    super.key,
    required this.imageAssetPath,
    required this.title,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 14,
      color: Colors.white,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(
            width: 3,
            color: const Color(0xff17B8A6),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => targetPage,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageAssetPath,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

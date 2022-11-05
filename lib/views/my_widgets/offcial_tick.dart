import 'package:flutter/material.dart';

class OfficialTick extends StatelessWidget {
  const OfficialTick({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Color(0xff4b94e6)),
      child: const Center(
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 8,
        ),
      ),
    );
  }
}

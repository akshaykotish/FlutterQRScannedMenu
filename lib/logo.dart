import 'package:flutter/material.dart';

class logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 100,
          left: 50,
          right: 50,
          bottom: 50
        ),
        child: Image.asset("Assets/logo.png"),
      ),
    ) ;
  }
}

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String placeholder;
  double padding;
  bool hidetext;
  CustomTextField({
    required this.placeholder,
    this.padding = 0.0,
    this.hidetext = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          labelText: placeholder,
        ),
        obscureText: hidetext,
      ),
    );
  }
}

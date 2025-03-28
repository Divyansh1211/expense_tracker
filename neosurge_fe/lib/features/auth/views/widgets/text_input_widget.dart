import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputFieldWidget extends StatelessWidget {
  final String title;
  final TextInputType? type;
  final bool? obscureText;
  final TextEditingController controller;
  const InputFieldWidget({
    required this.controller,
    this.obscureText,
    this.type,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      keyboardType: type,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: title,
        hintStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

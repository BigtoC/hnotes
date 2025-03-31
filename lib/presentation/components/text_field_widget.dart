import "package:flutter/material.dart";
import "package:flutter/services.dart";

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String fieldLabel;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter> formatters;

  const TextFieldWidget({super.key, 
    required this.controller,
    required this.fieldLabel,
    required this.hintText,
    required this.keyboardType,
    required this.formatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(1, 10, 1, 5),
        child: TextField(
          enableIMEPersonalizedLearning: false,
          enableSuggestions: false,
          autocorrect: false,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: fieldLabel,
            hintText: hintText,
          ),
          keyboardType: keyboardType,
          inputFormatters: formatters,
        ));
  }
}

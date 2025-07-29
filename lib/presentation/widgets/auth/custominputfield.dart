import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  // final String initialValue;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;
  final String? Function(String?) validator;
  final TextEditingController controller;
  const InputField({
    super.key,
    required this.label,
    // required this.initialValue,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
    required this.validator,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        TextFormField(
          validator: validator,
          controller: controller,
          // initialValue: initialValue,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: onVisibilityToggle,
                    )
                    : null,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

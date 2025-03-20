import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator; 

  const InputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            suffixIcon: Tooltip(
              message: 'Чтобы получить ключ, свяжитесь с начальником',
              waitDuration: const Duration(milliseconds: 500),
              showDuration: const Duration(seconds: 2),
              child: IconButton(
                icon: const Icon(Icons.help_outline, color: Colors.blue),
                onPressed: () {
                },
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

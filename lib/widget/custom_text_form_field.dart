// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    required this.isPassword,
    this.prefixIcon,
    this.controller,
    this.labelText,
    this.initialValue,
    this.onSaved,
    this.validator,
  });

  final String? hintText;
  final bool isPassword;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final String? labelText;
  final String? initialValue;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        onSaved: widget.onSaved,
        validator: widget.validator,
        textAlign: TextAlign.left,
        initialValue: widget.initialValue,
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscured : false,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          fillColor: const Color(0xff000000),
          filled: true,
          contentPadding: const EdgeInsets.all(10),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 40, 108, 210),
              width: 3,
            ),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.grey)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    color: Colors.grey[400],
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

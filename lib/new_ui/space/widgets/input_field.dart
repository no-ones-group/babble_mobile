import 'package:flutter/cupertino.dart';

class InputField extends StatelessWidget {
  final Widget? prefix, suffix;
  final Function(String)? onSubmitted, onChanged;
  final TextEditingController controller;
  const InputField(
      {super.key,
      required this.controller,
      this.prefix,
      this.suffix,
      this.onSubmitted,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      suffix: suffix,
      prefix: prefix,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      style: const TextStyle(
        fontSize: 22,
        color: Color.fromARGB(255, 255, 184, 78),
      ),
      controller: controller,
      cursorColor: const Color.fromARGB(255, 73, 218, 238),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 255, 184, 78),
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      onSubmitted: (value) => onSubmitted,
      onChanged: (value) => controller.text = value,
    );
  }
}

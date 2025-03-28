import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Function()? onTap;
  const DrawerWidget({
    this.onTap,
    this.icon,
    this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title!,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

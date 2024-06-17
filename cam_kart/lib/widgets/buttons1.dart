import 'package:flutter/material.dart';

class new_button1 extends StatelessWidget {
  final String text;
  final IconData ic;
  final Function()? onTap;
  const new_button1({
    Key? key,
    required this.text,
    required this.ic,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Container(
            padding: const EdgeInsets.all(1.5),
            color: const Color(0xFF6200EE),
            child: ClipOval(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(0.1),
                child: IconButton(
                  onPressed: onTap,
                  icon: Icon(ic, size: 32,color: Color(0xFF6200EE)),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            text,
            style: const TextStyle(
                color: Color(0xFF6200EE), fontWeight: FontWeight.w700, fontSize: 17),
          ),
        ),
      ],
    );
  }
}
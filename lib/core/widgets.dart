import 'package:flutter/material.dart';

import 'themes.dart';

class MyText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;

  const MyText(this.text, {super.key, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.body.copyWith(fontSize: fontSize, color: color),
    );
  }
}

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final void Function() onPressed;

  const MyIconButton({
    super.key,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: backgroundColor,
        child: IconButton(
          icon: Icon(icon, color: iconColor),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  final Color? color;
  final void Function()? onTap;

  const MyListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget item = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: leading,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 4, top: 14, right: 4, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, if (subtitle != null) subtitle!],
              ),
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: trailing,
          )
        ],
      ),
    );

    return Container(
      color: color,
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: item,
              ),
            )
          : item,
    );
  }
}

// InkWell(
//   onTap: onTap!,
//   child: Ink(
//     decoration: ShapeDecoration(
//       color: color,
//       shape: const Border(),
//     ),
//     child: item,
//   ),
// )

import 'package:flutter/material.dart';

class ProfileDetailsCard extends StatelessWidget {
  final List<Widget> children;
  final Color backgroundColor;
  final EdgeInsets padding;

  const ProfileDetailsCard({
    super.key,
    required this.children,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: backgroundColor,
        width: MediaQuery.of(context).size.width,
        child: Padding(padding: padding, child: Column(children: children)),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Widget? trailing;
  final double spacing;

  const InfoRow({
    super.key,
    required this.icon,
    this.text,
    this.trailing,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Visibility(
          visible: text != null,
          child: Expanded(
            child: Text(text ?? '', style: TextStyle(color: Colors.black)),
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: 50),
          trailing!,
        ] else
          SizedBox(width: 20),
      ],
    );
  }
}

class HeaderInfoRow extends StatelessWidget {
  final IconData icon;
  final String? text;
  final bool trailing;
  final double spacing;

  const HeaderInfoRow({
    super.key,
    required this.icon,
    this.text,
    this.trailing=false,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Visibility(
          visible: text != null,
          child: Expanded(
            child: Text(
              text ?? '',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (trailing ) ...[
          SizedBox(width: 50),
          Icon(Icons.more_horiz),
        ] else
          SizedBox(width: 20),
      ],
    );
  }
}

class ActionContainer extends StatelessWidget {
  final String content;
  final Color backgroundColor;
  final EdgeInsets padding;
  final Color? textColor;
  const ActionContainer({
    super.key,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,

    this.padding = const EdgeInsets.all(20),
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return 
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: backgroundColor,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

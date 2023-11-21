import 'package:flutter/material.dart';

class AvatarView extends StatelessWidget {
  final String? imagePath;
  final String text;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final GestureTapCallback? onTap;

  const AvatarView(
      {this.imagePath,
      this.text = '',
      this.radius = 35,
      this.borderWidth = 1,
      this.borderColor = Colors.grey,
      this.backgroundColor = Colors.grey,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    const String assetImage = 'assets/loading-actor.gif';
    final Widget actorInitials = _ActorInitials(
        radius: radius,
        borderWidth: borderWidth,
        backgroundColor: backgroundColor,
        text: text);

    final Widget child = imagePath != null
        ? FadeInImage(
            placeholder: const AssetImage(assetImage),
            image: NetworkImage(
              imagePath!,
            ),
            imageErrorBuilder: (_, __, ___) => actorInitials,
            height: radius * 2,
            width: radius * 2,
            fit: BoxFit.cover,
          )
        : actorInitials;

    return _Layout(
        imagePath: imagePath,
        text: text,
        radius: radius,
        borderWidth: borderWidth,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        onTap: onTap,
        child: child);
  }
}

class _Layout extends StatelessWidget {
  final String? imagePath;
  final String text;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final GestureTapCallback? onTap;
  final Widget child;
  const _Layout({
    this.imagePath,
    required this.text,
    required this.radius,
    required this.borderWidth,
    required this.borderColor,
    required this.backgroundColor,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            height: radius * 2,
            width: radius * 2,
            padding: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: borderColor),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Container(
                    padding: EdgeInsets.all(borderWidth),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: backgroundColor),
                    child: child))));
  }
}

class _ActorInitials extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final Color backgroundColor;
  final String text;
  const _ActorInitials(
      {required this.radius,
      required this.borderWidth,
      required this.backgroundColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
          padding: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: backgroundColor),
          child:
              Center(child: Text(text, style: const TextStyle(fontSize: 16)))),
    );
  }
}

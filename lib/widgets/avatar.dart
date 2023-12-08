import 'package:flutter/material.dart';

class AvatarView extends StatelessWidget {
  final String? image;
  final String text;
  final double size;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final GestureTapCallback? onTap;

  const AvatarView(
      {this.image,
      this.text = '',
      this.size = 70,
      this.borderWidth = 1,
      this.borderColor = Colors.grey,
      this.backgroundColor = Colors.grey,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    const String assetImage = 'assets/loading-actor.gif';
    final Widget actorInitials = _ActorInitials(
        radius: size,
        borderWidth: borderWidth,
        backgroundColor: backgroundColor,
        text: text);

    final Widget child = image != null
        ? FadeInImage(
            placeholder: const AssetImage(assetImage),
            image: NetworkImage(
              image!,
            ),
            imageErrorBuilder: (_, __, ___) => actorInitials,
            height: size * 2,
            width: size * 2,
            fit: BoxFit.cover,
          )
        : actorInitials;

    return _Layout(
        imagePath: image,
        text: text,
        size: size,
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
  final double size;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final GestureTapCallback? onTap;
  final Widget child;
  const _Layout({
    this.imagePath,
    required this.text,
    required this.size,
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
            height: size,
            width: size,
            padding: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size), color: borderColor),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(size),
                child: Container(
                    padding: EdgeInsets.all(borderWidth),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size),
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
    final String initials = text.split(' ').map((e) => e[0]).join();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
          padding: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: backgroundColor),
          child: Center(
              child: Text(initials, style: const TextStyle(fontSize: 16)))),
    );
  }
}

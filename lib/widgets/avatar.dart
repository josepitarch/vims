import 'package:flutter/material.dart';

class AvatarView extends StatelessWidget {
  final String imagePath;
  final String? text;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final GestureTapCallback? onTap;

  const AvatarView(
      {this.imagePath = '',
      this.text,
      this.radius = 35,
      this.borderWidth = 1,
      this.borderColor = Colors.grey,
      this.backgroundColor = Colors.grey,
      this.onTap,
      super.key});

  Widget getTextWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
          padding: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: backgroundColor),
          child: Center(child: Text(text ?? ''))),
    );
  }

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
                child: FadeInImage(
                    placeholder: const AssetImage('assets/loading-actor.gif'),
                    image: NetworkImage(imagePath),
                    height: radius * 2,
                    width: radius * 2,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (_, __, ___) => getTextWidget()),
              ),
            )));
  }
}

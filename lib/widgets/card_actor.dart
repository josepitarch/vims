import 'package:flutter/material.dart';
import 'package:vims/models/actor.dart';
import 'package:vims/widgets/avatar.dart';

class CardActor extends StatelessWidget {
  final Actor actor;

  const CardActor({required this.actor, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final Map<String, dynamic> arguments = {
          'id': actor.id,
          'name': actor.name,
          'image': actor.image?.mmed,
        };
        Navigator.pushNamed(context, 'actor', arguments: arguments);
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarView(image: actor.image?.mmed, text: actor.name),
          const SizedBox(width: 10),
          Text(actor.name, style: const TextStyle(fontSize: 18))
        ]),
      ),
    );
  }
}

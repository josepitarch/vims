import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget header;
  final Widget body;
  const Layout({
    Key? key,
    required this.header,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(
              padding: const EdgeInsets.all(15),
              height: 80,
              width: double.infinity,
              child: header),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: body)),
        ]),
      ),
    );
  }
}

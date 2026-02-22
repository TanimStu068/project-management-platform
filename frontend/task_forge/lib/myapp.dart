import 'package:flutter/material.dart';
import 'package:task_forge/wrapper.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const Wrapper(),
    );
  }
}

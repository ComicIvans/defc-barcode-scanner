import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SheetSelector extends StatefulWidget {
  const SheetSelector({Key? key, required this.googleSignIn}) : super(key: key);

  final GoogleSignIn googleSignIn;

  @override
  State<SheetSelector> createState() => _SheetSelector();
}

class _SheetSelector extends State<SheetSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

import 'package:after_layout/after_layout.dart';
import 'package:defc_barcode_scanner/sheet_selector.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.googleSignIn}) : super(key: key);

  final GoogleSignIn googleSignIn;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  String _scanBarcode = 'Desconocido';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(_scanBarcode)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scanBarcode(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void checkSelectedSheet(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _sheet = (prefs.getString('selectedSheet') ?? '');

    if (widget.googleSignIn.currentUser != null && _sheet == '') {
      final driveApi =
          DriveApi((await widget.googleSignIn.authenticatedClient())!);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SheetSelector(
              googleSignIn: widget.googleSignIn, driveApi: driveApi)));
      return;
    }

    return;
  }

  @override
  void afterFirstLayout(BuildContext context) => checkSelectedSheet(context);
}

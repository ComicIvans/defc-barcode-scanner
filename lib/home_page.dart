import 'package:after_layout/after_layout.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.googleSignIn}) : super(key: key);

  final GoogleSignIn googleSignIn;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _barcode = 'Desconocido';
  bool _openCamera = false;
  late Spreadsheet _spreadsheet;
  late DriveApi _driveApi;
  late SheetsApi _sheetsApi;
  final _sheetId = '1f4bYGUqlDXc9l_hSw6M_zoQ8v6-sQHIiTsThn5oDrl4';

  @override
  void initState() {
    super.initState();
    getSheet();
  }

  @override
  Widget build(BuildContext context) {
    return _openCamera
      ? WillPopScope(
        onWillPop: () async {
          setState(() {
            _openCamera = !_openCamera;
          });
          return false;
        },
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300.0,
              height: 600.0,
              child: QrCamera(
                qrCodeCallback: (code) {
                  if(code != null) {
                    setState(() {
                      _barcode = code;
                      _openCamera = !_openCamera;
                    });
                    writeToSheet(text: code);
                  }
                },
                formats: [BarcodeFormats.CODE_39],
              ),
            ),
          )
        )
      )
      : Scaffold(
        body: Center(child: Text(_barcode)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _openCamera = !_openCamera;
            });
          },
          child: const Icon(Icons.add),
        ),
      );
  }

  getSheet() async {
    final auth.AuthClient? client = await widget.googleSignIn.authenticatedClient();
    if (client != null) {
      _driveApi = await DriveApi(client);
      _sheetsApi = await SheetsApi(client);
      _spreadsheet = await _sheetsApi.spreadsheets.get(_sheetId);
    }
  }

  writeToSheet({String text = ''}) async {
    if (_spreadsheet.sheets != null) {
      final sheet = await _spreadsheet.sheets?.first;
      var response = await _sheetsApi.spreadsheets.values.append(ValueRange(values: [[text]]), _sheetId, "A1", valueInputOption: 'USER_ENTERED', insertDataOption: 'OVERWRITE');
    }
  }
}

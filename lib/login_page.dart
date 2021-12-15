import 'package:defc_barcode_scanner/login_controller.dart';
import 'package:defc_barcode_scanner/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return buildLoginButtons(context);
  }

  Scaffold buildLoginButtons(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DEFC - Registro de Asistencia'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/defc_white.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 120),
              FloatingActionButton.extended(
                heroTag: 'Continuar',
                onPressed: () {},
                label: const Text('Continuar sin iniciar sesión'),
              ),
              const SizedBox(height: 10),
              FloatingActionButton.extended(
                heroTag: 'Google',
                onPressed: () {
                  GoogleSignIn().signIn();
                },
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  height: 32,
                  width: 32,
                ),
                label: const Text('Iniciar sesión con Google'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              const SizedBox(height: 40),
              FloatingActionButton(
                heroTag: 'Ayuda',
                onPressed: () {
                  showHelp(context);
                },
                child: const Text('?'),
                mini: true,
              ),
            ],
          ),
        ));
  }

  void showHelp(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ayuda'),
            content: const Text(
                'La finalidad de esta aplicación es registrar la asistencia directamente en una hoja de cálculo de Google con un código preparado para ello. Por eso la opción preferida es la de iniciar sesión con una cuenga @go.ugr.es. Sin embargo, si esta opción no es viable, se ofrece la posibilidad de guardar localmente el registro de asistencia.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('¡Entendido!')),
            ],
          );
        });
  }
}

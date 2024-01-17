import 'package:flutter/material.dart';

import 'object_detection_scanner.dart';


void main() {
  runApp(const NutriScanApp());
}

class NutriScanApp extends StatelessWidget {
  const NutriScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriScan',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const NutriScanHomePage(),
    );
  }
}

class NutriScanHomePage extends StatelessWidget {
  const NutriScanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[700]!,
              Colors.green[700]!,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Imagen central
            Image.asset('assets/images/logo.jpg'),
            Image.asset('assets/images/LogoLetter2.PNG', height: 100),
            // Nombre NutriScan
            // const Text(
            //   'NutriScan',
            //   style: TextStyle(
            //     fontSize: 64,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            // Botón con GIF
            IconButton(
              icon: Image.asset('assets/images/info.png'),
              iconSize: 100,
              onPressed: () => _showInfoDialog(context),
              padding: const EdgeInsets.all(20.0),
            ),
            // Botón Iniciar Sesión
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green[700], backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ObjectDetectionScanner()),
                );
              },
              child: const Text('Iniciar Sesión'),
            ),
            // Texto al final
          ],
        ),
      ),
    );
  }
  // Función para mostrar el dialog
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[700],
          content: const Text(
            'Esta app encuentra y te dice qué frutas se encuentran en la imagen que le ingreses, inicia sesión y elige una imagen desde la galería o toma una foto para probar su funcionamiento.\n\nDesarrollado por Jose Alejandro Aldama Ramos',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                foregroundColor: Colors.green[700], backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show Platform;

import 'fruit_information.dart';
import 'object_detection.dart';

void main() {
  runApp(const ObjectDetectionScanner());
}

class ObjectDetectionScanner extends StatelessWidget {
  const ObjectDetectionScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final imagePicker = ImagePicker();

  ObjectDetection? objectDetection;

  Uint8List? image;
  String detectedLabel = '';

  @override
  void initState() {
    super.initState();
    objectDetection = ObjectDetection();
  }

  void _clearImageAndLabel() {
    setState(() {
      image = null;
      detectedLabel = '';
    });
  }

  bool isButtonClicked = false;

  void _animateButtonAndClear() {
    setState(() {
      isButtonClicked = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isButtonClicked = false;
        _clearImageAndLabel(); // Llama a la función de limpieza después de la animación
      });
    });
  }

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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('assets/images/LogoLetter2.PNG'),
              Expanded(
                flex: 2,
                child: Center(
                  child: (image != null)
                      ? Image.memory(image!)
                      : const Text(
                          'Selecciona o toma una imagen para analizar',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
              ),
              if (image != null)
                SizedBox(
                  height: 100, // Define aquí la altura deseada
                  child: Center(
                    child: GestureDetector(
                      onTap: _animateButtonAndClear,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isButtonClicked ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: isButtonClicked ? 72 : 64,
                        height: isButtonClicked ? 72 : 64,
                        child: Image.asset('assets/images/clear.png'),
                      ),
                    ),
                  ),
                ),
              // Botón para mostrar información de la fruta
              ElevatedButton(
                onPressed: detectedLabel.isNotEmpty
                    ? () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => FruitInformationScreen(label: detectedLabel),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        // Personaliza la animación aquí
                        var begin = Offset(1.0, 0.0); // Comienza desde la derecha
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                }
                    : null, // Desactivado si no hay etiqueta detectada
                child: const Text('Mostrar Información de la Fruta'),
              ),
              SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (Platform.isAndroid || Platform.isIOS)
                      Expanded(
                        child: IconButton(
                          icon: Image.asset('assets/images/camera.png'),
                          iconSize: 64,
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                      ),
                    Expanded(
                      child: IconButton(
                        icon: Image.asset('assets/images/photo.png'),
                        iconSize: 64,
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _pickImage(ImageSource source) async {
    final result = await imagePicker.pickImage(source: source);
    if (result != null) {
      final detectionResult = objectDetection!.analyseImage(result.path);
      image = detectionResult.imageBytes;
      detectedLabel = detectionResult.label; // Actualizar la etiqueta detectada
      setState(() {});
    }
  }
}

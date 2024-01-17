import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fruit_data.dart';
import 'daily_fruit.dart';

class FruitInformationScreen extends StatelessWidget {
  final String label;

  const FruitInformationScreen({Key? key, required this.label}) : super(key: key);

  String _findClosestMatchingLabel(String inputLabel) {
    inputLabel = inputLabel.replaceAll(' ', '').toLowerCase();
    num closestDistance = double.maxFinite;
    String closestLabel = '';

    fruitNutritionData.forEach((key, value) {
      num distance = _calculateStringDistance(inputLabel, key);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestLabel = key;
      }
    });

    return closestLabel;
  }

  num _calculateStringDistance(String s1, String s2) {
    if (s1 == s2) {
      return 0;
    }
    if (s1.isEmpty) {
      return s2.length;
    }
    if (s2.isEmpty) {
      return s1.length;
    }

    List<int> v0 = List<int>.filled(s2.length + 1, 0);
    List<int> v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < v0.length; i++) {
      v0[i] = i;
    }

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < s2.length; j++) {
        int cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }

      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[s2.length];
  }

  @override
  Widget build(BuildContext context) {
    final matchingLabel = _findClosestMatchingLabel(label);
    final fruitData = fruitNutritionData[matchingLabel] ?? {};
    final maxValue = _findMaxValue(fruitData);
    final String imagePath = 'assets/images/$matchingLabel.png';

    return Scaffold(
      body: Container(
        color: Colors.green[700], // Color de fondo del cuerpo
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/LogoLetter2.PNG'), // Imagen del logo
            Text(
              'Información de $label',
              style: const TextStyle(color: Colors.white, fontSize: 24), // Estilo del texto
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: fruitData.isNotEmpty
                    ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 400,
                        height: 400,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain, // Asegura que la imagen se ajuste al tamaño sin perder sus proporciones
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Información por 100 gramos de alimento:',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ..._buildBarChart(fruitData, maxValue),
                      ElevatedButton(
                        onPressed: () => _showAddDialog(context),
                        child: const Text('Añadir'),
                      ),
                    ],
                  ),
                )
                    : Text(
                  'No hay información disponible para $label',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            SizedBox(
              height: 100, // Define aquí la altura deseada
              child: Center(
                child: IconButton(
                  icon: Image.asset('assets/images/atras.png'),
                  iconSize: 50,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBarChart(Map<String, num> fruitData, num maxValue) {
    final nutritionTypes = ['calories', 'carbs', 'fat', 'protein'];
    final List<Widget> chartBars = [];

    for (var type in nutritionTypes) {
      final value = fruitData[type] ?? 0;
      final barWidth = (value / maxValue) * 200; // Ajusta 200 al ancho deseado del gráfico

      chartBars.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: <Widget>[
              Text(type.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(width: 10),
              Container(
                height: 20,
                width: barWidth,
                color: Colors.red, // Puedes cambiar el color según el tipo de nutriente
              ),
              const SizedBox(width: 10),
              Text(
                '${value}g',
                style: const TextStyle(color: Colors.white), // Color del texto
              ),
            ],
          ),
        ),
      );
    }
    return chartBars;
  }

  num _findMaxValue(Map<String, num> fruitData) {
    num maxVal = 0;
    fruitData.forEach((key, value) {
      if (value > maxVal) {
        maxVal = value;
      }
    });
    return maxVal;
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Cuánta cantidad de $label consumiste?'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Ingresa cantidad en gramos',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Añadir'),
              onPressed: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                final String fruitKey = 'daily_fruit_$label';
                final int amount = int.tryParse(controller.text) ?? 0;
                await prefs.setInt(fruitKey, amount);
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailyFruit(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyFruit extends StatefulWidget {
  @override
  _DailyFruitState createState() => _DailyFruitState();
}

class _DailyFruitState extends State<DailyFruit> {
  Map<String, int> _fruitHistory = {};

  @override
  void initState() {
    super.initState();
    _loadFruitHistory();
  }

  Future<void> _loadFruitHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    setState(() {
      for (String key in keys) {
        if (key.startsWith('daily_fruit_')) {
          _fruitHistory[key.substring(12)] = prefs.getInt(key) ?? 0;
        }
      }
    });
  }

  Future<void> _removeFruit(String fruitKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('daily_fruit_$fruitKey');
    _loadFruitHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Frutas Consumidas'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        itemCount: _fruitHistory.keys.length,
        itemBuilder: (context, index) {
          String key = _fruitHistory.keys.elementAt(index);
          return Card(
            color: Colors.green[700],
            child: ListTile(
              title: Text(
                key,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_fruitHistory[key]} g',
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _removeFruit(key),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

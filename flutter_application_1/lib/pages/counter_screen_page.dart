import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  String _message = 'Toque nos botões para alterar o contador';
  Color _counterColor = Colors.blue;

  void updateMessage() {
    if (_counter == 0) {
      _message = 'Contador Zerado';
    } else if (_counter > 0) {
      _message = 'Contador Positivo $_counter';
    } else {
      _message = 'Contador Negativo $_counter';
    }
  }

  void updateColor() {
    if (_counter > 0) {
      _counterColor = Colors.green;
    } else if (_counter < 0) {
      _counterColor = Colors.red;
    } else {
      _counterColor = Colors.blue;
    }
  }

  void incrementCounter() {
    setState(() {
      _counter++;
      updateColor();
      updateMessage();
    });
  }

  void decrementCounter() {
    setState(() {
      _counter--;
      updateColor();
      updateMessage();
    });
  }

  void resetCounter() {
    setState(() {
      _counter = 0;
      updateColor();
      _message = 'Contador resetado';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador Interativo'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _counterColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _counterColor, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Valor do Contador:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_counter',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _counterColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: decrementCounter,
                    icon: const Icon(Icons.remove),
                    label: const Text('Decrementar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white, // texto branco
                      iconColor: Colors.white, // ícone branco
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: resetCounter,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Resetar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white, // texto branco
                      iconColor: Colors.white, // ícone branco
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text('Incrementar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white, // texto branco
                      iconColor: Colors.white, // ícone branco
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
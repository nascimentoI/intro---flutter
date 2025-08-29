import 'package:flutter/material.dart';

class CounterScreenValueNotifier extends StatefulWidget {
  const CounterScreenValueNotifier({super.key});

  @override
  State<CounterScreenValueNotifier> createState() => _CounterScreenValueNotifierState();
}

class _CounterScreenValueNotifierState extends State<CounterScreenValueNotifier> {
  // Variáveis com ValueNotifier para gerenciar estado simples
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final ValueNotifier<String> _message = ValueNotifier<String>(
    'Toque nos botões para incrementar ou decrementar o contador',
  );
  final ValueNotifier<Color> _counterColor = ValueNotifier<Color>(Colors.blue);

  // Para de ouvir mudanças
  @override
  void dispose() {
    // Liberando recursos corretamente
    _counter.dispose();
    _message.dispose();
    _counterColor.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    _counter.value++;
    _updateMessageAndColor();
  }

  void _decrementCounter() {
    _counter.value--;
    _updateMessageAndColor();
  }

  void _resetCounter() {
    _counter.value = 0;
    _message.value = 'Contador resetado';
    _counterColor.value = Colors.blue;
  }

  void _updateMessageAndColor() {
    if (_counter.value == 0) {
      _message.value = 'Contador zerado';
      _counterColor.value = Colors.blue;
    } else if (_counter.value > 0) {
      _message.value = 'Contador positivo ${_counter.value}';
      _counterColor.value = Colors.green;
    } else {
      _message.value = 'Contador negativo ${_counter.value}';
      _counterColor.value = Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador Interativo com ValueNotifier'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Escuta mudanças na cor
              ValueListenableBuilder<Color>(
                valueListenable: _counterColor,
                builder: (context, color, _) {
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1), // melhor contraste
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: color, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Valor do contador:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),

                        // Escuta mudanças no valor do contador
                        ValueListenableBuilder<int>(
                          valueListenable: _counter,
                          builder: (context, value, _) {
                            return Text(
                              '$value',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Escuta mudanças na mensagem
              ValueListenableBuilder<String>(
                valueListenable: _message,
                builder: (context, msg, _) {
                  return Text(
                    msg,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),

              const SizedBox(height: 40),

              // Botões que mudam o estado via ValueNotifier
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _decrementCounter,
                    icon: const Icon(Icons.remove),
                    label: const Text('Decrementar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _resetCounter,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Resetar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text('Incrementar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
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

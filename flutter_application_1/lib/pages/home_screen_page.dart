import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_card.dart';
import 'package:flutter_application_1/examples/simple_change_notifier_example.dart';
import 'package:flutter_application_1/examples/user_controller.dart';
import 'package:flutter_application_1/examples/value_notifier_counter_screen.dart';
import 'package:flutter_application_1/pages/counter_screen_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                CustomCard(
                  title: 'Counter Screen', 
                  description: 'Exemplo Contador', 
                  icon: Icons.add_circle_outline, 
                  destination: CounterScreenValueNotifier(),

                ),

                CustomCard(
                  title: 'ChangeNotifier Simples', 
                  description: 'Perfil', 
                  icon: Icons.add_circle_outline, 
                  destination: SimpleChangeNotifierExample(),

                ),
              ],
            ),
          )
        ],
        ),
      ),      
    );
  }
}
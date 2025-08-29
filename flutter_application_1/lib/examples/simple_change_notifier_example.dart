import 'package:flutter/material.dart';
import 'package:flutter_application_1/examples/user_controller.dart';

/// Classe modelo usando ChangeNotifier para gerenciar estado complexo
/// ChangeNotifier permite notificar múltiplos listeners sobre mudanças

/// Widget principal que demonstra o uso de ChangeNotifier
class SimpleChangeNotifierExample extends StatefulWidget {
  const SimpleChangeNotifierExample({super.key});

  @override
  State<SimpleChangeNotifierExample> createState() =>
      _SimpleChangeNotifierExampleState();
}

class _SimpleChangeNotifierExampleState
    extends State<SimpleChangeNotifierExample> {
  // Instância do modelo que gerencia o estado
  final UserProfileModel _userModel = UserProfileModel();

  // Controllers para os campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _userModel.name;
  }

  @override
  void dispose() {
    // Dispose do modelo e controllers
    _userModel.dispose();
    _nameController.dispose();
    _hobbyController.dispose();
    super.dispose();
  }

  void _updateName() {
    if (_nameController.text.isNotEmpty) {
      _userModel.updateName(_nameController.text);
    }
  }

  void _addHobby() {
    if (_hobbyController.text.isNotEmpty) {
      _userModel.addHobby(_hobbyController.text);
      _hobbyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChangeNotifier Simples'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card do perfil do usuário
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Perfil do Usuário',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ListenableBuilder escuta mudanças no ChangeNotifier
                      ListenableBuilder(
                        listenable: _userModel,
                        builder: (context, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Nome: ${_userModel.name}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  const Icon(Icons.cake, color: Colors.pink),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Idade: ${_userModel.age} anos',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  const Icon(Icons.email, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Email: ${_userModel.email}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Icon(
                                    _userModel.isOnline
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color:
                                        _userModel.isOnline
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Status: ${_userModel.isOnline ? "Online" : "Offline"}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          _userModel.isOnline
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Card dos hobbies
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hobbies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ListenableBuilder(
                        listenable: _userModel,
                        builder: (context, child) {
                          return Wrap(
                            spacing: 8,
                            children:
                                _userModel.hobbies.map((hobby) {
                                  return Chip(
                                    label: Text(hobby),
                                    onDeleted:
                                        () => _userModel.removeHobby(hobby),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 16,
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Controles de interação
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Campo para atualizar nome
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _updateName,
                            child: const Text('Atualizar'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Campo para adicionar hobby
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _hobbyController,
                              decoration: const InputDecoration(
                                labelText: 'Novo Hobby',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addHobby,
                            child: const Text('Adicionar'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Botões de ação
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed:
                                () => _userModel.updateAge(_userModel.age + 1),
                            icon: const Icon(Icons.add),
                            label: const Text('Idade'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _userModel.toggleOnlineStatus,
                            icon: const Icon(Icons.wifi),
                            label: const Text('Toggle Status'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _userModel.reset,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

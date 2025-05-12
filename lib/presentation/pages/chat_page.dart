import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Reemplazar con cantidad real de mensajes
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Usuario ${index + 1}'),
                    subtitle: Text('Mensaje ${index + 1}'),
                  );
                },
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Escribe un mensaje',
                suffixIcon: Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

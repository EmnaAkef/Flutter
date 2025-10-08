import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'queue_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://golulgrecfwvsrqfadrm.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdvbHVsZ3JlY2Z3dnNycWZhZHJtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkwOTY0OTAsImV4cCI6MjA3NDY3MjQ5MH0.AdCWfKrOj4O6OxpaYiP4-rxyfvqOlO1ZT2A4p-NtYoQ",
  );

  await Supabase.instance.client.auth.signInAnonymously();

  runApp(
    ChangeNotifierProvider(
      create: (_) => QueueProvider(),
      child: const WaitingRoomApp(),
    ),
  );
}

class WaitingRoomApp extends StatelessWidget {
  const WaitingRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waiting Room',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WaitingRoomScreen(),
    );
  }
}

class WaitingRoomScreen extends StatelessWidget {
  const WaitingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final queueProvider = context.watch<QueueProvider>();
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Waiting Room')),
      body: Column(
        children: [
          
          if (queueProvider.hasChange)
            Container(
              color: const Color.fromARGB(255, 28, 196, 140),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(' Changement détecté!'),
                  ElevatedButton(
                    onPressed: () {
                      queueProvider.fetchInitialClients();
                    },
                    child: const Text('Rafraîchir'),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Enter name'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      queueProvider.addClient(controller.text);
                      controller.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: queueProvider.clients.isEmpty
                ? const Center(child: Text('No one in queue yet...'))
                : ListView.builder(
                    itemCount: queueProvider.clients.length,
                    itemBuilder: (context, index) {
                      final client = queueProvider.clients[index];
                      return ListTile(
                        title: Text(client.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            queueProvider.removeClient(client.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => queueProvider.nextClient(),
              child: const Text('Next Client'),
            ),
          ),
        ],
      ),
    );
  }
}

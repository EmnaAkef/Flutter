import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/client.dart';
import 'dart:async';

class QueueProvider extends ChangeNotifier {
  final List<Client> _clients = [];
  List<Client> get clients => _clients;
  bool hasChange = false;
  Timer? _timer;

  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _subscription;

  QueueProvider() {
    _fetchInitialClients();
    _setupRealtimeSubscription();

  }

  Future<void> _fetchInitialClients() async {
    try {
      final data = await _supabase.from('clients').select().order('created_at', ascending: true);
      _clients.clear();
      _clients.addAll((data as List).map((e) => Client.fromMap(e)));
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur fetch clients: $e');
    }
  }

  void _setupRealtimeSubscription() {
    _subscription = _supabase.channel('public:clients')
      ..onPostgresChanges(
        schema: 'public',
        table: 'clients',
        event: PostgresChangeEvent.insert,
        callback: (payload) {
          hasChange = true; 
          notifyListeners();
        },
      )
      ..onPostgresChanges(
        schema: 'public',
        table: 'clients',
        event: PostgresChangeEvent.delete,
        callback: (payload) {
          hasChange = true;
          notifyListeners();
        },
      )
      ..subscribe();
  }

  Future<void> fetchInitialClients() async {
    try {
      final data = await _supabase
          .from('clients')
          .select()
          .order('created_at', ascending: true);

      _clients.clear();
      _clients.addAll((data as List).map((e) => Client.fromMap(e)));
      hasChange = false; 
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur fetch clients: $e');
    }
  }

  Future<void> addClient(String name) async {
    if (name.trim().isEmpty) return;
    try {
      await _supabase.from('clients').insert({'name': name.trim()});
    } catch (e) {
      debugPrint('Erreur addClient: $e');
    }
  }

  Future<void> removeClient(String id) async {
    try {
      await _supabase.from('clients').delete().match({'id': id});
    } catch (e) {
      debugPrint('Erreur removeClient: $e');
    }
  }

  Future<void> nextClient() async {
    if (_clients.isNotEmpty) await removeClient(_clients.first.id);
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    _timer?.cancel();
    super.dispose();
  }
}

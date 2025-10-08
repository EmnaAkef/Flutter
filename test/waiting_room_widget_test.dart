import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waiting_room_app/main.dart';
import 'package:provider/provider.dart'; // Ajouté pour le test
import 'package:waiting_room_app/queue_provider.dart'; // Ajouté pour le test

void main() {
  testWidgets('should add a new client to the list on button tap',
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => QueueProvider(),
      child: const WaitingRoomApp(),
    ),);

    // ACT
    await tester.enterText(find.byType(TextField).first, 'Alice');
  await tester.tap(find.byType(ElevatedButton).first);
  await tester.pump(); // Rebuild l'UI

    // ASSERT
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Clients in Queue: 1'), findsOneWidget);
  });

  testWidgets(
      'should remove a client from the list when the delete button is tapped',
      (WidgetTester tester) async {
// ARRANGE
    await tester.pumpWidget(
  ChangeNotifierProvider(
    create: (_) => QueueProvider(),
    child: const WaitingRoomApp(),
  ),
);
    await tester.enterText(find.byType(TextField), 'Bob');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
// ACT
// Find the delete icon associated with 'Bob' and tap it.
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
// ASSERT
    expect(find.text('Bob'), findsNothing);
    expect(find.text('Clients in Queue: 0'), findsOneWidget);
  });

  testWidgets(
      'should remove the first client from the list when "Next Client" is tapped',
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => QueueProvider(),
        child: const WaitingRoomApp(), 
      ),
    );

    // 1. Ajouter deux clients
    await tester.enterText(find.byType(TextField), 'Client A');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Client B');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // L'état est maintenant : [Client A, Client B]

    // ACT
    // Trouver et appuyer sur le nouveau bouton "Next Client" (on utilise une Key pour le trouver)
    await tester.tap(find.byKey(const Key('nextClientButton')));
    await tester.pump(); // Reconstruire l'UI après l'action

    // ASSERT
    expect(find.text('Client A'), findsNothing); // Client A doit disparaître
    expect(find.text('Client B'), findsOneWidget); // Client B doit rester
    expect(find.text('Clients in Queue: 1'),
        findsOneWidget); // Le compte doit être 1
  });
}

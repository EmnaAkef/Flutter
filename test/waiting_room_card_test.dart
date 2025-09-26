// test/waiting_room_card_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:waiting_room_app/waiting_room_card.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Waiting RoomCard displays the name correctly', (WidgetTester tester) async {
    // Build our widget.
    // Nous enveloppons le widget à tester dans un MaterialApp pour simuler l'environnement de l'application.
    await tester.pumpWidget(
      const MaterialApp(
        home: WaitingRoomCard(name: 'Alice'),
      ),
    );

    // Verify that the widget renders the correct text elements.
    // On vérifie que le texte "Hello," est présent.
    expect(find.text('Hello,'), findsOneWidget);
    // On vérifie que le nom 'Alice' passé en paramètre est correctement affiché.
    expect(find.text('Alice'), findsOneWidget);
  });
}
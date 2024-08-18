import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stori_app/models/contact.dart';
import 'package:stori_app/screens/contact_form_screen.dart';

void main() {
  // Grouping related tests for the ContactFormScreen
  group('ContactFormScreen', () {
    // Test to verify that the form is displayed empty for a new contact
    testWidgets('should display empty form for new contact', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ContactFormScreen(),
      ));

      // Check if the form elements are displayed correctly
      expect(find.text('Add Contact'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Address'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    // Test to verify that the form is populated with contact data for editing
    testWidgets('should display form with contact data for editing', (WidgetTester tester) async {
      final contact = Contact(id: 1, name: 'John Doe', phone: '1234567890', email: 'john@mail.com', address: '123 Main St');
      
      await tester.pumpWidget(MaterialApp(
        home: ContactFormScreen(contact: contact),
      ));

      // Check if the form elements are populated with the contact data
      expect(find.text('Edit Contact'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'John Doe'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '1234567890'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'john@mail.com'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '123 Main St'), findsOneWidget);
    });

    // Test to verify that error messages are shown for empty fields
    testWidgets('should show error messages for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ContactFormScreen(),
      ));

      // Simulate tapping the Save button without entering any data
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Check if the error messages are displayed
      expect(find.text('Please enter a name'), findsOneWidget);
      expect(find.text('Please enter a phone number'), findsOneWidget);
      expect(find.text('Please enter an email'), findsOneWidget);
      expect(find.text('Please enter an address'), findsOneWidget);
    });

    // Test to verify that a new contact is saved when the form is valid
    testWidgets('should save new contact when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ContactFormScreen(),
      ));

      // Enter valid data into the form fields
      await tester.enterText(find.byType(TextFormField).at(0), 'Jane Doe');
      await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
      await tester.enterText(find.byType(TextFormField).at(2), 'jane@mail.com');
      await tester.enterText(find.byType(TextFormField).at(3), '123 Main St');
      
      // Simulate tapping the Save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Check if the form was submitted and the screen was popped
      expect(find.byType(ContactFormScreen), findsNothing);
    });

    // Test to verify that an existing contact is updated when the form is valid
    testWidgets('should update existing contact when form is valid', (WidgetTester tester) async {
      final contact = Contact(id: 1, name: 'John Doe', phone: '1234567890', email: 'john@mail.com', address: '123 Main St');
      
      await tester.pumpWidget(MaterialApp(
        home: ContactFormScreen(contact: contact),
      ));

      // Enter new data into the form fields
      await tester.enterText(find.byType(TextFormField).at(0), 'John Smith');
      await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
      await tester.enterText(find.byType(TextFormField).at(2), 'john@mail.com');
      await tester.enterText(find.byType(TextFormField).at(3), '456 Elm St');
      
      // Simulate tapping the Save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Check if the form was submitted and the screen was popped
      expect(find.byType(ContactFormScreen), findsNothing);
    });

    // Test to verify that invalid email shows error message
    testWidgets('should show error message for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ContactFormScreen(),
      ));

      // Enter invalid email into the form field
      await tester.enterText(find.byType(TextFormField).at(2), 'invalidemail');
      
      // Simulate tapping the Save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Check if the error message is displayed
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });
  });
}

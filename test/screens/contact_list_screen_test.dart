import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stori_app/models/contact.dart';
import 'package:stori_app/screens/contact_list_screen.dart';
import 'package:stori_app/services/contact_api_service.dart';

// Mock implementation of the ContactApiService for testing purposes
class MockContactApiService extends ContactApiService {
  // List to hold mock contacts
  List<Contact> mockContacts = [];

  @override
  Future<List<Contact>> getContacts() async {
    // Simulate a small delay to mimic a real asynchronous operation
    await Future.delayed(const Duration(milliseconds: 100));
    return mockContacts;
  }

  @override
  Future<void> deleteContact(int id) async {
    mockContacts.removeWhere((contact) => contact.id == id);
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    mockContacts.add(contact);
    return contact;
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    final index = mockContacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      mockContacts[index] = contact;
    }
    return contact;
  }
}

void main() {
  // Grouping related tests for the ContactListScreen
  group('ContactListScreen', () {
    // Declare a variable to hold the mock API service
    late MockContactApiService mockApiService;

    // Set up the mock API service before each test
    setUp(() {
      mockApiService = MockContactApiService();
    });

    // Test to verify that contacts are displayed on the screen
    testWidgets('should display contacts', (WidgetTester tester) async {
      // Set up mock contacts
      mockApiService.mockContacts = [
        Contact(
            id: 1,
            name: 'John Doe',
            phone: '3131234567',
            email: 'john@mail.com',
            address: '123 Main St'),
        Contact(
            id: 2,
            name: 'Jane Doe',
            phone: '3137654321',
            email: 'jane@mail.com',
            address: '123 Main St'),
      ];

      // Build the ContactListScreen widget with the mock API service
      await tester.pumpWidget(MaterialApp(
        home: ContactListScreen(apiService: mockApiService),
      ));

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the contacts are displayed on the screen
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('3131234567'), findsOneWidget);
      expect(find.text('3137654321'), findsOneWidget);
    });

    // Test to verify that a floating action button is present on the screen
    testWidgets('should have a floating action button',
        (WidgetTester tester) async {
      // Build the ContactListScreen widget with the mock API service
      await tester.pumpWidget(MaterialApp(
        home: ContactListScreen(apiService: mockApiService),
      ));

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that a floating action button is present
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    // Test to verify that a contact can be deleted
    testWidgets('should delete a contact', (WidgetTester tester) async {
      // Set up mock contacts
      mockApiService.mockContacts = [
        Contact(
            id: 1,
            name: 'John Doe',
            phone: '3131234567',
            email: 'john@mail.com',
            address: '123 Main St'),
      ];

      // Build the ContactListScreen widget with the mock API service
      await tester.pumpWidget(MaterialApp(
        home: ContactListScreen(apiService: mockApiService),
      ));

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the contact is displayed on the screen
      expect(find.text('John Doe'), findsOneWidget);

      // Tap the delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify that the contact is deleted
      expect(find.text('John Doe'), findsNothing);
    });
  });
}

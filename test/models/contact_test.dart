import 'package:flutter_test/flutter_test.dart';
import 'package:stori_app/models/contact.dart';

void main() {
  // Grouping related tests for the Contact model
  group('Contact', () {
    // Test to verify the creation of a Contact instance
    test('should create a Contact instance', () {
      final contact = Contact(id: 1, name: 'John Doe', phone: '3131234567', email: 'john@gmail.com', address: '123 Main St');
      expect(contact.id, 1);
      expect(contact.name, 'John Doe');
      expect(contact.phone, '3131234567');
      expect(contact.email, 'john@gmail.com');
      expect(contact.address, '123 Main St');
    });

    // Test to verify the conversion of a Contact instance to JSON
    test('should convert to JSON', () {
      final contact = Contact(id: 1, name: 'John Doe', phone: '3131234567', email: 'john@gmail.com', address: '123 Main St');
      final json = contact.toJson();
      expect(json, {
        'id': 1,
        'name': 'John Doe',
        'phone': '3131234567',
        'email': 'john@gmail.com',
        'address': '123 Main St',
      });
    });

    // Test to verify the creation of a Contact instance from JSON
    test('should create Contact from JSON', () {
      final json = {
        'id': 1,
        'name': 'John Doe',
        'phone': '3131234567',
        'email': 'john@gmail.com',
        'address': '123 Main St',
      };
      final contact = Contact.fromJson(json);
      expect(contact.id, 1);
      expect(contact.name, 'John Doe');
      expect(contact.phone, '3131234567');
      expect(contact.email, 'john@gmail.com');
      expect(contact.address, '123 Main St');
    });
  });
}
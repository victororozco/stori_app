import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ContactApiService {
  final String baseUrl = const String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:8000/api');

  const ContactApiService();

  Future<List<Contact>> getContacts() async {
    final response = await http.get(Uri.parse('$baseUrl/v1/contacts/'));
    if (response.statusCode == 200) {
      final List<dynamic> contactsJson = jsonDecode(response.body);
      return contactsJson.map((c) => Contact.fromJson(c)).toList();
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['detail']?[0]?['msg'] ?? errorResponse['detail']);
    }
  }

  Future<Contact> getContact(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/v1/contacts/$id'));
    if (response.statusCode == 200) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['detail']?[0]?['msg'] ?? errorResponse['detail']);
    }
  }

  Future<Contact> createContact(Contact contact) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/contacts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(contact.toJson()),
    );
    if (response.statusCode == 201) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['detail']?[0]?['msg'] ?? errorResponse['detail']);
    }
  }

  Future<Contact> updateContact(Contact contact) async {
    final response = await http.put(
      Uri.parse('$baseUrl/v1/contacts/${contact.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(contact.toJson()),
    );
    if (response.statusCode == 200) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['detail']?[0]?['msg'] ?? errorResponse['detail']);
    }
  }

  Future<void> deleteContact(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/v1/contacts/$id'));
    if (response.statusCode != 200) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['detail']?[0]?['msg'] ?? errorResponse['detail']);
    }
  }
}
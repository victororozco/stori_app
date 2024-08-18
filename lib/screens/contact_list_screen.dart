import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'contact_form_screen.dart';
import '../services/contact_api_service.dart';

class ContactListScreen extends StatefulWidget {
  final ContactApiService apiService;

  const ContactListScreen({super.key, required this.apiService});

  @override
  ContactListScreenState createState() => ContactListScreenState();
}

class ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final loadedContacts = await widget.apiService.getContacts();
      if (!mounted) return;
      setState(() {
        contacts = loadedContacts;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showErrorSnackBar(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _deleteContact(Contact contact) async {
    try {
      await widget.apiService.deleteContact(contact.id!);
      if (!mounted) return;
      setState(() {
        contacts.remove(contact);
      });
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 16, 121, 137),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : contacts.isEmpty
              ? const Center(
                  child: Text(
                    'You have no contacts yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        title: Text(
                          contact.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(contact.phone),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editContact(contact),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteContact(contact),
                            ),
                          ],
                        ),
                        onTap: () => _editContact(contact),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        backgroundColor: const Color.fromARGB(255, 16, 121, 137),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _addContact() async {
    final newContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (_) => const ContactFormScreen()),
    );
    if (newContact != null && mounted) {
      try {
        final createdContact = await widget.apiService.createContact(newContact);
        if (!mounted) return;
        setState(() {
          contacts.add(createdContact);
        });
      } catch (e) {
        if (!mounted) return;
        _showErrorSnackBar(e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> _editContact(Contact contact) async {
    final updatedContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (_) => ContactFormScreen(contact: contact)),
    );
    if (updatedContact != null && mounted) {
      try {
        final savedContact = await widget.apiService.updateContact(updatedContact);
        if (!mounted) return;
        setState(() {
          final index = contacts.indexWhere((c) => c.id == savedContact.id);
          if (index != -1) {
            contacts[index] = savedContact;
          }
        });
      } catch (e) {
        if (!mounted) return;
        _showErrorSnackBar(e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }
}
import 'package:flutter/material.dart';
import 'package:stori_app/services/contact_api_service.dart';
import 'screens/contact_list_screen.dart';

void main() {
  ContactApiService contactApiService = const ContactApiService();
  
  runApp(MyApp(contactApiService: contactApiService));
}

class MyApp extends StatelessWidget {
  final ContactApiService contactApiService;

  const MyApp({super.key, required this.contactApiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stori Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListScreen(apiService: contactApiService),
    );
  }
}

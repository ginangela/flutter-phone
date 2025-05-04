import 'package:flutter/material.dart';
import 'pages/contact.dart';
import 'pages/add_contact.dart';
import 'pages/edit_contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const ContactsPage(),
        '/add': (context) => const AddContactPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final contact = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => EditContactPage(contact: contact),
          );
        }
        return null;
      },
    );
  }
}

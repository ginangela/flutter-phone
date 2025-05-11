import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Untuk platform selain web
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Untuk web
import 'package:flutter/foundation.dart'; // Tambahkan ini
import 'pages/contact.dart';
import 'pages/add_contact.dart';
import 'pages/edit_contact.dart';
import 'models/contact_model.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS)) {
    // Hanya untuk desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Calsans',
        primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const ContactsPage(),
        '/add': (context) => const AddContactPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final contact = settings.arguments as Contact;
          return MaterialPageRoute(
            builder: (context) => EditContactPage(contact: contact),
          );
        }
        return null;
      },
    );
  }
}

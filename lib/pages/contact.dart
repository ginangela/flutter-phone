import 'package:flutter/material.dart';
import 'package:flutter_phone/pages/add_contact.dart';
import 'package:flutter_phone/pages/edit_contact.dart';
import 'package:flutter_phone/pages/detail_contact.dart';
import 'package:flutter_phone/db/database_helper.dart';
import 'package:flutter_phone/models/contact_model.dart';

void main() {
  runApp(const ContactsApp());
}

class ContactsApp extends StatelessWidget {
  const ContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ContactsPage(),
    );
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];

  void _insertDummyContact() async {
    final dbHelper = DatabaseHelper();
    final existingContacts = await dbHelper.getAllContacts();

    if (existingContacts.isEmpty) {
      await dbHelper.insertContact(
        Contact(
          name: 'Tes Dummy',
          phone: '08123456789',
          email: 'dummy@mail.com',
          label: 'Personal',
        ),
      );
      _loadContacts();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _insertDummyContact();
  }

  void _loadContacts() async {
    final contacts = await DatabaseHelper().getAllContacts();
    setState(() {
      _allContacts = contacts;
      _filteredContacts = contacts;
    });
  }

  void _searchContacts(String query) {
    final filtered = _allContacts.where((contact) {
      final nameLower = contact.name.toLowerCase();
      final phoneLower = contact.phone.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) || phoneLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredContacts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB2EBF2), Color(0xFF7E57C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contacts',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _searchContacts,
              decoration: InputDecoration(
                hintText: 'Search contacts',
                prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _filteredContacts.isEmpty
                ? const Center(child: Text('Kontak tidak ditemukan'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDetailPage(
                          id: contact.id,
                          name: contact.name,
                          phone: contact.phone,
                          email: contact.email ?? 'email',
                          label: contact.label,
                        ),
                      ),
                    );

                    if (result == true) {
                      _loadContacts(); // Reload setelah edit
                    }
                  },
                  child: ContactCard(contact: contact),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactPage()),
          );

          if (result == true) {
            _loadContacts(); // Reload setelah tambah kontak
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final Contact contact;
  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/originals/12/4a/7f/124a7fbab2c9d8c61ff8c55537019aa6.jpg',
              ),
            ),
            const SizedBox(width: 20),
            Text(
              contact.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class EditContactPage extends StatelessWidget {
  final Map<String, String> contact;
  const EditContactPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: contact['name']);
    final phoneController = TextEditingController(text: contact['phone']);
    final emailController = TextEditingController(text: contact['email']);

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        title: const Text('Edit Contact'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/profile.jpg')),
            const SizedBox(height: 10),
            TextField(controller: nameController, decoration: const InputDecoration(prefixIcon: Icon(Icons.person), hintText: 'Name')),
            const SizedBox(height: 10),
            TextField(controller: phoneController, decoration: const InputDecoration(prefixIcon: Icon(Icons.phone), hintText: 'Phone')),
            const SizedBox(height: 10),
            TextField(controller: emailController, decoration: const InputDecoration(prefixIcon: Icon(Icons.email), hintText: 'Email')),
            const SizedBox(height: 10),
            const DropdownMenuExample(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Save')),
                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = 'Personal';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: dropdownValue,
      icon: const Icon(Icons.expand_more),
      decoration: const InputDecoration(prefixIcon: Icon(Icons.label), labelText: 'Labels'),
      items: <String>['Personal', 'Work'].map((String value) {
        return DropdownMenuItem(value: value, child: Text(value));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
    );
  }
}

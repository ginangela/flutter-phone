import 'package:flutter/material.dart';

class EditContactPage extends StatefulWidget {
  final Map<String, String>? contact;
  const EditContactPage({super.key, this.contact});

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  String? selectedLabel;

  static List<Map<String, String>> contactList = [
    {
      'name': 'Virginia Angel',
      'phone': '0813-8487-6277',
      'email': 'virginia@gmail.com',
      'label': 'Personal'
    },
    {
      'name': 'John Doe',
      'phone': '0813-1234-5678',
      'email': 'john.doe@gmail.com',
      'label': 'Work'
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!['name'] ?? '';
      phoneController.text = widget.contact!['phone'] ?? '';
      emailController.text = widget.contact!['email'] ?? '';
      selectedLabel = widget.contact!['label'];
    }
  }

  void _saveContact() {
    final newContact = {
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'label': selectedLabel ?? '',
    };

    if (widget.contact == null) {
      contactList.add(newContact);
    } else {
      final index = contactList.indexWhere(
          (contact) => contact['phone'] == widget.contact!['phone']);
      if (index != -1) {
        contactList[index] = newContact;
      }
    }

    // Kirim kembali kontak yang diperbarui
    Navigator.pop(context, newContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6EC6F4), Color(0xFF8E9EFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    'Edit Contact',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/originals/12/4a/7f/124a7fbab2c9d8c61ff8c55537019aa6.jpg',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: nameController,
              icon: Icons.person,
              hintText: "Virginia Angel",
            ),
            _buildInputField(
              controller: phoneController,
              icon: Icons.phone,
              hintText: "0813-8487-6277",
            ),
            _buildInputField(
              controller: emailController,
              icon: Icons.email,
              hintText: "virginia@gmail.com",
            ),
            _buildLabelDropdown(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("Save", Colors.blue, _saveContact),
                _buildButton("Cancel", Colors.grey, () {
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: DropdownButtonFormField<String>(
        value: selectedLabel,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.label),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'Personal', child: Text("Personal")),
          DropdownMenuItem(value: 'Work', child: Text("Work")),
        ],
        onChanged: (value) {
          setState(() {
            selectedLabel = value;
          });
        },
        hint: const Text("Labels"),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
      ),
      child: Text(text),
    );
  }
}

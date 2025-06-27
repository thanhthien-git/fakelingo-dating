import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String phoneNumber = '+84 912 345 678';
  String email = 'example@email.com';

  Future<void> _editTextField(
    String title,
    String currentValue,
    Function(String) onSave,
  ) async {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            keyboardType:
                title.contains('Phone')
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter $title',
              hintStyle: const TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.pink)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          tileColor: const Color(0xFF121212),
          leading: const Icon(Icons.arrow_right, color: Colors.white),
          title: Text(value, style: const TextStyle(color: Colors.white)),
          trailing: const Text("Edit", style: TextStyle(color: Colors.white70)),
          onTap: onTap,
        ),
        const Divider(color: Colors.white12, height: 0),
      ],
    );
  }

  Widget _buildSimpleTile(String title, {VoidCallback? onTap}) {
    return ListTile(
      tileColor: const Color(0xFF121212),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white70,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildRow("Phone Number", phoneNumber, () {
            _editTextField("Phone Number", phoneNumber, (newValue) {
              setState(() {
                phoneNumber = newValue;
              });
            });
          }),
          _buildRow("Email", email, () {
            _editTextField("Email", email, (newValue) {
              setState(() {
                email = newValue;
              });
            });
          }),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("PRIVACY", style: TextStyle(color: Colors.white54)),
          ),
          _buildSimpleTile("Cookie Policy"),
          _buildSimpleTile("Privacy Policy"),
          _buildSimpleTile("Privacy Preferences"),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("LEGAL", style: TextStyle(color: Colors.white54)),
          ),
          _buildSimpleTile("Licenses"),
          _buildSimpleTile("Terms of Service"),
          const SizedBox(height: 20),
          _buildSimpleTile("Logout", onTap: () => debugPrint('Logout pressed')),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const Text(
                  "Version 69.69.69.69",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => debugPrint('Delete Account pressed'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

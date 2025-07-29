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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: const Color(0xFFFF6B9D).withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType:
                title.contains('Phone')
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
            style: const TextStyle(color: Color(0xFF2C2C2C)),
            decoration: InputDecoration(
              hintText: 'Enter $title',
              hintStyle: TextStyle(
                color: const Color(0xFF2C2C2C).withOpacity(0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: const Color(0xFFFF6B9D).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFFFF6B9D),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFFFF5F8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2C2C2C).withOpacity(0.6),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFFB3D1)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  onSave(controller.text.trim());
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B9D).withOpacity(0.1),
                const Color(0xFFFFB3D1).withOpacity(0.1),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2C2C2C),
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B9D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFFF6B9D).withOpacity(0.3),
                ),
              ),
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Color(0xFFFF6B9D),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            onTap: onTap,
          ),
        ),
        Divider(color: const Color(0xFFFF6B9D).withOpacity(0.1), height: 1),
      ],
    );
  }

  Widget _buildSimpleTile(String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFF6B9D).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2C2C2C),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B9D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            color: const Color(0xFFFF6B9D),
            size: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF2C2C2C).withOpacity(0.6),
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [Color(0xFFFFE0E6), Color(0xFFFFF5F8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFFF6B9D).withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF2C2C2C),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Color(0xFF2C2C2C),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  children: [
                    _buildRow("Phone Number", phoneNumber, () {
                      _editTextField("Phone Number", phoneNumber, (newValue) {
                        setState(() {
                          phoneNumber = newValue;
                        });
                      });
                    }),
                    const SizedBox(height: 8),
                    _buildRow("Email", email, () {
                      _editTextField("Email", email, (newValue) {
                        setState(() {
                          email = newValue;
                        });
                      });
                    }),

                    const SizedBox(height: 30),
                    _buildSectionHeader("PRIVACY"),
                    _buildSimpleTile("Cookie Policy"),
                    _buildSimpleTile("Privacy Policy"),
                    _buildSimpleTile("Privacy Preferences"),

                    const SizedBox(height: 30),
                    _buildSectionHeader("LEGAL"),
                    _buildSimpleTile("Licenses"),
                    _buildSimpleTile("Terms of Service"),

                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFFF4444).withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF4444).withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Color(0xFFFF4444),
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Color(0xFFFF4444),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () => debugPrint('Logout pressed'),
                      ),
                    ),

                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Version 69.69.69.69",
                            style: TextStyle(
                              color: const Color(0xFF2C2C2C).withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFFF4444).withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed:
                                  () => debugPrint('Delete Account pressed'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                backgroundColor: Colors.white,
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
                                  color: Color(0xFFFF4444),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

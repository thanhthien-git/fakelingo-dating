import 'package:flutter/material.dart';
import 'package:fakelingo/core/models/user_model.dart';
import 'package:fakelingo/core/services/user_service.dart';
import 'package:fakelingo/ui/components/animate_toast.dart'; // Import toast của bạn

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final UserService _userService = UserService();

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController bioController;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    nameController =
        TextEditingController(text: widget.user.profile?.name ?? '');
    ageController = TextEditingController(
        text: widget.user.profile?.age?.toString() ?? '');
    bioController =
        TextEditingController(text: widget.user.profile?.bio ?? '');
    selectedGender = widget.user.profile?.gender;
  }

  Future<void> _saveProfile() async {
   try {
     final response = await _userService.updateProfile(
       name: nameController.text,
       age: int.tryParse(ageController.text),
       bio: bioController.text,
       gender: selectedGender,
       interests: widget.user.profile?.interests
           ?.map((e) => e.toString())
           .toList(),
     );
     AnimatedToast.show(context, "Success");
     Navigator.pop(context, {
       'name': nameController.text,
       'age': int.tryParse(ageController.text),
       'bio': bioController.text,
       'gender': selectedGender,
     });   }
   catch (e) {
     AnimatedToast.show(context, "Failed");
   }
  }


  Widget _buildRow(String title, TextEditingController controller) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter $title"),
          ),
        ),
        const Divider()
      ],
    );
  }

  Widget _buildEditTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildRow("Name", nameController),
        _buildRow("Age", ageController),
        _buildRow("Bio", bioController),
        ListTile(
          title: const Text("Gender"),
          trailing: DropdownButton<String>(
            value: selectedGender,
            items: [
              DropdownMenuItem(value: "M", child: Text("Male")),
              DropdownMenuItem(value: "F", child: Text("Female")),
            ],
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Name: ${nameController.text}"),
          Text("Age: ${ageController.text}"),
          Text("Gender: ${selectedGender ?? ''}"),
          Text("Bio: ${bioController.text}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C2C2C)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF6B9D),
          labelColor: const Color(0xFFFF6B9D),
          unselectedLabelColor: const Color(0xFF2C2C2C),
          tabs: const [Tab(text: 'Edit'), Tab(text: 'Preview')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildEditTab(), _buildPreviewTab()],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B9D),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for Database

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  String? selectedDept;
  final List<String> departments = ['CSE', 'ECE', 'EEE', 'ME', 'CE', 'CSD', 'CSM'];

  // This function saves the student's login to the Cloud
  Future<void> saveUserData(String username, String department) async {
    try {
      await FirebaseFirestore.instance.collection('active_users').add({
        'username': username,
        'department': department,
        'login_time': DateTime.now(),
        'status': 'Online',
      });
      print("User Data Saved to Firestore");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.fastfood, size: 80, color: Color(0xFF0D47A1)),
                Text("GPRECBites", style: TextStyle(fontSize: 28, color: Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                TextFormField(
                  controller: _userController,
                  decoration: InputDecoration(labelText: "Username / Roll No", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (value) => value!.isEmpty ? "Enter username" : null,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Department", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  value: selectedDept,
                  items: departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept))).toList(),
                  onChanged: (value) => setState(() => selectedDept = value),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // SAVE TO FIREBASE
                        await saveUserData(_userController.text, selectedDept!);
                        // Navigate to Menu
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0D47A1)),
                    child: Text("LOGIN", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

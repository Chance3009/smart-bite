import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  String? selectedActivity;
  String? selectedGender;
  String? selectedGoal;
  DateTime? selectedBirthdate;

  final List<Map<String, String>> activityLevels = [
    {'value': 'sedentary', 'label': 'Sedentary'},
    {'value': 'low_active', 'label': 'Low Activity'},
    {'value': 'active', 'label': 'Active'},
    {'value': 'very_active', 'label': 'Very Active'},
  ];

  final List<Map<String, String>> genders = [
    {'value': 'male', 'label': 'Male'},
    {'value': 'female', 'label': 'Female'},
  ];

  final List<Map<String, String>> goals = [
    {'value': 'lose_weight', 'label': 'Lose Weight'},
    {'value': 'maintain_weight', 'label': 'Maintain Weight'},
    {'value': 'gain_weight', 'label': 'Gain Weight'},
  ];

  Future<void> saveUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'height': heightController.text,
      'weight': weightController.text,
      'gender': selectedGender,
      'birthdate': selectedBirthdate?.toIso8601String(),
      'activity': selectedActivity,
      'goal': selectedGoal,
    });
  }

  Future<void> selectBirthdate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedBirthdate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedBirthdate) {
      setState(() {
        selectedBirthdate = pickedDate;
        birthdateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light green background
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Onboarding'),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome! Let's set up your profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(heightController, "Height", "Enter your height (cm)"),
              _buildTextField(weightController, "Weight", "Enter your weight (kg)"),
              _buildDateField(context, "Birthdate"),
              _buildDropdown("Gender", genders, selectedGender, (value) {
                setState(() {
                  selectedGender = value;
                });
              }),
              _buildDropdown("Activity Level", activityLevels, selectedActivity, (value) {
                setState(() {
                  selectedActivity = value;
                });
              }),
              _buildDropdown("Goal", goals, selectedGoal, (value) {
                setState(() {
                  selectedGoal = value;
                });
              }),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    saveUserData();
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
                    "Save & Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: birthdateController,
        readOnly: true,
        onTap: () => selectBirthdate(context),
        decoration: InputDecoration(
          labelText: label,
          hintText: "Select your birthdate",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<Map<String, String>> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item['value'],
                  child: Text(item['label']!),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

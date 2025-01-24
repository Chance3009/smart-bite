import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: Column(
        children: [
          // Top green title bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  "SMART BITE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // User avatar and basic information
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/profile_image.jpeg'), // is replaced with the actual image path
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Ahyeon ♀",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "18 years old",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          //Body parameter box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // height
                  Column(
                    children: [
                      Icon(Icons.height, color: Colors.green, size: 30),
                      SizedBox(height: 5),
                      Text(
                        "Height",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("165 cm"),
                    ],
                  ),
                  // BMI
                  Column(
                    children: [
                      Icon(Icons.accessibility, color: Colors.green, size: 30),
                      SizedBox(height: 5),
                      Text(
                        "BMI",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("21.5"),
                    ],
                  ),
                  // weight
                  Column(
                    children: [
                      Icon(Icons.monitor_weight, color: Colors.green, size: 30),
                      SizedBox(height: 5),
                      Text(
                        "Weight",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("55 kg"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // message button
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                // health conditions
                _buildInfoButton(
                  context,
                  "Health Conditions",
                  "No current health conditions.",
                ),
                //  prefers organic food
                _buildInfoButton(
                  context,
                  "Dietary Preferences",
                  "Vegetarian, prefers organic food.",
                ),
                // health goal
                _buildInfoButton(
                  context,
                  "Goals",
                  "Maintain weight and build muscle.",
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom navigation buttons
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/chat');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            //Current page, no action required
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: "Chatbot",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoButton(
      BuildContext context, String title, String description) {
    return GestureDetector(
      onTap: () {
        // Display detailed information popup
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.green),
          ],
        ),
      ),
    );
  }
}

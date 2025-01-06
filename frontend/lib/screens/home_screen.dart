import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  int _currentIndex = 1; // Home is selected by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: Column(
        children: [
          // Top green part
          Container(
            color: Colors.green,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top title and icon
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SMART BITE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.notifications, color: Colors.white),
                        SizedBox(width: 10),
                        Icon(Icons.settings, color: Colors.white),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Date picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    DateTime date = selectedDate.add(Duration(days: index - 3));
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            "${date.day}",
                            style: TextStyle(
                              color: selectedDate.day == date.day
                                  ? Colors.yellow
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                                [date.weekday % 7],
                            style: TextStyle(
                              color: selectedDate.day == date.day
                                  ? Colors.yellow
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Calorie Information and Nutrition Facts
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Calorie display section
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "870",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Calories",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        _buildNutritionRow("Carbohydrate", 200, 500, Colors.yellow),
                        _buildNutritionRow("Fibre", 32, 500, Colors.green),
                        _buildNutritionRow("Protein", 200, 500, Colors.blue),
                        _buildNutritionRow("Fat", 200, 500, Colors.orange),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Function card
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureCard("My Meal Plan", Colors.yellow, () {
                  Navigator.pushNamed(context, '/meal_plan');
                }),
                _buildFeatureCard("My Daily Meal", Colors.green, () {
                  Navigator.pushNamed(context, '/daily_meal');
                }),
                _buildFeatureCard("Diet Tips Collection", Colors.orange, () {
                  Navigator.pushNamed(context, '/diet_tips');
                }),
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
        currentIndex: _currentIndex, 
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
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected state
          });
          if (index == 0) {
            Navigator.pushNamed(context, '/chat');
          } else if (index == 1) {
            //Current page, no action required
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildNutritionRow(String label, double value, double max, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Row(
            children: [
              Container(
                width: 150,
                height: 10,
                color: color,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value / max,
                  child: Container(color: color),
                ),
              ),
              SizedBox(width: 10),
              Text("${value.toInt()}/${max.toInt()} g"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

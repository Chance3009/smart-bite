import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  int _currentIndex = 1; // Home is selected by default
  List<Map<String, dynamic>> recentIntakeList = [];
  Map<String, dynamic> todayNutrients = {
    'calorie': 0.0,
    'carbs': 0.0,
    'protein': 0.0,
    'fat': 0.0,
  };

  @override
  void initState() {
    super.initState();
    fetchRecentIntake();
    fetchTodayNutrient();
  }

  Future<void> fetchRecentIntake() async {
    setState(() {
      recentIntakeList = [
        {
          'file_uri': 'assets/nasi_lemak.jpeg',
          'calorie': 200.0,
          'carbs': 50.0,
          'protein': 20.0,
          'fat': 10.0,
          'date': DateTime.now(),
        },
        {
          'file_uri': 'assets/ckt.jpeg',
          'calorie': 150.0,
          'carbs': 40.0,
          'protein': 15.0,
          'fat': 8.0,
          'date': DateTime.now().subtract(Duration(hours: 2)),
        },
      ];
    });
  }

  Future<void> fetchTodayNutrient() async {
    setState(() {
      todayNutrients = {
        'calorie': 1200.0,
        'carbs': 300.0,
        'protein': 100.0,
        'fat': 50.0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: Column(
        children: [
          _buildTopGreenPart(),
          const SizedBox(height: 20),
          _buildCalorieSection(),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Eaten Food",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: recentIntakeList.length,
                    itemBuilder: (context, index) {
                      return _buildRecentItem(recentIntakeList[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        items: const [
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
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.pushNamed(context, '/chat');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildTopGreenPart() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SMART BITE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
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
          const SizedBox(height: 10),
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
                      [
                        "Sun",
                        "Mon",
                        "Tue",
                        "Wed",
                        "Thu",
                        "Fri",
                        "Sat"
                      ][date.weekday % 7],
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
    );
  }

  Widget _buildCalorieSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Today's Intake",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            _buildNutritionCard("Calorie", "${todayNutrients['calorie']} kcal"),
            _buildNutritionCard("Carbohydrate", "${todayNutrients['carbs']} g"),
            _buildNutritionCard("Protein", "${todayNutrients['protein']} g"),
            _buildNutritionCard("Fat", "${todayNutrients['fat']} g"),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionCard(String name, String value) {
    return Container(
      width: 160,
      height: 103,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item['file_uri'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 80, color: Colors.red),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIconText(
                        Icons.local_fire_department, '${item['calorie']} kcal'),
                    const SizedBox(width: 10),
                    _buildIconText(Icons.cake, '${item['carbs']}g carbs'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildIconText(Icons.emoji_food_beverage,
                        '${item['protein']}g protein'),
                    const SizedBox(width: 10),
                    _buildIconText(Icons.fastfood, '${item['fat']}g fat'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${item['date'].toLocal()}'.split(' ')[0],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 16),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

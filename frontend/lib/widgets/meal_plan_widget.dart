import 'package:flutter/material.dart';

class MealPlanWidget extends StatelessWidget {
  final Map<String, dynamic> mealPlanData;

  MealPlanWidget({required this.mealPlanData});

  @override
  Widget build(BuildContext context) {
    if (mealPlanData.isEmpty) {
      return Text("No meal plan available.");
    }

    final mealPlan = mealPlanData['meal_plan'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Breakfast: ${mealPlan['breakfast']['name']}'),
        Text('Calories: ${mealPlan['breakfast']['calories']} kcal'),
        Text('Proteins: ${mealPlan['breakfast']['macronutrients']['proteins']}g'),
        Text('Carbs: ${mealPlan['breakfast']['macronutrients']['carbs']}g'),
        Text('Fats: ${mealPlan['breakfast']['macronutrients']['fats']}g'),
        
        // Add lunch, dinner, and snacks similarly
        
        Text('Lunch: ${mealPlan['lunch']['name']}'),
        Text('Dinner: ${mealPlan['dinner']['name']}'),
        // Snacks (if any)
        if (mealPlan['snacks'] != null) ...[
          Text('Snacks:'),
          for (var snack in mealPlan['snacks']) ...[
            Text('${snack['name']} - ${snack['calories']} kcal'),
          ]
        ],
      ],
    );
  }
}

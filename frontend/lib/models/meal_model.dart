class Meal {
  final String mealName;
  final double calories;

  Meal(this.mealName, this.calories);

  Map<String, dynamic> toMap() {
    return {
      'meal_name': mealName,
      'calories': calories,
    };
  }
}

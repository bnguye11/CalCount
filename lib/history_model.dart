class History {
  final int?
      id; //this could be optional or not even needed but keeping it in for now
  final String date;
  final double calories;
  final double protein;
  final double fat;
  final double carb;

  History({
    this.id,
    required this.date,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carb,
  });

  factory History.fromMap(Map<String, dynamic> json) => History(
        id: json['id'],
        date: json['date'],
        calories: json['calories'],
        protein: json['protein'],
        fat: json['fat'],
        carb: json['carb'],
      );

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carb': carb,
    };
  }

  @override
  String toString() {
    return 'History{id: $id, name: $date, calories: $calories, protein: $protein, fat: $fat, carb: $carb}';
  }
}

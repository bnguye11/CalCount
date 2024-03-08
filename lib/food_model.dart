class Food {
  final int?
      id; //this could be optional or not even needed but keeping it in for now
  final String name;
  final int calories;
  final int protein;
  final int fat;
  final int carb;

  Food({
    this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carb,
  });

  factory Food.fromMap(Map<String, dynamic> json) => Food(
        id: json['id'],
        name: json['name'],
        calories: json['calories'],
        protein: json['protein'],
        fat: json['fat'],
        carb: json['carb'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carb': carb,
    };
  }

  @override
  String toString() {
    return 'Food{id: $id, name: $name, calories: $calories, protein: $protein, fat: $fat, carb: $carb}';
  }
}

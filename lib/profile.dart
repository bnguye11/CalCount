class Profile {
  final int id; //this could be optional or not even needed but keeping it in for now
  final String name;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final double calories;
  final double protein;
  final double fat;
  final double carb;

  Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carb,
  });

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        gender: json['gender'],
        weight: json['weight'],
        height: json['height'],
        calories: json['calories'],
        protein: json['protein'],
        fat: json['fat'],
        carb: json['carb'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carb': carb,
    };
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, age: $age, gender: $gender, weight: $weight, height: $height, $calories, protein: $protein, fat: $fat, carb: $carb}';
  }
}

class Food {
  final int id; //this could be optional or not even needed but keeping it in for now
  final String name;
  final int calories;
  final int protein;
  final int fat;
  final int carb;

  const Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carb,
  });
}
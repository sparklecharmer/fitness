class FitnessUser {
  int weight;
  int height;
  String gender;
  int age;
  String exercise;
  int? neck;
  int? hip;
  int? waist;
  String? goal;
  int? deficit;
  int? goalWeight;

  FitnessUser({
    required this.weight,
    required this.height,
    required this.gender,
    required this.age,
    required this.exercise,
    this.neck,
    this.hip,
    this.waist,
    this.goal,
    this.deficit,
    this.goalWeight,
  });

// TODO incorporate
}
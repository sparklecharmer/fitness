class Bmi {
  final double bmi;
  final String bmiConclusion;
  final double idealBodyWt;
  final double bodyFatPercent;
  final double totalDailyEE;

  Bmi({
    required this.bmi,
    required this.bmiConclusion,
    required this.idealBodyWt,
    required this.bodyFatPercent,
    required this.totalDailyEE,
  });

  factory Bmi.fromJson(Map<String, dynamic> json) {
    return Bmi(
      bmi: json['bodyMassIndex']['value'],
      bmiConclusion: json['bodyMassIndex']['conclusion'],
      idealBodyWt: json['idealBodyWeight']['peterson']['metric']['value'].toDouble(),
      bodyFatPercent: json['bodyFatPercentage']['bmi']['value'].toDouble(),
      totalDailyEE: json['restingDailyEnergyExpenditure']['bmi']['calories']['value'].toDouble()
    );
  }
}


//can run all the other shit but not totalDailyEE
// Total Daily Energy Expenditure (TDEE)
// From BMI
// The TDEE from BMI needs two parameters
//
// exercise
// restingDailyEnergyExpenditure.bmi.calories.value computed with the RDEE
// as the result you get an object in totalDailyEnergyExpenditure containing
//
// the formula name in bmi.formulaName
// the calories in bmi.calories.value and the unit in bmi.calories.unit
// the joules in bmi.joules.value and the unit in bmi.joules.unit
// {
// "bmi": {
// "formulaName": "From RDEE and BMI.",
// "calories": {
// "value": 2269,
// "unit": [
// "Kcal",
// "kilocalories"
// ]
// },
// "joules": {
// "value": 9493.5,
// "unit": [
// "Kj",
// "kilojoules"
// ]
// }
// }
// }
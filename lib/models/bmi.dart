class Bmi {
  final double bmi;
  final String bmiConclusion;
  final double idealBodyWt;
  final double bodyFatPercent;
  final double totalDailyEE;
  final double restingDailyEE;
  final double leanBodyMass;

  Bmi({
    required this.bmi,
    required this.bmiConclusion,
    required this.idealBodyWt,
    required this.bodyFatPercent,
    required this.totalDailyEE,
    required this.restingDailyEE,
    required this.leanBodyMass,
  });

  factory Bmi.fromJson(Map<String, dynamic> json) {
    return Bmi(
      bmi: json['bodyMassIndex']['value'].toDouble(),
      bmiConclusion: json['bodyMassIndex']['conclusion'],
      idealBodyWt: json['idealBodyWeight']['peterson']['metric']['value'].toDouble(),
      bodyFatPercent: json['bodyFatPercentage']['bmi']['value'].toDouble(),
      totalDailyEE: json['totalDailyEnergyExpenditure']['bmi']['calories']['value'].toDouble(),
      restingDailyEE: json['restingDailyEnergyExpenditure']['bmi']['calories']['value'].toDouble(),
      leanBodyMass: json['leanBodyMass']['bmi']['value'].toDouble(),
    );
  }
}

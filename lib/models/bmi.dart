class Bmi {
  final double bmi;
  final String bmiConclusion;
  final double idealBodyWt;
  final double bodyFatPercent;
  // final int totalDailyEE; //need exercise and RDEE (RDEE needs LBM) (LBM needs bodyfatpercentage)

  Bmi({
    required this.bmi,
    required this.bmiConclusion,
    required this.idealBodyWt,
    required this.bodyFatPercent,
    // required this.totalDailyEE,
  });

  factory Bmi.fromJson(Map<String, dynamic> json) {
    return Bmi(
      bmi: json['bodyMassIndex']['value'],
      bmiConclusion: json['bodyMassIndex']['conclusion'],
      idealBodyWt: json['idealBodyWeight']['peterson']['metric']['value'].toDouble(),
      bodyFatPercent: json['bodyFatPercentage']['bmi']['value'].toDouble(),
      // totalDailyEE: json['bmi']['value']
    );
  }

}

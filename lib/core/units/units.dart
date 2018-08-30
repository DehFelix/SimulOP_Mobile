abstract class Units {
  static double get gStatic => 9.80665;

  double get g => 9.80665;

  double findRoot(Function(double) fx, double infLimit, double uperLimit,
      [double epsilon = 1e-4, int nInte = 100]) {
    throw Exception();
  }
}

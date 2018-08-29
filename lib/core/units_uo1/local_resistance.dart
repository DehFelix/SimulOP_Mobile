import 'package:simulop_v1/core/interfaces/i_local_resistances.dart';
import 'package:simulop_v1/core/units_uo1/units_1.dart';

class LocalResistance extends UnitsI implements ILocalResistance {
  /// Type of local resistance
  String _type;

  /// Equivalent lengh of tube of the resistance (m).
  double _equivalentLengh;

  /// Type of local resistance
  @override
  String get type => _type;

  /// /// Equivalent lengh of tube of the resistance (m).
  @override
  double get equivalentLengh => _equivalentLengh;

  /// Creates a [LocalResistance] to be usede in the [UnitsI] scope.
  ///
  /// [type] = type of local resistance.
  ///
  /// [equivalentLengh] = equivalent lengh of tube of the resistance (m).
  LocalResistance(String type, double equivalentLengh) {
    _type = type;
    _equivalentLengh = equivalentLengh;
  }
}

class SimpleValve extends LocalResistance {
  /// Equivalent lengh of tube that multiplys the opening (m).
  double _openingFactor;

  /// Equivalent lengh of tube of the valve totaly open (m).
  double _equivalentLenghOpen;

  /// Opening of the valve (0 = completely closed 1 = completely open).
  double _opening;

  /// Equivalent lengh of tube that multiplys the opening (m).
  double get openingFactor => _openingFactor;

  /// Equivalent lengh of tube of the valve totaly open (m).
  double get equivalentLenghOpen => _equivalentLenghOpen;

  /// Opening of the valve (0 = completely closed 1 = completely open).
  double get opening => _opening;

  /// Opening of the valve (0 = completely closed 1 = completely open).
  set opening(double o) {
    if (o >= 0.0 && o <= 1.0) {
      _opening = o;
      _updateEquivalentLengh();
    } else {
      throw Exception("Opening value must be betwen 0.0 and 1.0");
    }
  }

  /// Creates a [SimpleValve] [LocalResistance] to be usede in the [UnitsI] scope.
  ///
  /// [equivalentLenghOpen] = equivalent lengh of tube of the valve totaly open (m).
  ///
  /// [openingFactor] = equivalent lengh of tube that multiplys the opening (m).
  SimpleValve(double equivalentLenghOpen, double openingFactor)
      : super("Simple Valve", equivalentLenghOpen) {
    _openingFactor = openingFactor;
    _opening = 1.0;
  }

  /// Updates the equivalent lengh of the valve based od the [_opening].
  void _updateEquivalentLengh() {
    _equivalentLengh = _equivalentLenghOpen + _openingFactor * (1.0 - _opening);
  }
}

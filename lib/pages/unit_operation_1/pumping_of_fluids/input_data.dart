import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simulop_v1/pages/unit_operation_1/pumping_of_fluids/simulation_data.dart';

/// Model for handalling the inputs of the app
class PumpingOfFluidsInputModel extends Model {
  final FluidInput fluidInputs;
  final InletTubeInput inletTubeInput;
  final OutletTubeInput outletTubeInput;
  final DistancesInput distancesInput;
  final SimulationCreator simulationCreator = new SimulationCreator();

  FluidInput get fluidInput => fluidInputs;

  PumpingOfFluidsInputModel({
    this.fluidInputs,
    this.inletTubeInput,
    this.outletTubeInput,
    this.distancesInput,
  });

  static PumpingOfFluidsInputModel of(BuildContext context) =>
      ScopedModel.of<PumpingOfFluidsInputModel>(context);

  void setFluidName(String name) {
    fluidInputs.name = name;
    notifyListeners();
  }

  void setFluidTemperature(String temp) {
    if (temp != null) {
      fluidInputs.temperature = temp;
    }
  }

  void setFluidInletPressure(String pressure) {
    if (pressure != null) {
      fluidInputs.inletPressure = pressure;
    }
  }

  void setInletTubeMaterial(String name) {
    inletTubeInput.material = name;
    notifyListeners();
  }

  void setInletTubeDiametre(String diametre) {
    inletTubeInput.diametre = diametre;
  }

  void setInletTubeEquivalentDistances(String distances) {
    inletTubeInput.equivalentDistance = distances;
  }

  void setOutletTubeMaterial(String name) {
    outletTubeInput.material = name;
    notifyListeners();
  }

  void setOutletTubeDiametre(String diametre) {
    outletTubeInput.diametre = diametre;
  }

  void setOutletTubeEquivalentDistances(String distances) {
    outletTubeInput.equivalentDistance = distances;
  }

  void setDistancesDzInlet(String dz) {
    distancesInput.dzInlet = dz;
  }

  void setDistancesLInlet(String l) {
    distancesInput.lInlet = l;
  }

  void setDistancesDzOutlet(String dz) {
    distancesInput.dzOutlet = dz;
  }

  void setDistancesLOutlet(String l) {
    distancesInput.lOutlet = l;
  }

  bool validadeFluid() {
    return fluidInputs.validInput();
  }

  bool validateInletTube() {
    return (inletTubeInput.validInput() && distancesInput.validInput());
  }

  bool validateOutletTube() {
    return (outletTubeInput.validInput() && distancesInput.validInput());
  }

  bool canCreateSimulation() {
    if (validadeFluid() && validateInletTube() && validateOutletTube()) {
      return true;
    } else {
      return false;
    }
  }

  PumpingOfFluidsSimulation createSimulation() {
    if (canCreateSimulation()) {
      return simulationCreator.createSimulation(fluidInput, inletTubeInput, outletTubeInput, distancesInput);
    } else {
      return null;
    }
  }

  void debugPrint() {
    print(fluidInputs.toString());
    print(inletTubeInput.toString());
    print(outletTubeInput.toString());
    print(distancesInput.toString());
  }
}

class FluidInput {
  String name;
  String temperature;
  String inletPressure;

  final List<String> _fluidsOptions = ["Water", "Benzene", "Toluene"];

  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<dynamic>> fluidInputDropDownItems() {
    return _fluidsOptions.map((String fluidName) {
      return DropdownMenuItem(
        value: fluidName,
        child: Text(
          fluidName,
        ),
      );
    }).toList();
  }

  /// Input validator for the temparature
  String temperatureValidator(String value) {
    if (value.isEmpty) return null;

    double min = 10.0;
    double max = 90.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Temperature <= $max °C";
    } else
      return null;
  }

  /// Input validator dor the pressure
  String pressureValidator(String value) {
    if (value.isEmpty) return null;

    double min = 0.1;
    double max = 5.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Pressure <= $max bar";
    } else {
      return null;
    }
  }

  bool validInput() {
    if (name == null || temperature == null || inletPressure == null)
      return false;
    if (name.isNotEmpty && temperature.isNotEmpty && inletPressure.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return "Fluid : \n" +
        "Name = $name \n" +
        "temperature = $temperature \n" +
        "inletPressure = $inletPressure \n";
  }
}

class InletTubeInput {
  String material;
  String diametre;
  String equivalentDistance;

  final List<String> _materialOptions = ["Steel", "Copper", "Concrete", "PVC"];

  // Create the dropDown for the possibles materials
  List<DropdownMenuItem<dynamic>> inletMaterialInputDropDownItems() {
    return _materialOptions.map((String fluidName) {
      return DropdownMenuItem(
        value: fluidName,
        child: Text(
          fluidName,
        ),
      );
    }).toList();
  }

  /// Input validator for the diametre
  String diametreValidator(String value) {
    if (value.isEmpty) return null;

    double min = 2.0;
    double max = 40.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Diametre <= $max cm";
    } else
      return null;
  }

  /// Input validator for the equivalent distance
  String equivalentDistancesValidator(String value) {
    if (value.isEmpty) return null;

    double min = 0.0;
    double max = 100.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Distances <= $max m";
    } else
      return null;
  }

  bool validInput() {
    if (material == null || diametre == null || equivalentDistance == null)
      return false;
    if (material.isNotEmpty &&
        diametre.isNotEmpty &&
        equivalentDistance.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return "InletTube : \n" +
        "material = $material \n" +
        "diametre = $diametre \n" +
        "equivalenteDistances = $equivalentDistance \n";
  }
}

class OutletTubeInput {
  String material;
  String diametre;
  String equivalentDistance;

  final List<String> _materialOptions = ["Steel", "Copper", "Concrete", "PVC"];

  // Create the dropDown for the possibles materials
  List<DropdownMenuItem<dynamic>> outletMaterialInputDropDownItems() {
    return _materialOptions.map((String fluidName) {
      return DropdownMenuItem(
        value: fluidName,
        child: Text(
          fluidName,
        ),
      );
    }).toList();
  }

  /// Input validator for the diametre
  String diametreValidator(String value) {
    if (value.isEmpty) return null;

    double min = 2.0;
    double max = 40.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Diametre <= $max cm";
    } else
      return null;
  }

  /// Input validator for the equivalent distance
  String equivalentDistancesValidator(String value) {
    if (value.isEmpty) return null;

    double min = 0.0;
    double max = 100.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Distances <= $max m";
    } else
      return null;
  }

  bool validInput() {
    if (material == null || diametre == null || equivalentDistance == null)
      return false;
    if (material.isNotEmpty &&
        diametre.isNotEmpty &&
        equivalentDistance.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return "OutletTube : \n" +
        "material = $material \n" +
        "diametre = $diametre \n" +
        "equivalenteDistances = $equivalentDistance \n";
  }
}

class DistancesInput {
  String dzInlet;
  String lInlet;
  String dzOutlet;
  String lOutlet;

  /// Input validator for the height diference (dz)
  String heightValidator(String value) {
    if (value.isEmpty) return null;

    double min = -20.0;
    double max = 20.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Height <= $max m";
    } else
      return null;
  }

  /// Input validator for the height diference (dz)
  String distanceValidator(String value) {
    if (value.isEmpty) return null;

    double min = 1.0;
    double max = 1000.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Distance <= $max m";
    } else
      return null;
  }

  bool validInput() {
    if (dzInlet == null ||
        lInlet == null ||
        dzOutlet == null ||
        lOutlet == null) return false;
    if (dzInlet.isNotEmpty &&
        lInlet.isNotEmpty &&
        dzOutlet.isNotEmpty &&
        lOutlet.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return "Distances : \n" +
        "dZInlet = $dzInlet \n" +
        "diametre = $lInlet \n" +
        "dzOutlet = $dzOutlet \n" +
        "lOutlet = $lOutlet \n";
  }
}

class SimulationCreator {
  final PumpingOfFluidsSimulation simulation = PumpingOfFluidsSimulation();

  PumpingOfFluidsSimulation createSimulation(FluidInput fluidInput, InletTubeInput inletTubeInput,
      OutletTubeInput outletTubeInput, DistancesInput distancesInput) {

        simulation.string = fluidInput.toString() + inletTubeInput.toString() + outletTubeInput.toString() + distancesInput.toString();

    return simulation;
  }
}

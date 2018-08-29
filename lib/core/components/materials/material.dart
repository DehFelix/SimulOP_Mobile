/// The base class for all materials
class MaterialType {
  String _name;

  /// The name of the material
  String get name => _name;

  MaterialType(String name) {
    this._name = name;
  }
}
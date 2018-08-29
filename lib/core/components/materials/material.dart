/// The base class for all materials
class Material {
  String _name;

  /// The name of the material
  String get name => _name;

  Material(String name) {
    this._name = name;
  }
}
// lib/data/models/configuration_model.dart
class ConfigurationModel {
  int? id;
  String key; // Misalnya 'kop_header_text', 'office_name', 'address'
  String? value;

  ConfigurationModel({
    this.id,
    required this.key,
    this.value,
  });

  factory ConfigurationModel.fromMap(Map<String, dynamic> map) {
    return ConfigurationModel(
      id: map['id'],
      key: map['key'],
      value: map['value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'value': value,
    };
  }

  @override
  String toString() {
    return 'ConfigurationModel(id: $id, key: $key, value: $value)';
  }
}


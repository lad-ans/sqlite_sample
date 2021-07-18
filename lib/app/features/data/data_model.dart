class DataModel {
  String name, surname, createdAt;
  int age;

  DataModel({
    this.name,
    this.surname,
    this.age,
    this.createdAt,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    if (json != null)
      return DataModel(
        name: json['name'],
        surname: json['surname'],
        age: json['age'],
        createdAt: json['createdAt'],
      );
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'age': age,
      'createdAt': createdAt,
    };
  }
}

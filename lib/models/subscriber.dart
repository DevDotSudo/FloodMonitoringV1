class Subscriber {
  final String id;
  final String name;
  final String age;
  final String gender;
  final String address;
  final String phone;
  final String registeredDate;
  final String viaSMS;

  Subscriber({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.address,
    required this.phone,
    required this.registeredDate,
    required this.viaSMS,
  });

  factory Subscriber.fromMap(Map<String, dynamic> map) {
    return Subscriber(
      id: map['id'] ?? '',
      name: map['fullName'] ?? '',
      age: map['age'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      phone: map['phoneNumber'] ?? '',
      registeredDate: map['registeredDate'] ?? '',
      viaSMS: map['viaSMS'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': name,
      'age': age,
      'gender': gender,
      'address': address,
      'phoneNumber': phone,
      'registeredDate': registeredDate,
      'viaSMS': viaSMS,
    };
  }

  @override
  String toString() {
    return 'Subscriber(id: $id, name: $name, age: $age, gender: $gender, address: $address, phone: $phone, registeredDate: $registeredDate $viaSMS)';
  }
}

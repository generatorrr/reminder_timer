class TimerEntity {
  int? id;
  String name;
  String description;
  int interval;

  TimerEntity({
    this.id,
    required this.name,
    required this.description,
    required this.interval,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'interval': interval
    };
  }

  @override
  String toString() {
    return 'TimerEntity(id: $id, name: $name, description: $description, interval: $interval)';
  }
}

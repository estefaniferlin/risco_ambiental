class Report {
  final String description;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String userName;

  Report({
    required this.description,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'userName': userName,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      description: map['description'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      userName: map['userName'] as String,
    );
  }
}

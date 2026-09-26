/// Store information model for Arcoffee.
class StoreInfo {
  final String name;
  final String slogan;
  final String venue;
  final String address;
  final String province;
  final String weekdayHours;
  final String weekendHours;
  final String phone;
  final String email;
  final String instagram;
  final String facebook;
  final List<String> courtAmenities;
  final bool isOpen24HoursWeekend;

  const StoreInfo({
    required this.name,
    required this.slogan,
    required this.venue,
    required this.address,
    required this.province,
    required this.weekdayHours,
    required this.weekendHours,
    required this.phone,
    required this.email,
    required this.instagram,
    required this.facebook,
    required this.courtAmenities,
    this.isOpen24HoursWeekend = true,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      name: json['name'] ?? 'Arcoffee',
      slogan: json['slogan'] ?? "It's always been ours.",
      venue: json['venue'] ?? 'The Pickleground PH',
      address: json['address'] ?? 'Kawit / Noveleta boundary',
      province: json['province'] ?? 'Cavite, Philippines',
      weekdayHours: json['weekday_hours'] ?? 'Mon – Thu: 2PM – 10PM',
      weekendHours: json['weekend_hours'] ?? 'Fri – Sun: 24 Hours',
      phone: json['phone'] ?? '+63 917 123 4567',
      email: json['email'] ?? 'hello@arcoffee.ph',
      instagram: json['instagram'] ?? '@arcoffee.ph',
      facebook: json['facebook'] ?? 'arcoffeeph',
      courtAmenities: (json['court_amenities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isOpen24HoursWeekend: json['is_open_24_hours_weekend'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slogan': slogan,
      'venue': venue,
      'address': address,
      'province': province,
      'weekday_hours': weekdayHours,
      'weekend_hours': weekendHours,
      'phone': phone,
      'email': email,
      'instagram': instagram,
      'facebook': facebook,
      'court_amenities': courtAmenities,
      'is_open_24_hours_weekend': isOpen24HoursWeekend,
    };
  }
}

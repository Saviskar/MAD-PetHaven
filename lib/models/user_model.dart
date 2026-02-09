class User {
  final int id;
  final String name;
  final String email;
  final String? mobile;
  final String? emailVerifiedAt;
  final int roleId;
  final String? twoFactorConfirmedAt;
  final int? currentTeamId;
  final String? profilePhotoPath;
  final String createdAt;
  final String updatedAt;
  final String? addressLine;
  final String? city;
  final String? province;
  final String? gender;
  final String profilePhotoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.emailVerifiedAt,
    required this.roleId,
    this.twoFactorConfirmedAt,
    this.currentTeamId,
    this.profilePhotoPath,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePhotoUrl,
    this.addressLine,
    this.city,
    this.province,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      emailVerifiedAt: json['email_verified_at'],
      roleId: json['role_id'],
      twoFactorConfirmedAt: json['two_factor_confirmed_at'],
      currentTeamId: json['current_team_id'],
      profilePhotoPath: json['profile_photo_path'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      profilePhotoUrl: json['profile_photo_url'],
      addressLine: json['addressline'],
      city: json['city'],
      province: json['province'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'email_verified_at': emailVerifiedAt,
      'role_id': roleId,
      'two_factor_confirmed_at': twoFactorConfirmedAt,
      'current_team_id': currentTeamId,
      'profile_photo_path': profilePhotoPath,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile_photo_url': profilePhotoUrl,
      'addressline': addressLine,
      'city': city,
      'province': province,
      'gender': gender,
    };
  }
}

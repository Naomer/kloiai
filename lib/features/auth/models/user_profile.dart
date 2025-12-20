class UserProfile {
  final String id;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final String? plan; // 'free', 'pro', etc.
  final int? credits;
  
  UserProfile({
    required this.id,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.plan,
    this.credits,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      plan: json['plan'] as String?,
      credits: json['credits'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'plan': plan,
      'credits': credits,
    };
  }
}

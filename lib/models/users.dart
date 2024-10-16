class UserState {
  UserState({
    required this.statusCode,
    required this.success,
    required this.messages,
    required this.data,
  });

  late final int statusCode;
  late final bool success;
  late final List<String> messages;
  late final List<Data> data;

  // Factory constructor for initial state
  factory UserState.initial() {
    return UserState(
      statusCode: 0, // Initial value, adjust as necessary
      success: false, // Default to false
      messages: [], // Start with an empty message list
      data: [], // Start with an empty user data list
    );
  }

  UserState.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = List.castFrom<dynamic, String>(json['messages']);
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['success'] = success;
    _data['messages'] = messages;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }

  // CopyWith method for UserState
  UserState copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return UserState(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? List.from(this.messages),
      data: data ?? List.from(this.data),
    );
  }
}

class Data {
  Data({
    required this.userId,
    this.username,
    this.countryname,
    this.state,
    this.city,
    this.address,
    this.profilePic,
    this.useRole,
    this.idFront,
    this.idBack,
    this.idCard,
    this.bankaccountno,
    this.bankname,
    this.ifsccode,
    this.latitude,
    this.longitude,
    this.radius,
    this.accessToken,
    this.accessTokenExpiresAt,
    this.refreshToken,
    this.refreshTokenExpiresAt,
    this.mobileno, // Added mobileno field
  });

  late final int userId;
  late final String? username;
  late final String? countryname;
  late final String? state;
  late final String? city;
  late final String? address;
  late final Null profilePic;
  late final String? useRole;
  late final String? idFront;
  late final String? idBack;
  late final Null idCard;
  late final Null bankaccountno;
  late final String? bankname;
  late final String? ifsccode;
  late final String? latitude;
  late final String? longitude;
  late final int? radius;
  late final Null accessToken;
  late final Null accessTokenExpiresAt;
  late final Null refreshToken;
  late final Null refreshTokenExpiresAt;
  late final String? mobileno; // Added mobileno field

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    countryname = json['countryname'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    profilePic = json['profile_pic'];
    useRole = json['use_role'];
    idFront = json['id_front'];
    idBack = json['id_back'];
    idCard = json['id_card'];
    bankaccountno = json['bankaccountno'];
    bankname = json['bankname'];
    ifsccode = json['ifsccode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    accessToken = json['access_token'];
    accessTokenExpiresAt = json['access_token_expires_at'];
    refreshToken = json['refresh_token'];
    refreshTokenExpiresAt = json['refresh_token_expires_at'];
    mobileno = json['mobileno']; // Added mobileno field
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['username'] = username;
    _data['countryname'] = countryname;
    _data['state'] = state;
    _data['city'] = city;
    _data['address'] = address;
    _data['profile_pic'] = profilePic;
    _data['use_role'] = useRole;
    _data['id_front'] = idFront;
    _data['id_back'] = idBack;
    _data['id_card'] = idCard;
    _data['bankaccountno'] = bankaccountno;
    _data['bankname'] = bankname;
    _data['ifsccode'] = ifsccode;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['radius'] = radius;
    _data['access_token'] = accessToken;
    _data['access_token_expires_at'] = accessTokenExpiresAt;
    _data['refresh_token'] = refreshToken;
    _data['refresh_token_expires_at'] = refreshTokenExpiresAt;
    _data['mobileno'] = mobileno; // Added mobileno field
    return _data;
  }

  // CopyWith method for Data
  Data copyWith({
    int? userId,
    String? username,
    String? countryname,
    String? state,
    String? city,
    String? address,
    Null? profilePic,
    String? useRole,
    String? idFront,
    String? idBack,
    Null? idCard,
    Null? bankaccountno,
    String? bankname,
    String? ifsccode,
    String? latitude,
    String? longitude,
    int? radius,
    Null? accessToken,
    Null? accessTokenExpiresAt,
    Null? refreshToken,
    Null? refreshTokenExpiresAt,
    String? mobileno, // Added mobileno field in copyWith method
  }) {
    return Data(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      countryname: countryname ?? this.countryname,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      profilePic: profilePic ?? this.profilePic,
      useRole: useRole ?? this.useRole,
      idFront: idFront ?? this.idFront,
      idBack: idBack ?? this.idBack,
      idCard: idCard ?? this.idCard,
      bankaccountno: bankaccountno ?? this.bankaccountno,
      bankname: bankname ?? this.bankname,
      ifsccode: ifsccode ?? this.ifsccode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      accessToken: accessToken ?? this.accessToken,
      accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenExpiresAt:
          refreshTokenExpiresAt ?? this.refreshTokenExpiresAt,
      mobileno: mobileno ?? this.mobileno, // Handle mobileno in copyWith
    );
  }
}

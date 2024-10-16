// class AuthState {
//   String? message;
//   User? user;
//   Tokens? tokens;

//   AuthState({
//     this.message,
//     this.user,
//     this.tokens,
//   });

//   // Initial method to return an AuthState with default values
//   static AuthState initial() {
//     return AuthState(
//       message: null,
//       user: User.initial(), // Initialize User with default values
//       tokens: Tokens.initial(), // Initialize Tokens with default values
//     );
//   }

//   // CopyWith method for AuthState
//   AuthState copyWith({
//     String? message,
//     User? user,
//     Tokens? tokens,
//   }) {
//     return AuthState(
//       message: message ?? this.message,
//       user: user ?? this.user,
//       tokens: tokens ?? this.tokens,
//     );
//   }

//   AuthState.fromJson(Map<String, dynamic> json) {
//     message = json['message'] as String?;
//     user = (json['user'] as Map<String, dynamic>?) != null
//         ? User.fromJson(json['user'] as Map<String, dynamic>)
//         : null;
//     tokens = (json['tokens'] as Map<String, dynamic>?) != null
//         ? Tokens.fromJson(json['tokens'] as Map<String, dynamic>)
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = <String, dynamic>{};
//     json['message'] = message;
//     json['user'] = user?.toJson();
//     json['tokens'] = tokens?.toJson();
//     return json;
//   }
// }

// class User {
//   String? username;
//   dynamic countryname;
//   dynamic state;
//   dynamic city;
//   dynamic address;
//   dynamic profilePic;
//   String? useRole;

//   User({
//     this.username,
//     this.countryname,
//     this.state,
//     this.city,
//     this.address,
//     this.profilePic,
//     this.useRole,
//   });

//   // Initial method for User class
//   static User initial() {
//     return User(
//       username: '',
//       countryname: null,
//       state: null,
//       city: null,
//       address: null,
//       profilePic: null,
//       useRole: '',
//     );
//   }

//   // CopyWith method for User
//   User copyWith({
//     String? username,
//     dynamic countryname,
//     dynamic state,
//     dynamic city,
//     dynamic address,
//     dynamic profilePic,
//     String? useRole,
//   }) {
//     return User(
//       username: username ?? this.username,
//       countryname: countryname ?? this.countryname,
//       state: state ?? this.state,
//       city: city ?? this.city,
//       address: address ?? this.address,
//       profilePic: profilePic ?? this.profilePic,
//       useRole: useRole ?? this.useRole,
//     );
//   }

//   User.fromJson(Map<String, dynamic> json) {
//     username = json['username'] as String?;
//     countryname = json['countryname'];
//     state = json['state'];
//     city = json['city'];
//     address = json['address'];
//     profilePic = json['profile_pic'];
//     useRole = json['use_role'] as String?;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = <String, dynamic>{};
//     json['username'] = username;
//     json['countryname'] = countryname;
//     json['state'] = state;
//     json['city'] = city;
//     json['address'] = address;
//     json['profile_pic'] = profilePic;
//     json['use_role'] = useRole;
//     return json;
//   }
// }

// class Tokens {
//   String? accessToken;
//   String? refreshToken;
//   String? accessTokenExpiry;
//   String? refreshTokenExpiry;

//   Tokens({
//     this.accessToken,
//     this.refreshToken,
//     this.accessTokenExpiry,
//     this.refreshTokenExpiry,
//   });

//   // Initial method for Tokens class
//   static Tokens initial() {
//     return Tokens(
//       accessToken: '',
//       refreshToken: '',
//       accessTokenExpiry: '',
//       refreshTokenExpiry: '',
//     );
//   }

//   // CopyWith method for Tokens
//   Tokens copyWith({
//     String? accessToken,
//     String? refreshToken,
//     String? accessTokenExpiry,
//     String? refreshTokenExpiry,
//   }) {
//     return Tokens(
//       accessToken: accessToken ?? this.accessToken,
//       refreshToken: refreshToken ?? this.refreshToken,
//       accessTokenExpiry: accessTokenExpiry ?? this.accessTokenExpiry,
//       refreshTokenExpiry: refreshTokenExpiry ?? this.refreshTokenExpiry,
//     );
//   }

//   Tokens.fromJson(Map<String, dynamic> json) {
//     accessToken = json['accessToken'] as String?;
//     refreshToken = json['refreshToken'] as String?;
//     accessTokenExpiry = json['accessTokenExpiry'] as String?;
//     refreshTokenExpiry = json['refreshTokenExpiry'] as String?;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = <String, dynamic>{};
//     json['accessToken'] = accessToken;
//     json['refreshToken'] = refreshToken;
//     json['accessTokenExpiry'] = accessTokenExpiry;
//     json['refreshTokenExpiry'] = refreshTokenExpiry;
//     return json;
//   }
// }
class AuthState {
  final int? statusCode;
  final bool? success;
  final List<String>? messages;
  final Data? data;

  AuthState({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
  });

  // Factory constructor for initial state
  factory AuthState.initial() {
    return AuthState(
      statusCode: null,
      success: null,
      messages: [],
      data: null,
    );
  }

  // copyWith method to create a copy with updated fields
  AuthState copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    Data? data,
  }) {
    return AuthState(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  // Factory constructor to create an AuthState object from JSON
  AuthState.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'] as int?,
        success = json['success'] as bool?,
        messages = (json['messages'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  // Method to convert AuthState object to JSON
  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'success': success,
        'messages': messages,
        'data': data?.toJson(),
      };
}

class Data {
  final int? userId;
  final String? username;
  final dynamic countryname;
  final dynamic state;
  final dynamic city;
  final dynamic address;
  final dynamic profilePic;
  final String? useRole;
  final dynamic idFront;
  final dynamic idBack;
  final dynamic idCard;
  final dynamic bankaccountno;
  final dynamic bankname;
  final dynamic ifsccode;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic radius;
  final String? accessToken;
  final int? accessTokenExpiresAt;
  final String? refreshToken;
  final int? refreshTokenExpiresAt;

  Data({
    this.userId,
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
  });

  // Factory constructor for initial state
  factory Data.initial() {
    return Data(
      userId: null,
      username: null,
      countryname: null,
      state: null,
      city: null,
      address: null,
      profilePic: null,
      useRole: null,
      idFront: null,
      idBack: null,
      idCard: null,
      bankaccountno: null,
      bankname: null,
      ifsccode: null,
      latitude: null,
      longitude: null,
      radius: null,
      accessToken: null,
      accessTokenExpiresAt: null,
      refreshToken: null,
      refreshTokenExpiresAt: null,
    );
  }

  // copyWith method to create a copy with updated fields
  Data copyWith({
    int? userId,
    String? username,
    dynamic countryname,
    dynamic state,
    dynamic city,
    dynamic address,
    dynamic profilePic,
    String? useRole,
    dynamic idFront,
    dynamic idBack,
    dynamic idCard,
    dynamic bankaccountno,
    dynamic bankname,
    dynamic ifsccode,
    dynamic latitude,
    dynamic longitude,
    dynamic radius,
    String? accessToken,
    int? accessTokenExpiresAt,
    String? refreshToken,
    int? refreshTokenExpiresAt,
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
    );
  }

  // Factory constructor to create a Data object from JSON
  Data.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'] as int?,
        username = json['username'] as String?,
        countryname = json['countryname'],
        state = json['state'],
        city = json['city'],
        address = json['address'],
        profilePic = json['profile_pic'],
        useRole = json['use_role'] as String?,
        idFront = json['id_front'],
        idBack = json['id_back'],
        idCard = json['id_card'],
        bankaccountno = json['bankaccountno'],
        bankname = json['bankname'],
        ifsccode = json['ifsccode'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        radius = json['radius'],
        accessToken = json['access_token'] as String?,
        accessTokenExpiresAt = json['access_token_expires_at'] as int?,
        refreshToken = json['refresh_token'] as String?,
        refreshTokenExpiresAt = json['refresh_token_expires_at'] as int?;

  // Method to convert Data object to JSON
  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'username': username,
        'countryname': countryname,
        'state': state,
        'city': city,
        'address': address,
        'profile_pic': profilePic,
        'use_role': useRole,
        'id_front': idFront,
        'id_back': idBack,
        'id_card': idCard,
        'bankaccountno': bankaccountno,
        'bankname': bankname,
        'ifsccode': ifsccode,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'access_token': accessToken,
        'access_token_expires_at': accessTokenExpiresAt,
        'refresh_token': refreshToken,
        'refresh_token_expires_at': refreshTokenExpiresAt,
      };
}

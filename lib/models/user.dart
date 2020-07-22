import 'package:amazon_cognito_identity_dart/cognito.dart';

class User {
  final CognitoUserSession session;
  bool isConfirmed;
  bool passwordResetRequired;
  String email;
  String name;

  String get jwtToken => session?.getIdToken()?.getJwtToken();

  User({this.email, this.name, this.session});

  factory User.fromUserAttributes(
      List<CognitoUserAttribute> attributes, CognitoUserSession session) {
    print("Processing attributes: $attributes");

    final result = User(session: session);

    attributes.forEach((attribute) {
      switch (attribute.getName()) {
        case 'email':
          result.email = attribute.getValue();
          break;

        case 'name':
          result.name = attribute.getValue();
          break;

        default:
          print("Unknown attribute ${attribute.getName()}");
      }
    });

    return result;
  }
}

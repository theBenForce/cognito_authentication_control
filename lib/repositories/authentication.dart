import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:cognito_authentication_control/models/session_storage.dart';
import 'package:cognito_authentication_control/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthenticationRepo {
  bool isAuthenticated = false;
  AwsSigV4Client awsSigV4Client;
  CognitoUserPool _userPool;
  CognitoUser _cognitoUser;
  CognitoUserSession _session;
  CognitoCredentials _credentials;

  final String userPoolId;
  final String clientId;

  UserAuthenticationRepo({@required this.userPoolId, @required this.clientId});

  String get jwtToken => _session?.getIdToken()?.getJwtToken();

  Future<bool> init() async {
    var sessionStorage = SessionStorage(await SharedPreferences.getInstance());
    _userPool = CognitoUserPool(userPoolId, clientId, storage: sessionStorage);

    _cognitoUser = await _userPool.getCurrentUser();
    if (_cognitoUser == null) {
      return false;
    }

    _session = await _cognitoUser.getSession();
    return _session?.isValid() == true;
  }

  /// Get existing user from session with his/her attributes
  Future<User> getCurrentUser() async {
    if (_userPool == null) await this.init();

    if (_cognitoUser == null || _session == null) {
      return null;
    }
    if (_session?.isValid() != true) {
      return null;
    }
    final attributes = await _cognitoUser.getUserAttributes();
    if (attributes == null) {
      return null;
    }
    final user = User.fromUserAttributes(attributes, _session);
    return user;
  }

  Future<User> login(String email, String password) async {
    if (_userPool == null) await this.init();

    _cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);

    final authDetails =
        new AuthenticationDetails(username: email, password: password);

    bool isConfirmed;
    try {
      _session = await _cognitoUser.authenticateUser(authDetails);
      isConfirmed = true;
    } on CognitoClientException catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        isConfirmed = false;
      } else {
        throw e;
      }
    }

    final attributes = await _cognitoUser.getUserAttributes();
    User user = new User.fromUserAttributes(attributes, _session);
    user.isConfirmed = isConfirmed;

    return user;
  }

  Future<bool> confirmAccount(String email, String confirmationCode) async {
    if (_userPool == null) await this.init();

    _cognitoUser =
        new CognitoUser(email, _userPool, storage: _userPool.storage);

    return await _cognitoUser.confirmRegistration(confirmationCode);
  }

  Future<void> resendConfirmationCode(String email) async {
    if (_userPool == null) await this.init();

    _cognitoUser =
        new CognitoUser(email, _userPool, storage: _userPool.storage);

    return await _cognitoUser.resendConfirmationCode();
  }

  Future<bool> resetPassword(
      String email, String oldPassword, String newPassword) async {
    if (_userPool == null) await this.init();

    _cognitoUser =
        new CognitoUser(email, _userPool, storage: _userPool.storage);

    final authDetails = new AuthenticationDetails(
        username: email, password: oldPassword, authParameters: []);

    try {
      await _cognitoUser.initiateAuth(authDetails);
    } on CognitoUserNewPasswordRequiredException catch (e) {}

    return await _cognitoUser.changePassword(oldPassword, newPassword);
  }
}

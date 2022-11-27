class UserSigning {
  String _email;
  String _password;
  bool _isLoading = false;

  UserSigning(this._email, this._password, this._isLoading);

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  set email(String email) {
    _email = email;
  }

  set password(String password) {
    _password = password;
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
  }
}

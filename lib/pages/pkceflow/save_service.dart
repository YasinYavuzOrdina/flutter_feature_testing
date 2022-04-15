class SaveService {
  static final SaveService _instance = SaveService._internal();

  // passes the instantiation to the _instance object
  factory SaveService() => _instance;

  //initialize variables in here
  SaveService._internal() {
    _codeVerifier = '';
  }

  String _codeVerifier = '';
  String get codeVerifier => _codeVerifier;
  set saveCodeVerifier(String code) => _codeVerifier = code;
}

import '../models/utilisateur.dart';

class Session {
  static Utilisateur? currentUser;

  static void login(Utilisateur user) {
    currentUser = user;
  }

  static void logout() {
    currentUser = null;
  }

  static bool isLoggedIn() {
    return currentUser != null;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import '../API/Auth.dart';
import 'BaseScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {return LoginState();}
}

class LoginState extends State<LoginScreen> {
  BaseAuth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FlutterLogin(
              title: 'MyNewsletter',
              onLogin: signIn,
              onSignup: signUp,
              onSubmitAnimationCompleted: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => BaseScreen(),
                ));
              },
              onRecoverPassword: recoverPassword,
              theme: LoginTheme(
                  primaryColor: Colors.amber,
                  pageColorLight: Colors.grey,
                  accentColor: Colors.white,
                  errorColor: Colors.deepOrange
              ),
              messages: LoginMessages(
                  usernameHint: "E-mail",
                  passwordHint: "Hasło",
                  confirmPasswordHint: "Powtórz hasło",
                  forgotPasswordButton: "Nie pamiętasz hasła?",
                  loginButton: "Zaloguj",
                  signupButton: "Zarejestruj",
                  recoverPasswordButton: "Wyślij",
                  recoverPasswordIntro: "Zmiana hasła",
                  recoverPasswordDescription: "Na podany adres wysłany zostanie link do zmiany hasła",
                  recoverPasswordSuccess: "Wysłano emial z linkiem",
                  goBackButton: "Powrót",
                  confirmPasswordError: "Hasła nie są takie same"),
            )
        )
    );
  }

  Future<String> signIn(LoginData data) {
    return auth.signIn(data.name, data.password).then((_) {
      return null;
    }, onError: (error) {
      return getErrorMessage(error);
    });
  }

  Future<String> signUp(LoginData data) {
    return auth.signUp(data.name, data.password).then((_) {
      return null;
    }, onError: (error) {
      return getErrorMessage(error);
    });
  }

  Future<String> recoverPassword(String name) {
    return auth.recoverPassword(name).then((_) {
      return null;
    }, onError: (error) {
      return getErrorMessage(error);
    });
  }

  String getErrorMessage(PlatformException error) {
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_WRONG_PASSWORD":
        return "Podano błędny email lub hasło";
      case "ERROR_USER_NOT_FOUND":
        return "Użytkownik nie istnieje";
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "Użytkownik już istnieje";
      default:
        return "Błąd - spróbuj ponownie";
    }
  }
}

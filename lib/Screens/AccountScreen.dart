import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynewsletter/API/Auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccountScreenState();
  }
}

class AccountScreenState extends State<AccountScreen> {
  bool isLoading = true;
  String _email;

  @override
  void initState() {
    _getUserEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: CircularProgressIndicator()
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ustawienia konta',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.5,
      ),
      body: Column(
        children: <Widget>[
          _createAccountInfo(),
          _createChangePasswordButton(),
          _createSignOutButton(),
          _createHelpInfo()
        ],
      ),
    );
  }

  Widget _createAccountInfo() {
    return Row(children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: 58, left: 32),
        child: Row(
          children: <Widget>[
            Icon(Icons.account_circle, size: 60),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_email, style: TextStyle(fontSize: 16),),
                  Text("Typ konta: Standard", style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16
                  ))
                ],
              ),
            )
          ],
        ),
      )
    ],);
  }

  Widget _createChangePasswordButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 80),
              child: ButtonTheme(
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: () {
                      _changePasswordPressed(context);
                    },
                    child: Text("Zmień hasło", style: TextStyle(color: Colors.white)),
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
                    ),
                  )
              )
          )
        ]);
  }

  Widget _createSignOutButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30, left: 32, right: 32),
            child: ButtonTheme(
                minWidth: 200,
                child: RaisedButton(
                  onPressed: () {
                    Auth().signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  },
                  child: Text("Wyloguj", style: TextStyle(color: Colors.white)),
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)
                  ),
                )),
          )
        ]);
  }

  Widget _createHelpInfo() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Container(
                width: 400,
                padding: EdgeInsets.only(top: 100, left: 32, right: 32),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Potrzebujesz pomocy?\nSkontaktuj się z nami przez:'),
                      TextSpan(
                          text: '\nmynewsletter.support@gmail.com',
                          style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              )
          )
        ]);
  }

  void _getUserEmail() async {
    var email = await FlutterSecureStorage().read(key: 'email') ?? '';
    setState(() {
      _email = email;
      isLoading = false;
    });
  }

  _changePasswordPressed(context) {
    Auth().sendPasswordResetEmail(_email);
    Alert(
      context: context,
      type: AlertType.info,
      title: "Zmiana hasła",
      desc: "Na Twój adres email wysłano link, przez który możesz ustawić nowe hasło.",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}
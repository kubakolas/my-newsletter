import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynewsletter/API/Rest.dart';
import 'package:mynewsletter/Model/UserMessage.dart';
import 'MessageTile.dart';

class MessagesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessagesScreenState();
  }
}

class MessagesScreenState extends State<MessagesScreen> {
  var rest = Rest();
  List<UserMessage> messages;
  List<UserMessage> filteredMessages = new List();
  TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = Icon(Icons.search, color: Colors.grey);
  Widget _appBarTitle =
  Text('Newsletters', style: TextStyle(color: Colors.black));
  Icon _favouriteIcon = Icon(Icons.star_border, color: Colors.amberAccent);
  bool onlyFavourites = false;
  bool isLoading = false;
  int expandedIndex;

  MessagesScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredMessages = messages;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void getMessages() async {
    _setIsLoading(true);
    try {
      var tmp = await rest.getMessages();
      setState(() {
        isLoading = false;
        messages = tmp;
        filteredMessages = messages;
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Błąd połączenia z serwerem')));
      });
    }
  }

  @override
  void initState() {
    _appBarTitle = buildAppBarTitle(false);
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey))
      );
    }
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: _appBarTitle,
//        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.5,
        leading: IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
          color: Colors.blueGrey,
        ),
      ),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      if (onlyFavourites) {
        filteredMessages = messages.where((m) => m.contains(_searchText.toLowerCase()) && m.isFavourite).toList();
      } else {
        filteredMessages = messages.where((m) => m.contains(_searchText.toLowerCase())).toList();
      }
    } else {
      if (onlyFavourites) {
        filteredMessages = messages.where((message) => message.isFavourite).toList();
      } else {
        filteredMessages = messages;
      }
    }
    if (messages == null || messages.isEmpty) {
      return Center(child: Text("Brak wiadomości"));
    } else {
      return ListView.builder(
        itemCount: filteredMessages.length,
        itemBuilder: (BuildContext context, int index) {
          return MessageTile(filteredMessages[index], _getMessages, _updateMessage, _setIsLoading);
        },
      );
    }
  }

  _getMessages(String a) {
    getMessages();
  }

  _updateMessage(UserMessage message) {
    var index = messages.indexWhere((element) => element.id == message.id);
    setState(() {
      messages[index] = message;
    });
  }

  _setIsLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = new Icon(Icons.close, color: Colors.grey);
        _appBarTitle = buildAppBarTitle(true);
      } else {
        _searchIcon = new Icon(Icons.search, color: Colors.grey);
        _appBarTitle = buildAppBarTitle(false);
        filteredMessages = messages;
        _filter.clear();
      }
    });
  }

  Widget buildAppBarTitle(bool showSearch) {
    if (showSearch) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: TextField(
                controller: _filter,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Wyszukaj...',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                )),
          ),
          buildFovouriteIcon()
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
              child: Center(
                  child: Text('Twoje wiadomości',
                      style: TextStyle(color: Colors.black)))),
          buildFovouriteIcon()
        ],
      );
    }
  }

  IconButton buildFovouriteIcon() {
    return IconButton(
        icon: _favouriteIcon,
        onPressed: _favouritePressed
    );
  }

  void _favouritePressed() {
    setState(() {
      onlyFavourites = !onlyFavourites;
      if (onlyFavourites) {
        _favouriteIcon = Icon(Icons.star, color: Colors.amberAccent);
      } else {
        _favouriteIcon = Icon(Icons.star_border, color: Colors.amberAccent);
      }
      _appBarTitle = buildAppBarTitle(_searchIcon.icon != Icons.search);
    });
  }
}

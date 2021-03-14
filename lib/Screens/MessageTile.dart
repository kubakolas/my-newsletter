import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mynewsletter/API/Rest.dart';
import 'package:mynewsletter/Model/UserMessage.dart';
import 'MessageScreen.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {

  UserMessage message;
  ValueChanged<String> refreshMessages;
  ValueChanged<UserMessage> updateMessage;
  ValueChanged<bool> setIsLoading;

  MessageTile(UserMessage message, ValueChanged<String> refreshMessages, ValueChanged<UserMessage> updateMessage, ValueChanged<bool> setIsLoading) {
    this.message = message;
    this.refreshMessages = refreshMessages;
    this.updateMessage = updateMessage;
    this.setIsLoading = setIsLoading;
  }

  ListTile createTile(BuildContext context) {
    var isUnread = message.isUnread;
    var dateFormat = DateFormat("dd.MM.yyyy");
    var dateString = dateFormat.format(message.message.date);
    return ListTile(
        leading: isUnread ? Icon(Icons.email, color: Colors.amber) : Icon(Icons.mail_outline, color: Colors.amber),
        title: Text(message.message.shop.name,
            style: TextStyle(
              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
            )),
        subtitle: Text(message.message.subject,
            style: TextStyle(
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
        trailing: Text(dateString, style: TextStyle(color: Colors.grey),),
        onTap: () {
          if (isUnread) {
            markAsRead();
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageScreen(message.message),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: new Container(
        color: Colors.white,
        child: createTile(context),
      ),
      actions: <Widget>[
        new IconSlideAction(
          caption: 'Ulubione',
          color: Colors.amberAccent,
          icon: message.isFavourite ? Icons.star : Icons.star_border,
          onTap: () {
            updateFavourite(context);
          },
          foregroundColor: Colors.white,
          closeOnTap: false,
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Usuń',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            deleteMessage();
          }
        ),
      ],
    );
  }

  void markAsRead() {
    var userMessage = UserMessage();
    userMessage.isUnread = false;
    userMessage.isFavourite = message.isFavourite;
    userMessage.id = message.id;
    userMessage.messageId = message.messageId;
    userMessage.userId = message.userId;
    userMessage.message = message.message;
    Rest().putUserMessage(userMessage);
    updateMessage(userMessage);
  }

  void updateFavourite(BuildContext context) async {
    setIsLoading(true);
    var userMessage = UserMessage();
    userMessage.isUnread = message.isUnread;
    userMessage.isFavourite = !message.isFavourite;
    userMessage.id = message.id;
    userMessage.messageId = message.messageId;
    userMessage.userId = message.userId;
    userMessage.message = message.message;
    try {
      await Rest().putUserMessage(userMessage);
    } catch(Exception) {
      setIsLoading(false);
    } finally {
      updateMessage(userMessage);
      setIsLoading(false);
    }
  }

  void deleteMessage() async {
    await Rest().deleteUserMessage(message.id);
    refreshMessages("");
  }
}

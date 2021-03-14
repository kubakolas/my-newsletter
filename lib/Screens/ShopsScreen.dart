import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynewsletter/API/Rest.dart';
import 'package:mynewsletter/Model/Shop.dart';
import 'package:mynewsletter/Model/Subscription.dart';

class ShopsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShopsScreenState();
  }
}

class ShopsScreenState extends State<ShopsScreen> {
  var rest = Rest();
  List<Subscription> subscriptions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSubscriptions();
  }

  void getSubscriptions() async {
    _setIsLoading(true);
    try {
      var tmp = await rest.getSubscriptions();
      setState(() {
        isLoading = false;
        subscriptions = tmp;
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Błąd połączenia z serwerem')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Subskrybowane sklepy',
                style: TextStyle(color: Colors.black)),
//        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.5,
      ),
      body: (isLoading) ? Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey))
      ) : createShopsList(),
    );
  }

  Widget createShopsList() {
    return FutureBuilder<List<Shop>>(
      future: rest.getShops(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Shop> data = snapshot.data;
          if (data.length > 0) {
            return shopsView(data);
          } else {
            return Center(child: Text("Brak subskrybowanych sklepów"));
          }
        } else if (snapshot.hasError) {
          return Center(child: Text("Brak subskrybowanych sklepów"));
        }
        return Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey))
        );
      },
    );
  }

  ListView shopsView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return tile(data[index]);
        });
  }

  CheckboxListTile tile(Shop shop) {
    var subscription = subscriptions.firstWhere((sub) => sub.shopId == shop.id, orElse: () => null);
    return CheckboxListTile(
        activeColor: Colors.amber,
        value: subscription != null,
        title: Text(shop.name,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            )),
        subtitle: Text(shop.email, style: TextStyle(fontWeight: FontWeight.normal)),
        onChanged: (bool value) {
          if (value) {
            addSubscription(shop.id);
          } else {
            deleteSubscription(subscription.id);
          }
          setState(() {});
        });
  }

  void addSubscription(int shopId) async {
    _setIsLoading(true);
    var subscription  = Subscription();
    subscription.shopId = shopId;
    var addedSub = await rest.postSubscription(subscription);
    if (subscriptions.firstWhere((sub) => sub.shopId == addedSub.shopId, orElse: () => null) == null) {
      subscriptions.add(addedSub);
    }
    _setIsLoading(false);
  }

  void deleteSubscription(int subscriptionId) async {
    _setIsLoading(true);
    await rest.deleteSubscription(subscriptionId);
    subscriptions.removeWhere((sub) => sub.id == subscriptionId);
    _setIsLoading(false);
  }

  void _setIsLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }
}

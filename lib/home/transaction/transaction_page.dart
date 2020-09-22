import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heard/api/transaction.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/home/transaction/history_page.dart';
import 'package:heard/http_services/booking_services.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<Transaction> transactionRequests;
  String authToken;
  bool isSLI;

  List<Transaction> pendingList = [];
  List<Transaction> acceptedList = [];
  List<UserInfoTemp> mockInfoList = [
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        status: 'Tamat',
        date: '20-03-2020',
        time: '3.00pm'),
    UserInfoTemp().addInfo(
        name: 'Kyle Jenner',
        status: 'Belum Diterima',
        date: '28-06-2020',
        time: '7.00pm'),
    UserInfoTemp().addInfo(
        name: 'Kim Possible',
        status: 'accepted',
        date: '02-04-2020',
        time: '9.00pm'),
    UserInfoTemp().addInfo(
        name: 'Arthur Knight',
        status: 'Tamat',
        date: '20-03-2020',
        time: '11.00pm'),
    UserInfoTemp().addInfo(
        name: 'John Monash',
        status: 'Dibatal',
        date: '20-03-2020',
        time: '10.00pm'),
    UserInfoTemp().addInfo(
        name: 'Michael Lee',
        status: 'accepted',
        date: '20-03-2020',
        time: '9.00pm'),
    UserInfoTemp().addInfo(
        name: 'Takashi Hiro',
        status: 'accepted',
        date: '20-03-2020',
        time: '8.00pm'),
  ];

  @override
  void initState() {
    super.initState();
    initializeTransaction();
  }

  void _onRefresh() async {
    /// added get token again because token constantly changes
    authToken = await AuthService.getToken();
    List<Transaction> allRequests = await BookingServices().getAllTransactions(headerToken: authToken, isSLI: isSLI);
    setState(() {
      transactionRequests = allRequests;
      separateTransactions();
    });
    print('Refreshing all booking requests ...');
    print('Updated Request: $transactionRequests and length of ${transactionRequests.length}');
    if (transactionRequests == null) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  void initializeTransaction() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isSLI = preferences.getBool('isSLI');
    });
    String authTokenString = await AuthService.getToken();
    List<Transaction> allRequests = await BookingServices().getAllTransactions(headerToken: authTokenString, isSLI: isSLI);
    setState(() {
      authToken = authTokenString;
      transactionRequests = allRequests;
    });
    separateTransactions();
    print('Set state complete! transaction: $transactionRequests}');
  }

  void separateTransactions() {
    acceptedList.clear();
    pendingList.clear();
    for (Transaction item in transactionRequests) {
      if (item.status == 'accepted') {
        acceptedList.add(item);
      }
      else if (item.status == 'pending') {
        pendingList.add(item);
      }
    }
  }

  Widget getListItem({Transaction transaction}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(Dimensions.d_20),
          isThreeLine: true,
          leading: Icon(
            Icons.account_circle,
            size: Dimensions.d_55,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${!isSLI ? 'BIM: ${transaction.sliName}': 'Pesakit: ${transaction.userName}'}', style: TextStyle(color: Colours.black, fontSize: FontSizes.smallerText),),
              Text('Tarikh: ${transaction.date}', style: TextStyle(color: Colours.black, fontSize: FontSizes.smallerText),),
              Text('Masa: ${transaction.time}', style: TextStyle(color: Colours.black, fontSize: FontSizes.smallerText),),
              Row(
                children: [
                  Text('Status: ', style: TextStyle(color: Colours.black, fontSize: FontSizes.smallerText),),
                  Text('${transaction.status == 'accepted' ? 'Diterima' : 'Belum Diterima'}', style: TextStyle(color: transaction.status == 'accepted' ? Colours.accept : Colours.pending, fontSize: FontSizes.smallerText, fontWeight: FontWeight.bold),)
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: Dimensions.d_0,
          thickness: Dimensions.d_3,
          color: Colours.lightGrey,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colours.white,
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        header: ClassicHeader(),
        child: (transactionRequests == null)
            ? Center(child: CircularProgressIndicator())
            : (transactionRequests.length == 0)
            ? Center(
          child: Text('Tiada Transaksi Pada Masa Ini'),
        )
            : ListView(
          children: <Widget>[
            isSLI ? SizedBox.shrink() : Column(
              children: [
                GreyTitleBar(
                    title: 'Transaksi Belum Diterima',
                    trailing: Container(
                      height: Dimensions.d_20,
                    )
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  itemCount: pendingList.length,
                  itemBuilder: (context, index) {
                    return getListItem(transaction: pendingList[index]);
                  },
                )
              ],
            ),
            GreyTitleBar(
              title: 'Transaksi Diterima',
              trailing: Container(
                height: Dimensions.d_25,
                child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.buttonRadius)),
                  child: RaisedButton(
                    color: Colours.white,
                    child: Text('Sejarah'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  HistoryPage(isSLI: isSLI, transactionRequests: transactionRequests)));
                    },
                  ),
                ),
              )
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: acceptedList.length,
              itemBuilder: (context, index) {
                return getListItem(transaction: acceptedList[index]);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class UserInfoTemp {
  String name;
  String date;
  String time;
  String status;

  UserInfoTemp addInfo(
      {@required String name,
        @required String date,
        @required String time,
        @required String status}) {
    UserInfoTemp newPerson = UserInfoTemp();
    newPerson.name = name;
    newPerson.date = date;
    newPerson.time = time;
    newPerson.status = status;

    return newPerson;
  }
}

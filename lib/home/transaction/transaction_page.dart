import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heard/api/booking_request.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/home/transaction/history_page.dart';
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

  List<BookingRequest> transactionRequests;
  String authToken;
  bool isSLI;

  List<UserInfoTemp> pendingList = [];
  List<UserInfoTemp> acceptedList = [];
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
        status: 'Diterima',
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
        status: 'Diterima',
        date: '20-03-2020',
        time: '9.00pm'),
    UserInfoTemp().addInfo(
        name: 'Takashi Hiro',
        status: 'Diterima',
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
    // List<BookingRequest> allRequests =
    // await BookingServices().getAllCurrentRequests(headerToken: authToken);
    // setState(() {
    //   transactionRequests = allRequests;
    // });
    print('Refreshing all booking requests ...');
    print(
        'Updated Request: $mockInfoList and length of ${mockInfoList.length}');
    if (mockInfoList == null) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  void initializeTransaction() async {
    // String authTokenString = await AuthService.getToken();
    // List<BookingRequest> allRequests = await BookingServices().getAllCurrentRequests(headerToken: authTokenString);
    // setState(() {
    //   authToken = authTokenString;
    //   transactionRequests = allRequests;
    // });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isSLI = preferences.getBool('isSLI');
    });
    separateTransactions();
    print('Set state complete! booking: $mockInfoList}');
  }

  void separateTransactions() {
    for (UserInfoTemp item in mockInfoList) {
      if (item.status == 'Diterima') {
        acceptedList.add(item);
      }
      else if (item.status == 'Belum Diterima') {
        pendingList.add(item);
      }
    }

  }

  // Future<bool> confirmationModal(
  //     {BuildContext context, int index, bool isAcceptBooking}) async {
  //   bool response;
  //   await popUpDialog(
  //       context: context,
  //       isSLI: true,
  //       header: 'Pengesahan',
  //       content: Text(
  //         'Adakah Anda Pasti ${isAcceptBooking ? 'Terima' : 'Tolak'}?',
  //         textAlign: TextAlign.left,
  //         style: TextStyle(color: Colours.darkGrey, fontSize: FontSizes.normal),
  //       ),
  //       buttonText: 'Teruskan',
  //       onClick: () {
  //         Navigator.pop(context);
  //       });
  //   response = await postBookingResponse(
  //       index: index, isAcceptBooking: isAcceptBooking);
  //   return response;
  // }

  // Future<bool> postBookingResponse({int index, bool isAcceptBooking}) async {
  //   bool toRemoveBooking = false;
  //
  //   /// showing loading screen when post response to backend
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  //   bool responseResult = await BookingServices().postSLIResponse(
  //       headerToken: authToken,
  //       bookingID: mockInfoList[index].bookingId,
  //       isAcceptBooking: isAcceptBooking);
  //   Navigator.pop(context);
  //
  //   if (responseResult) {
  //     toRemoveBooking = true;
  //     if (isAcceptBooking) {
  //       await confirmRequestModal(
  //           isAcceptBooking: isAcceptBooking, isSuccessAccept: true);
  //     }
  //   } else {
  //     await confirmRequestModal(
  //         isAcceptBooking: isAcceptBooking, isSuccessAccept: false);
  //   }
  //
  //   return toRemoveBooking;
  // }

  // Future<void> confirmRequestModal(
  //     {bool isAcceptBooking, bool isSuccessAccept}) async {
  //   await popUpDialog(
  //       context: context,
  //       isSLI: true,
  //       header: isSuccessAccept ? 'Pengesahan' : 'Amaran',
  //       touchToDismiss: false,
  //       content: Text(
  //         isSuccessAccept
  //             ? 'Berjaya Menerima Permintaan!'
  //             : 'Gagal ${isAcceptBooking ? 'Menerima' : 'Menolak'} Permintaan',
  //         textAlign: TextAlign.left,
  //         style: TextStyle(color: Colours.darkGrey, fontSize: FontSizes.normal),
  //       ),
  //       onClick: () {
  //         Navigator.pop(context);
  //       });
  // }

  Widget getListItem({UserInfoTemp transaction}) {
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
              Text('${!isSLI ? 'BIM:' : 'Pesakit:'} ${transaction.name}', style: TextStyle(color: Colours.black, fontSize: FontSizes.smallerText),),
              Text('Tarikh: ${transaction.date}', style: TextStyle(color: Colours.black, fontSize: FontSizes.smallerText),),
              Text('Masa: ${transaction.time}', style: TextStyle(color: Colours.black, fontSize: FontSizes.smallerText),),
              Row(
                children: [
                  Text('Status: ', style: TextStyle(color: Colours.black, fontSize: FontSizes.smallerText),),
                  Text('${transaction.status}', style: TextStyle(color: transaction.status == 'Diterima' ? Colours.accept : Colours.darkGrey, fontSize: FontSizes.smallerText, fontWeight: FontWeight.bold),)
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
        child: (mockInfoList == null || pendingList.length == 0)
            ? Center(child: CircularProgressIndicator())
            : (mockInfoList.length == 0)
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
                                  HistoryPage(isSLI: isSLI, transactionRequests: mockInfoList)));
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

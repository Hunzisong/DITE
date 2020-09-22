import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heard/home/transaction/transaction_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HistoryPage extends StatefulWidget {
  final bool isSLI;
  final List<UserInfoTemp> transactionRequests;

  HistoryPage({@required this.isSLI, this.transactionRequests});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<UserInfoTemp> transactionHistory;

  void _onRefresh() async {
    /// added get token again because token constantly changes
    // String authToken = await AuthService.getToken();
    // List<BookingRequest> allRequests =
    // await BookingServices().getAllCurrentRequests(headerToken: authToken);
    // setState(() {
    //   transactionRequests = allRequests;
    // });
    print('Refreshing all booking requests ...');
    if (transactionHistory == null) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  Widget getListItem({UserInfoTemp transaction}) {
    return (transaction.status == 'Tamat' || transaction.status == 'Dibatal')
        ? Column(
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
                    Text(
                      '${!widget.isSLI ? 'BIM:' : 'Pesakit:'} ${transaction.name}',
                      style: TextStyle(
                          color: Colours.black,
                          fontSize: FontSizes.smallerText),
                    ),
                    Text(
                      'Tarikh: ${transaction.date}',
                      style: TextStyle(
                          color: Colours.black,
                          fontSize: FontSizes.smallerText),
                    ),
                    Text(
                      'Masa: ${transaction.time}',
                      style: TextStyle(
                          color: Colours.black,
                          fontSize: FontSizes.smallerText),
                    ),
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                              color: Colours.black,
                              fontSize: FontSizes.smallerText),
                        ),
                        Text(
                          '${transaction.status}',
                          style: TextStyle(
                              color: transaction.status == 'Tamat'
                                  ? Colours.accept
                                  : Colours.cancel,
                              fontSize: FontSizes.smallerText,
                              fontWeight: FontWeight.bold),
                        )
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
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (transactionHistory == null) {
      setState(() {
        transactionHistory = widget.transactionRequests;
      });
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          title: Text(
            'Sejarah',
            style: GoogleFonts.lato(
              fontSize: FontSizes.mainTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: widget.isSLI ? Colours.orange : Colours.blue,
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          enablePullDown: true,
          header: ClassicHeader(),
          child: (transactionHistory == null)
              ? Container
              : (transactionHistory.length == 0)
                  ? Center(
                      child: Text('Tiada Sejarah Pada Masa Ini'),
                    )
                  : ListView(
                      children: <Widget>[
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: ScrollController(),
                          shrinkWrap: true,
                          itemCount: transactionHistory.length,
                          itemBuilder: (context, index) {
                            return getListItem(
                                transaction: transactionHistory[index]);
                          },
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

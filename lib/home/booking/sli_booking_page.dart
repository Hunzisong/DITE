import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heard/api/on_demand_request.dart';
import 'package:heard/api/on_demand_status.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/on_demand/on_demand_success.dart';
import 'package:heard/http_services/on_demand_services.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SLIBookingPage extends StatefulWidget {
  final List<OnDemandRequest> onDemandRequests;

  SLIBookingPage({this.onDemandRequests});

  @override
  _SLIBookingPageState createState() => _SLIBookingPageState();
}

class _SLIBookingPageState extends State<SLIBookingPage>
    with AutomaticKeepAliveClientMixin {
  SlidableController slidableController;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool showLoadingAnimation = false;
  List<OnDemandRequest> bookingRequests;
  String authToken;
  bool showPairingComplete = false;
  OnDemandStatus onDemandStatus;

  List<UserInfoTemp> mockInfoList = [
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Sg Buloh',
        requestedDate: '20-03-2020',
        requestedTime: '3.00pm'),
    UserInfoTemp().addInfo(
        name: 'Kyle Jenner',
        hospital: 'Hospital Sg Long',
        requestedDate: '28-06-2020',
        requestedTime: '7.00pm'),
    UserInfoTemp().addInfo(
        name: 'Kim Possible',
        hospital: 'Hospital Sarawak',
        requestedDate: '02-04-2020',
        requestedTime: '9.00pm'),
    UserInfoTemp().addInfo(
        name: 'Arthur Knight',
        hospital: 'Hospital Kuala Lumpur',
        requestedDate: '20-03-2020',
        requestedTime: '11.00pm'),
    UserInfoTemp().addInfo(
        name: 'John Monash',
        hospital: 'Hospital Selangor',
        requestedDate: '20-03-2020',
        requestedTime: '10.00pm'),
    UserInfoTemp().addInfo(
        name: 'Michael Lee',
        hospital: 'Hospital Pahang',
        requestedDate: '20-03-2020',
        requestedTime: '9.00pm'),
    UserInfoTemp().addInfo(
        name: 'Takashi Hiro',
        hospital: 'Hospital Sabah',
        requestedDate: '20-03-2020',
        requestedTime: '8.00pm'),
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Pulau Pinang',
        requestedDate: '20-03-2020',
        requestedTime: '12.00pm'),
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Seremban',
        requestedDate: '20-03-2020',
        requestedTime: '1.00pm'),
  ];

  @override
  void initState() {
    super.initState();
    slidableController = SlidableController();
//    getOnDemandRequests();
  }

  void _onRefresh() async {
//    List<OnDemandRequest> allRequests =
//    await OnDemandServices().getAllRequests(headerToken: authToken);
//    setState(() {
//      bookingRequests = allRequests;
//    });
    print('Refreshing all booking requests ...');
//    print('Updated Request: $bookingRequests and length of ${bookingRequests.length}');
    if (bookingRequests == null) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  void initializeBooking() async {
    String authTokenString = await AuthService.getToken();
    List<BookingRequest> allRequests =
        await BookingServices().getAllCurrentRequests(headerToken: authToken);
    setState(() {
      authToken = authTokenString;
      bookingRequests = allRequests;
    });
    print('Set state complete! booking: $bookingRequests}');
  }

  Future<bool> confirmationModal(
      {BuildContext context, int index, bool isAcceptBooking}) async {
    bool response;
    await popUpDialog(
        context: context,
        isSLI: true,
        header: 'Pengesahan',
        content: Text(
          'Adakah Anda Pasti ${isAcceptBooking ? 'Terima' : 'Tolak'}?',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colours.darkGrey, fontSize: FontSizes.normal),
        ),
        buttonText: 'Teruskan',
        onClick: () {
          Navigator.pop(context);
        });
    response = await postBookingResponse(
        index: index, isAcceptBooking: isAcceptBooking);
    return response;
  }

  Future<bool> postBookingResponse({int index, bool isAcceptBooking}) async {
    bool toRemoveBooking = false;

    /// showing loading screen when post response to backend
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    bool responseResult = await BookingServices().postSLIResponse(
        headerToken: authToken,
        bookingID: mockInfoList[index].bookingId,
        isAcceptBooking: isAcceptBooking);
    Navigator.pop(context);

    /// todo: remove the hard-coded true variable when api is implemented
    responseResult = true;

    if (responseResult) {
      toRemoveBooking = true;
      if (isAcceptBooking) {
        await confirmRequestModal(
            isAcceptBooking: isAcceptBooking, isSuccessAccept: true);
      }
    } else {
      await confirmRequestModal(
          isAcceptBooking: isAcceptBooking, isSuccessAccept: false);
    }

    return toRemoveBooking;
  }

  Future<void> confirmRequestModal(
      {bool isAcceptBooking, bool isSuccessAccept}) async {
    await popUpDialog(
        context: context,
        isSLI: true,
        header: isSuccessAccept ? 'Pengesahan' : 'Amaran',
        touchToDismiss: false,
        content: Text(
          isSuccessAccept
              ? 'Berjaya Menerima Permintaan!'
              : 'Gagal ${isAcceptBooking ? 'Menerima' : 'Menolak'} Permintaan',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colours.darkGrey, fontSize: FontSizes.normal),
        ),
        onClick: () {
          Navigator.pop(context);
        });
  }

  Widget getListItem({int index}) {
    return SlidableListTile(
      onDismissed: (actionType) {
        setState(() {
          mockInfoList.removeAt(index);
        });
      },
      title: Text(
        '${mockInfoList[index].patientName}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${mockInfoList[index].uid}',
          ),
          Text(
            'Tarikh: ${mockInfoList[index].datetime}',
            style: TextStyle(color: Colours.darkGrey),
          ),
          Text(
            'Masa: ${mockInfoList[index].datetime}',
            style: TextStyle(color: Colours.darkGrey),
          ),
        ],
      ),
      slideRightActionFunctions: SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (slideContext, index, animation, renderingMode) {
            return IconSlideAction(
              caption: 'Tolak',
              color: Colours.cancel,
              icon: Icons.cancel,
              onTap: () async {
                SlidableState state = Slidable.of(slideContext);
                bool dismiss = await confirmationModal(
                    context: context, index: index, isAcceptBooking: false);
                if (dismiss) {
                  state.dismiss();
                }
              },
            );
          }),
      slideLeftActionFunctions: SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (context, index, animation, renderingMode) {
            return IconSlideAction(
                caption: 'Terima',
                color: Colours.accept,
                icon: Icons.done,
                onTap: () async {
                  var state = Slidable.of(context);
                  bool dismiss = await confirmationModal(
                      context: context, index: index, isAcceptBooking: true);
                  if (dismiss) {
                    state.dismiss();
                  }
                });
          }),
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
        header: WaterDropHeader(),
        child: (mockInfoList == null)
            ? Center(child: CircularProgressIndicator())
            : (mockInfoList.length == 0)
                ? Center(
                    child: Text('Tiada Tempahan Pada Masa Ini'),
                  )
                : ListView(
                    children: <Widget>[
                      GreyTitleBar(
                        title: 'Permintaan Tempahan',
                        trailing: Text(
                          '*Leret ke kanan untuk membatalkan tempahan',
                          style: TextStyle(
                              fontSize: FontSizes.tinyText,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: mockInfoList.length,
                        itemBuilder: (context, index) {
                          return getListItem(index: index);
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
  String patientName;
  String uid;
  String datetime;
  String bookingId = '123456';

  UserInfoTemp addInfo(
      {@required String name,
      @required String hospital,
      @required String requestedDateTime,
      String requestedTime = ''}) {
    UserInfoTemp newPerson = UserInfoTemp();
    newPerson.patientName = name;
    newPerson.uid = hospital;
    newPerson.datetime = requestedDateTime;

    return newPerson;
  }
}

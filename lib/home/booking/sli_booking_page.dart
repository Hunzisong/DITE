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

//  void getOnDemandRequests() async {
//    String authTokenString = await AuthService.getToken();
//    setState(() {
//      authToken = authTokenString;
//      bookingRequests = widget.onDemandRequests;
//    });
//    print('Set state complete! on-demand: $bookingRequests}');
//  }

  void confirmationModal({BuildContext context, int index}) async {
    await popUpDialog(
        context: context,
        isSLI: true,
        header: 'Pengesahan',
        content: Text(
          'Adakah Anda Pasti Terima?',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colours.darkGrey, fontSize: FontSizes.normal),
        ),
        buttonText: 'Teruskan',
        onClick: () async {
          Navigator.of(context).pop();
          setState(() {
            showLoadingAnimation = true;
          });
//          print('on demand id: ${mockInfoList[index].onDemandId}');
//          bool acceptanceResult = await OnDemandServices().acceptOnDemandRequest(headerToken: authToken, onDemandID: mockInfoList[index].onDemandId);
          bool acceptanceResult = false;
          if (acceptanceResult) {
            OnDemandStatus status = await OnDemandServices()
                .getOnDemandStatus(headerToken: authToken, isSLI: true);
            setState(() {
              showPairingComplete = true;
              onDemandStatus = status;
            });
          } else {
            confirmRequestError();
          }
          setState(() {
            showLoadingAnimation = false;
          });
        });
  }

  void confirmRequestError() {
    popUpDialog(
        context: context,
        isSLI: true,
        header: 'Amaran',
        touchToDismiss: false,
        content: Text(
          'Gagal Menerima Permintaan',
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
            '${mockInfoList[index].hospital}',
          ),
          Text(
            'Tarikh: ${mockInfoList[index].requestedDate}',
            style: TextStyle(color: Colours.darkGrey),
          ),
          Text(
            'Masa: ${mockInfoList[index].requestedTime}',
            style: TextStyle(color: Colours.darkGrey),
          ),
        ],
      ),
      slideRightActionFunctions: SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (context, index, animation, renderingMode) {
            return IconSlideAction(
              caption: 'Tolak',
              color: Colours.cancel,
              icon: Icons.cancel,
              onTap: () async {
                var state = Slidable.of(context);
                var dismiss = await cancelBookingModal(
                  context: context,
                  isSLI: true,
                  header: 'Pengesahan',
                  content: Text(
                    'Adakah Anda Pasti Tolak?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colours.darkGrey, fontSize: FontSizes.normal),
                  ),
                  buttonText: 'Teruskan',
                );
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
                onTap: () => confirmationModal(context: context, index: index));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return showPairingComplete
        ? OnDemandSuccessPage(
            isSLI: true,
            onDemandStatus: onDemandStatus,
            onCancelClick: () {
              Navigator.pop(context);
              setState(() {
                showPairingComplete = false;
              });
            },
          )
        : ModalProgressHUD(
            inAsyncCall: showLoadingAnimation,
            child: Scaffold(
              backgroundColor: Colours.white,
              body: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                enablePullDown: true,
                header: WaterDropHeader(),
                child: (mockInfoList == null)
                    ? Container()
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
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}

class UserInfoTemp {
  String patientName;
  String hospital;
  String requestedDate;
  String requestedTime;

  UserInfoTemp addInfo(
      {@required String name,
      @required String hospital,
      @required String requestedDate,
      String requestedTime = ''}) {
    UserInfoTemp newPerson = UserInfoTemp();
    newPerson.patientName = name;
    newPerson.hospital = hospital;
    newPerson.requestedDate = requestedDate;
    newPerson.requestedTime = requestedTime;

    return newPerson;
  }
}

Future<bool> cancelBookingModal(
    {BuildContext context,
    bool isSLI,
    bool touchToDismiss = true,
    double height,
    String header = '',
    @required Widget content,
    int contentFlexValue = 1,
    String buttonText = 'Tutup',
    Function onClick}) async {
  return showDialog(
      context: context,
      barrierDismissible: touchToDismiss,
      builder: (context) {
        return Dialog(
          child: Container(
            height: height != null ? height : Dimensions.d_280,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.d_15, horizontal: Dimensions.d_30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: Dimensions.d_10),
                      child: Text(
                        header,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: FontSizes.mainTitle,
                            color: Colours.darkGrey),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: contentFlexValue,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.d_15),
                      child: content,
                    ),
                  ),
                  Flexible(
                    child: UserButton(
                        text: buttonText,
                        color: isSLI ? Colours.orange : Colours.blue,
                        onClick: () async {
                          Navigator.of(context).pop(true);
                        }),
                  )
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.d_10))),
          elevation: Dimensions.d_15,
        );
      });
}

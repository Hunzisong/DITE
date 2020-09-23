import 'package:flutter/material.dart';
import 'package:heard/api/on_demand_status.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/http_services/on_demand_services.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OnDemandSuccessPage extends StatefulWidget {
  final Function onCancelClick;
  final AssetImage profilePic;
  final bool isSLI;
  final OnDemandStatus onDemandStatus;

  OnDemandSuccessPage(
      {this.onCancelClick,
      this.profilePic,
      this.onDemandStatus,
      this.isSLI = false});

  @override
  _OnDemandSuccessPageState createState() => _OnDemandSuccessPageState();
}

class _OnDemandSuccessPageState extends State<OnDemandSuccessPage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  final double paddingLR = Dimensions.d_20;
  String authToken;
  OnDemandStatus onDemandStatus;

  @override
  void initState() {
    super.initState();
    getOnDemandStatus();
  }

  void getOnDemandStatus() async {
    String authTokenString = await AuthService.getToken();
    setState(() {
      authToken = authTokenString;
      onDemandStatus = widget.onDemandStatus;
    });
  }

  void _onRefresh() async {
    authToken = await AuthService.getToken();

    OnDemandStatus status = await OnDemandServices().getOnDemandStatus(
        isSLI: widget.isSLI, headerToken: authToken);

    if (status.status != 'ongoing' && widget.isSLI == true) {
      widget.onCancelClick();
    }
    setState(() {
      onDemandStatus = status;
    });
    if (status == null) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return onDemandStatus == null
        ? Container()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              enablePullDown: true,
              header: ClassicHeader(),
              child: ListView(
                children: [
                  Padding(
                      padding: Paddings.horizontal_20,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: Dimensions.d_15),
                          Row(children: <Widget>[
                            SizedBox(
                              height: Dimensions.d_25,
                              child: Image(
                                  image: AssetImage('images/successTick.png')),
                            ),
                            SizedBox(
                              width: Dimensions.d_10,
                            ),
                            Text("Berpasangan dilengkapkan",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))
                          ]),
                          SizedBox(height: Dimensions.d_20),
                          SizedBox(
                            height: Dimensions.d_100,
                            child: Image(
                                image: this.widget.profilePic ??
                                    AssetImage('images/avatar.png')),
                          ),
                          SizedBox(height: Dimensions.d_15),
                          Text("${widget.isSLI ? onDemandStatus.details.patientName : onDemandStatus.details.sliName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.d_25)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.d_45,
                                vertical: Dimensions.d_15),
                            child: (widget.isSLI) ?
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.d_10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text('Nombor Telefon'),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ': ${onDemandStatus.details.userPhone}',
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.d_10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text('Nota'),
                                        ),
                                        Expanded(
                                          child: Text(
                                              ': ${onDemandStatus.details.note}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ) :
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.d_10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text('Jantina'),
                                      ),
                                      Expanded(
                                        child: Text(
                                          ': ${onDemandStatus.details.sliGender}',
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.d_10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text('Description'),
                                      ),
                                      Expanded(
                                        child: Text(
                                            ': ${this.onDemandStatus.details.sliDesc}'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          width: Dimensions.d_3,
                                          color: Colours.grey),
                                      bottom: BorderSide(
                                          width: Dimensions.d_3,
                                          color: Colours.grey))),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.d_15),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                            height: Dimensions.d_55,
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              backgroundColor: widget.isSLI
                                                  ? Colours.orange
                                                  : Colours.blue,
                                              onPressed: onTapMessage,
                                              elevation: Dimensions.d_0,
                                              child: Icon(
                                                Icons.message,
                                                size: Dimensions.d_30,
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                            height: Dimensions.d_55,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            width: Dimensions.d_3,
                                                            color:
                                                                Colours.grey))),
                                                child: FloatingActionButton(
                                                  heroTag: null,
                                                  backgroundColor: widget.isSLI
                                                      ? Colours.orange
                                                      : Colours.blue,
                                                  onPressed: onTapVideo,
                                                  elevation: Dimensions.d_0,
                                                  child: Icon(
                                                    Icons.videocam,
                                                    size: Dimensions.d_35,
                                                  ),
                                                ))),
                                      ),
                                    ],
                                  )))
                        ],
                      )),
                ],
              ),
            ),
            bottomNavigationBar: widget.isSLI
                ? SizedBox.shrink()
                : UserButton(
                    text: 'Batal Berpasangan',
                    padding: EdgeInsets.all(Dimensions.d_30),
                    color: Colours.cancel,
                    onClick: () {
                      OnDemandServices().endOnDemandRequest(headerToken: authToken);
                      widget.onCancelClick();
                    }),
          );
  }

  void onTapMessage() {
    debugPrint("Message is tapped");
  }

  void onTapVideo() {
    debugPrint("Video is tapped");
  }
}

import 'package:flutter/material.dart';
import 'package:heard/api/transaction.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/http_services/booking_services.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationPage extends StatefulWidget {
  final Function onCancelClick;
  final AssetImage profilePic;
  final bool isSLI;
  final Transaction transaction;

  InformationPage(
      {this.onCancelClick,
      this.profilePic,
      this.transaction,
      this.isSLI = false});

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final double paddingLR = Dimensions.d_20;
  String authToken;
  Transaction transaction;

  @override
  void initState() {
    super.initState();
    getOnDemandStatus();
  }

  void getOnDemandStatus() async {
    String authTokenString = await AuthService.getToken();
    setState(() {
      authToken = authTokenString;
      transaction = widget.transaction;
    });
  }

  void confirmationModal({String keyword, Function onClick}) {
    popUpDialog(
        context: context,
        isSLI: widget.isSLI,
        header: 'Pengesahan',
        content: Text(
          'Adakah Anda Pasti $keyword Temapahan?',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colours.darkGrey, fontSize: FontSizes.normal),
        ),
        buttonText: 'Pasti',
        onClick: () {
          Navigator.pop(context);
          onClick();
        });
  }

  Widget cancelBookingButton() {
    return UserButton(
        text: 'Batal Tempahan',
        padding: EdgeInsets.symmetric(horizontal: Dimensions.d_35),
        color: Colours.cancel,
        onClick: () async {
          confirmationModal(
              keyword: 'Batalkan',
              onClick: () async {
                showLoadingAnimation(context: context);
                await BookingServices().cancelBooking(headerToken: authToken,
                    bookingID: transaction.bookingId);
                Navigator.pop(context);
                widget.onCancelClick();
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return transaction == null
        ? Container()
        : SafeArea(
          child: Scaffold(
              backgroundColor: Colours.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back
                  ),
                  onPressed: () {
                    widget.onCancelClick();
                  },
                ),
                title: Text(
                  'Mengurus Tempahan',
                  style: GoogleFonts.lato(
                    fontSize: FontSizes.mainTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: widget.isSLI ? Colours.orange : Colours.blue,
              ),
              body: ListView(
                children: [
                  Padding(
                      padding: Paddings.horizontal_20,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: Dimensions.d_35),
                          SizedBox(
                            height: Dimensions.d_100,
                            child: Image(
                                image: this.widget.profilePic ??
                                    AssetImage('images/avatar.png')),
                          ),
                          SizedBox(height: Dimensions.d_15),
                          Text(
                              "${widget.isSLI ? transaction.userName : transaction.sliName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.d_25)),
                          SizedBox(height: Dimensions.d_35),
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
              bottomNavigationBar: widget.isSLI
                  ? SizedBox.shrink()
                  : (transaction.status == 'accepted') ? Container(
                    height: Dimensions.d_100 * 1.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        cancelBookingButton(),
                        UserButton(
                            text: 'Tamat Tempahan',
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.d_35, vertical: Dimensions.d_25),
                            color: Colours.cancel,
                            onClick: () async {
                              confirmationModal(
                                  keyword: 'Tamatkan',
                                  onClick: () async {
                                    showLoadingAnimation(context: context);
                                    await BookingServices().finishBooking(headerToken: authToken,
                                        bookingID: transaction.bookingId);
                                    Navigator.pop(context);
                                    widget.onCancelClick();
                                  });
                            }),
                      ],
                    ),
                  ) : Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.d_25),
                    child: cancelBookingButton(),
                  ),
            ),
        );
  }

  void onTapMessage() {
    debugPrint("Message is tapped");
  }

  void onTapVideo() {
    debugPrint("Video is tapped");
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heard/api/on_demand_request.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/home/on_demand/on_demand_success.dart';
import 'package:heard/http_services/on_demand_services.dart';
import 'package:heard/widgets/slidable_list_tile.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OnDemandSLIPage extends StatefulWidget {
  @override
  _OnDemandSLIPageState createState() => _OnDemandSLIPageState();
}

class _OnDemandSLIPageState extends State<OnDemandSLIPage> with AutomaticKeepAliveClientMixin{
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<OnDemandRequest> onDemandRequests;
  String authToken;
  bool pairingComplete = false;

  List<UserInfoTemp> mockInfoList = [
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Sg Buloh',
        department: 'Jabatan Jantung',
        messageToSLI: 'Jangan pakai baju warna merah jambu asdasdasdasdada asdasdsad sdadasdasdasdasdasdas asdasdsaasas asdasdasdsadasdasd asdsadasdas',
        isEmergency: true),
    UserInfoTemp().addInfo(
        name: 'Kyle Jenner',
        hospital: 'Hospital Sg Long',
        department: 'Jabatan Tangan',
        isEmergency: true),
    UserInfoTemp().addInfo(
        name: 'Kim Possible',
        hospital: 'Hospital Sarawak',
        department: 'Jabatan Rambut',
        messageToSLI: 'Jangan pakai baju warna merah'),
    UserInfoTemp().addInfo(
        name: 'Arthur Knight',
        hospital: 'Hospital Kuala Lumpur',
        department: 'Jabatan Telinga'),
    UserInfoTemp().addInfo(
        name: 'John Monash',
        hospital: 'Hospital Selangor',
        department: 'Jabatan Muka'),
    UserInfoTemp().addInfo(
        name: 'Michael Lee',
        hospital: 'Hospital Pahang',
        department: 'Jabatan Mata'),
    UserInfoTemp().addInfo(
        name: 'Takashi Hiro',
        hospital: 'Hospital Sabah',
        department: 'Jabatan Kaki'),
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Pulau Pinang',
        department: 'Jabatan Mulut'),
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Seremban',
        department: 'Jabatan Arteri'),
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Shah Alam',
        department: 'Jabatan Badan'),
  ];

  void _onRefresh() async{
    List<OnDemandRequest> allRequests = await OnDemandServices().getAllRequests(headerToken: authToken);
    setState(() {
      onDemandRequests = allRequests;
    });
    print('Refreshed all on-demand requests ...');
    print('Updated Request: $onDemandRequests and length of ${onDemandRequests.length}');
    if (onDemandRequests == null) {
      _refreshController.refreshFailed();
    }
    else {
      _refreshController.refreshCompleted();
    }
  }

  void getOnDemandRequests() async {
    authToken = await AuthService.getToken();
    List<OnDemandRequest> allRequests = await OnDemandServices().getAllRequests(headerToken: authToken);
    onDemandRequests = allRequests;

    print('Got all on-demand requests ...');
    print('Request: $onDemandRequests and length of ${onDemandRequests.length}');
  }

  void confirmRequest() {
    popUpDialog(
        context: context,
        isSLI: true,
        header: 'Pengesahan',
        content: Text(
          'Adakah anda pasti?',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colours.darkGrey,
              fontSize: FontSizes.normal),
        ),
        buttonText: 'Teruskan',
        onClick: () {
          Navigator.pop(context);
          setState(() {
            pairingComplete = true;
          });
        });
  }

  void showUserInformation({int index}) {
    popUpDialog(
      context: context,
      isSLI: true,
      height: Dimensions.d_130 * 3.5,
      contentFlexValue: 3,
      onClick: () {
        Navigator.pop(context);
      },
      header: 'Maklumat',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: ListTile(
              isThreeLine: true,
              leading: Icon(
                Icons.account_circle,
                size: Dimensions.d_55,
              ),
              title: Text(
                '${mockInfoList[index].userName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${mockInfoList[index].hospital}',
                    style: TextStyle(color: Colours.darkGrey),
                  ),
                  Text(
                    '(${mockInfoList[index].department})',
                    style: TextStyle(color: Colours.darkGrey),
                  ),
                  mockInfoList[index].isEmergency
                      ? Text(
                    '*Kecemasan',
                    style: TextStyle(color: Colours.fail),
                  )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding:
              EdgeInsets.only(top: Dimensions.d_35),
              child: Container(
                  height: Dimensions.d_280,
                  decoration: BoxDecoration(
                      color: Colours.lightGrey,
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.d_10))),
                  child: ListTile(
                    title: Text(mockInfoList[index].messageToSLI, style: TextStyle(fontSize: FontSizes.smallerText),),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (onDemandRequests == null && authToken == null) {
      getOnDemandRequests();
    }
    return pairingComplete
        ? OnDemandSuccessPage(
            isSLI: true,
            onCancelClick: () {
              setState(() {
                pairingComplete = false;
              });
            },
          )
        : Scaffold(
            backgroundColor: Colours.white,
            body: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              enablePullDown: true,
              header: WaterDropHeader(),
              child: (onDemandRequests == null) ? Center(child: Text('Tiada Permintaan Pada Masa Ini'),) : ListView(
                children: <Widget>[
                  GreyTitleBar(
                    title: 'Permintaan Aktif',
                    trailing: Text(
                      '*Leret ke kiri untuk pengesahan',
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
                      return SlidableListTile(
                        userInfo: mockInfoList[index],
                        title: Text('${mockInfoList[index].userName}', style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${mockInfoList[index].hospital}', style: TextStyle(color: Colours.darkGrey),),
                            mockInfoList[index].isEmergency ? Text('KECEMASAN', style: TextStyle(color: Colours.fail, fontSize: FontSizes.biggerText),) : SizedBox.shrink(),
                          ],
                        ),
                        slideActionFunctions: [
                          IconSlideAction(
                          caption: 'Terima',
                          color: Colours.accept,
                          icon: Icons.done,
                          onTap: () {
                            confirmRequest();
                          })
                        ],
                        onTrailingButtonPress: IconButton(
                          icon: Icon(Icons.info_outline),
                          color: Colours.orange,
                          iconSize: Dimensions.d_30,
                          onPressed: () {
                            showUserInformation(index: index);
                          },
                        ),
                      );
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
  String userName;
  String hospital;
  String department;
  String messageToSLI;
  bool isEmergency;

  UserInfoTemp addInfo(
      {@required String name,
      @required String hospital,
      @required String department,
      String messageToSLI = '',
      bool isEmergency = false}) {
    UserInfoTemp newPerson = UserInfoTemp();
    newPerson.userName = name;
    newPerson.hospital = hospital;
    newPerson.department = department;
    newPerson.messageToSLI = messageToSLI;
    newPerson.isEmergency = isEmergency;

    return newPerson;
  }
}

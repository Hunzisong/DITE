import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/on_demand/on_demand_user_loading_page.dart';
import 'package:heard/home/on_demand/on_demand_success.dart';
import 'package:heard/widgets/widgets.dart';

class OnDemandUserPage extends StatefulWidget {
  @override
  _OnDemandUserPageState createState() => _OnDemandUserPageState();
}

class _OnDemandUserPageState extends State<OnDemandUserPage> {
  bool loadingScreen = false;
  bool pairingComplete = false;

  @override
  Widget build(BuildContext context) {
    return loadingScreen
        ? OnDemandUserLoadingPage(
            onCancelClick: () {
              setState(() {
                loadingScreen = false;
              });
            },
            onSearchComplete: () {
              setState(() {
                loadingScreen = false;
                pairingComplete = true;
              });
            },
          )
        : pairingComplete

            /// TODO: Replace Container with finished page afterwards
            ?
            OnDemandSuccessPage()
            : Scaffold(
                backgroundColor: Colours.white,
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: Paddings.startupMain,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: Dimensions.d_280,
                            child: Image(
                              image: AssetImage('images/onDemand.png'),
                            ),
                          ),
                          SizedBox(height: Dimensions.d_30),
                          ListTile(
                            contentPadding: EdgeInsets.all(Dimensions.d_0),
                            title: Text('Servis permintaan segera:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontSizes.normal)),
                            subtitle: Text(
                              'Cari JBIM dan mulakan video call sekarang.',
                              style: TextStyle(
                                  fontSize: FontSizes.normal,
                                  color: Colours.darkGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: UserButton(
                  text: 'Carian',
                  padding: EdgeInsets.all(Dimensions.d_30),
                  color: Colours.blue,
                  onClick: () {
                    setState(() {
                      loadingScreen = true;
                    });
                  },
                ),
              );
  }
}

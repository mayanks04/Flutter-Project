import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SI Calculator',
    home: SIForm(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.purple,
      accentColor: Colors.purple,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
    throw UnimplementedError();
  }
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final _minimumPadding = 10.0;
  var _currentItemSelected = ' ';

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalControlled = TextEditingController();
  TextEditingController roiControlled = TextEditingController();
  TextEditingController termControlled = TextEditingController();
  var displayResult = ' ';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('SI Calculator'),
      ),
      body: Form(
        key: _formKey,
        // margin:,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding),
          child: ListView(
            children: <Widget>[
              getImageAsset(),
              Container(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding * 1 / 2,
                    bottom: _minimumPadding * 1 / 2),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: principalControlled,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter principal amount';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Principal',
                    hintText: 'Enter Principle e.g. 45000',
                    labelStyle: textStyle,
                    errorStyle: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 1 / 2,
                      bottom: _minimumPadding * 1 / 2),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: roiControlled,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter rate of Interest';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Rate of Interest',
                      hintText: 'Enter Rate of Interest in %',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(_minimumPadding * 1 / 2),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: termControlled,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter time in year';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Time',
                        hintText: 'Time in Year',
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0,
                        ),
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    )),
                    Container(
                      width: _minimumPadding * 2.5,
                    ),
                    Expanded(
                        child: DropdownButton(
                            items: _currencies.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            value: _currentItemSelected,
                            onChanged: (String newValueSelected) {
                              _onDropDownSelected(newValueSelected);
                            })),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(_minimumPadding * 0.5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Calculate',
                              textScaleFactor: 1.0,
                            ),
                            onPressed: () {
                              setState(() {
                                if(_formKey.currentState.validate()){
                                  this.displayResult = _calculateTotalReturn();
                                }

                              });
                            })),
                    Container(width: 1.5),
                    Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text('Reset', textScaleFactor: 1.0),
                            onPressed: () {
                              _reset();
                            }))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(_minimumPadding),
                child: Text(
                  displayResult,
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 180.0,
      height: 180.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.only(
          top: _minimumPadding * 5,
          right: _minimumPadding * 12,
          left: _minimumPadding * 12),
    );
  }

  void _onDropDownSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturn() {
    double principal = double.parse(principalControlled.text);
    double roi = double.parse(roiControlled.text);
    double term = double.parse(termControlled.text);

    double totalAmountPayable = principal + ((principal * roi * term) / 100);
    String result =
        'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';
    return result;
  }

  void _reset() {
    principalControlled.text = ' ';
    roiControlled.text = ' ';
    termControlled.text = ' ';
    displayResult = ' ';
    _currentItemSelected = _currencies[0];
  }
}

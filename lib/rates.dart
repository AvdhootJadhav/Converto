import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Rates extends StatefulWidget {
  @override
  _RatesState createState() => _RatesState();
}

class _RatesState extends State<Rates> {
  bool num1 = false;
  bool from = false;
  bool end = false;
  double rate;
  double factor=0;
  TextEditingController controller = TextEditingController();
  String dropvalue, tovalue;
  final key = GlobalKey<ScaffoldState>();
  final list = ["INR","USD","EUR","JPY","BGN","CZK","DKK","GBP",
  "HUF","PLN","SEK","CHF","AUD","BRL","CAD","CNY","RUB","HKD","NOK",
  "ILS","KRW","NZD","PHP","ZAR","THB","SGD","RON","HRK","ISK","IDR","TRY",
  "MXN"
  ];

  getrate() async{
    final response = await http.get("https://api.exchangeratesapi.io/latest?base=$dropvalue");
    if(response.statusCode==200){
    Map<String,dynamic> jsonrate = jsonDecode(response.body);
    factor=jsonrate["rates"][tovalue];
    rate=factor*(double.parse(controller.text));
    print(rate);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("$rate $tovalue"),
      action: SnackBarAction(
        label: "OK", 
        onPressed: Scaffold.of(context).hideCurrentSnackBar,
      )));
    return rate;
    }
    else{
      throw Exception();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Material(
        color: Colors.white,
        child:Column(
            children: <Widget>[
              SizedBox(height: 10),
              Image.asset("assets/images/undraw_wallet_aym5.png", fit: BoxFit.cover,),
              Text("Welcome", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
              SizedBox(height:10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Amount",
                      labelText: "Enter currency Amount",
                    ),
                    onChanged: (value){
                      setState(() {
                        num1=true;
                        
                      });
                    },
                  ),
                  SizedBox(height:10),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: dropvalue,
                    hint: Text("From"),
                    items: list.map((String value){
                      return new DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        dropvalue=value;
                        from = true;
                      });
                    },
                  ),
                  SizedBox(height:10),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: tovalue,
                    hint: Text("To"),
                    items: list.map((String value){
                      return new DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        tovalue=value;
                        end = true;
                        //For without button functionality:
                        // if(num1==true || from==true || end==true){
                        //   getrate();
                        //   num1=false;
                        //   from=false;
                        //   end=true;
                        // }
                        // else{
                        //   Scaffold.of(context).showSnackBar(SnackBar(
                        //   content: Text("Enter missing fields"),
                        //   action: SnackBarAction(label: "OK", onPressed: Scaffold.of(context).hideCurrentSnackBar),
                        //   ));  
                        // }
                      });
                    },
                  ),
                  SizedBox(height:10),
                  RaisedButton(
                    child: Text("Convert", style: TextStyle(color: Colors.white),),
                    onPressed: () async{
                      if(num1==true && from==true && end==true){
                      getrate();
                      }
                      else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Enter missing fields"),
                          action: SnackBarAction(label: "OK", onPressed: Scaffold.of(context).hideCurrentSnackBar),
                          ));
                      }
                    },
                    color: Colors.purple[800],
                    )
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
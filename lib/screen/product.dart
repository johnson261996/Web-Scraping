import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final String title;
  final String url;
  final String image;
  final String subtitle;

   ProductScreen({Key? key, required  this.title,required  this.subtitle,required  this.image,required this.url}) : super(key: key);
   double kDefaultPadding = 20.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppbar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(tag: '${1}',child: Image.network(image,fit: BoxFit.scaleDown,height:  MediaQuery.of(context).size.height * 0.5,)),
          SizedBox(height: kDefaultPadding),
          Text(
            title,
            style:Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
          ),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Price\n'),
                    TextSpan(text: '\$${100}',style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.black , fontWeight: FontWeight.bold)),
                  ],
                ),
              ),


            ],
          ),

          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, //specify the button's disabled text, icon, and fill color
                  shadowColor: Colors.black, //specify the button's elevation color
                  elevation: 4.0, //buttons Material shadow
                  textStyle: TextStyle(fontFamily: 'roboto'), //specify the button's text TextStyle
                   minimumSize:Size( MediaQuery.of(context).size.width * 0.5,  MediaQuery.of(context).size.height * 0.05,),
                ),
                child: Text("Add to Cart"),
              ),
              ElevatedButton(
                onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(url)))
                           await launchUrl(Uri.parse(url));
                      else
                    throw "Could not launch $url";
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,//specify the button's disabled text, icon, and fill color
                  shadowColor: Colors.black, //specify the button's elevation color
                  elevation: 4.0, //buttons Material shadow
                  textStyle: TextStyle(fontFamily: 'roboto'), //specify the button's text TextStyle
                  minimumSize:Size( MediaQuery.of(context).size.width * 0.5,  MediaQuery.of(context).size.height * 0.05,),
                ),
                child: Text("Buy"),)
            ],
          ),

        ],
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
            icon:   Icon(
              Icons.arrow_back,
              size: 25,
              color: Colors.white,
            ),
        ),
    );
  }
}

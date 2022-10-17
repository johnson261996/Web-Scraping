import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/Article.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flipkart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _getWebsiteData();
  }

  void _getWebsiteData() async{
    final url = Uri.parse("https://www.flipkart.com/search?q=android");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html.querySelectorAll(' div > a > div._3pLy-c.row > div.col.col-7-12 > div._4rR01T').
    map((e) => e.innerHtml.trim()).toList();
    
    final desc = html.querySelectorAll(" div > a > div._3pLy-c.row > div.col.col-7-12 > div.fMghEO").
    map((e) => e.innerHtml.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim()).toList();

    final img = html.querySelectorAll("  div > a > div.MIXNux > div._2QcLo- > div > div > img").
    map((e) => e.attributes['src']!).toList();
    final link =  html.querySelectorAll('  div > div > div > a').
    map((e) => 'https://www.flipkart.com${e.attributes['href']}').toList();
    print("count title: ${titles.length}");
    print("count description: ${desc.length}");
    for(final title in titles){
      debugPrint(title);
    }
    for(final pDesc in desc){
      debugPrint(pDesc);
    }
    setState(() {
      articles = List.generate(titles.length, (index) =>
          Article(title: titles[index], url: link[index], urlimage: img[index],desc: desc[index]));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
         ListView.builder(
            scrollDirection: Axis.vertical,
             physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: articles.length,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      ListTile(
                        title: Text(article.title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                        subtitle:Text(article.desc,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 12)),
                       leading:Image.network(article.urlimage,fit: BoxFit.fill),
                        onTap: () async {
                          final url = article.url;
                          if (await canLaunchUrl(Uri.parse(url)))
                           await launchUrl(Uri.parse(url));
                          else
                            throw "Could not launch $url";
                        },
                      ),
                    //Text(article.url, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                    ]

                  ));
            })
            ],
        ),
      ),

    );
  }
}

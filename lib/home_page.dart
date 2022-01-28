import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List imageList = [];
  List restaurantList = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), getRequest);
  }

  List<Widget> getImageList() {
    List<Widget> widgetList = [];
    for(int i=0; i<imageList.length; i++) {
      widgetList.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Image.network(
              "${imageList[i]}",
              fit: BoxFit.fill,
            ),
          )
      );
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Task 1"),
        elevation: 0.0,
      ),
      body: imageList.length > 0
          ? SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.blue,
              child: CarouselSlider(
                items: getImageList(),
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: false,
                  autoPlay: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  viewportFraction: 0.7,
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                var imageData = restaurantList[index]['Num'] == "http://saloon.myurbangrocery.com/Admin/image/"
                                || restaurantList[index]['Num'] == "http://saloon.myurbangrocery.com/Admin/image/noimg.jpg"
                                ? "http://saloon.myurbangrocery.com/Admin/image/download.jfif"
                                : restaurantList[index]['Num'];
                return Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(32)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        '$imageData',
                        fit: BoxFit.fill,
                        height: 220,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Text(
                          '${restaurantList[index]['Type']}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  )
                );
              },
            ),
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
          strokeWidth: 5,

        ),
      ),
    );
  }

  Future getRequest() async {
    String url = "http://saloonapi.vfastdelivery.in/Api/Rebliss/GetMarkAttendanceUserInfo/0";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = json.decode(response.body);

//      print(result['Designation']);
      var imageArr = result['Designation'].split(",");
      setState(() {
        for(int i=0; i<imageArr.length; i++) {
          imageList.add(imageArr[i]);
        }
      });
      getPostRequest();
    } else {
      return null;
    }
  }

  Future getPostRequest() async {
    String url = "http://saloonapi.vfastdelivery.in/Api/Rebliss/ResturantName";
    var requestParameter = {
      "Number": "1"
    };
    var response = await http.post(Uri.parse(url), body: requestParameter);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      setState(() {
        restaurantList = result['Result'];
      });
      print(response.body);
    } else {
      return null;
    }
  }
}

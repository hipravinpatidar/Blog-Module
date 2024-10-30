import 'dart:math';
import 'package:blogstask/apiservice/apiservice.dart';
import 'package:blogstask/frontpage.dart';
import 'package:blogstask/model/blog_details_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'Controller/Bookmark Provider.dart';
import 'Controller/ShareScreen.dart';
import 'Controller/language_provider.dart';
import 'SQLite Helper Class/database_helper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'model/SubCategory_model.dart';

class DetailsPage extends StatefulWidget {
  final title;
  final List<SubCategoryData> remainingItems;

  final String imageTop;

  DetailsPage({
    super.key,
    required this.remainingItems,
    required this.title, required this.imageTop,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _currentIndex = 0;
  bool _isBlackBackground = false;
  double _textScaleFactor = 12;

  List<Color> _itemColors = [];

  bool _isLoading = false;

  final double _scaleIncrement = 0.1;
  bool _isAutoScrolling = false;
  double _scrollSpeed = 5.0; // Set a reasonable default speed
  late Timer _scrollTimer;
  ScrollController _scrollController = ScrollController();

  double _textSizeLevel = 16.0 ;

  int initialShowItems = 10; // Limit to 10 items initially

  final DatabaseHelper dbHelper =
      DatabaseHelper(); // Create a new instance directly
  List<int> bookmarkedIds = [];
  final shareMusic = ShareMusic();

  @override
  void initState() {
    super.initState();
    getDetails();
    _generateRandomColors();
  }


  void _generateRandomColors() {
    // Assuming yourDataList is the data for ListView
    for (int i = 0; i < widget.remainingItems.length; i++) {
      _itemColors.add(_getRandomColor());
    }
  }

  // Function to generate a random color
  Color _getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  void dispose() {
    _scrollTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

 // Method to share content
  void _shareContent() {
    String contentToShare = "";
    Share.share(contentToShare, subject: 'Check out this blog!');
  }

 // Method to show a SnackBar and copy content to clipboard
  void _showCopyMessage() {
    String parsedText = "";
        //html_parser.parse(widget.content).body?.text ?? '';
    Clipboard.setData(
        ClipboardData(text: parsedText)); // Copy parsed text to clipboard

    final snackBar = SnackBar(
      content: Text('Content copied!'),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _toggleAutoScroll() {
    setState(() {
      _isAutoScrolling = !_isAutoScrolling;

      if (_isAutoScrolling) {
        _scrollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
          if (_scrollController.position.pixels <
              _scrollController.position.maxScrollExtent) {
            _scrollController.animateTo(
              _scrollController.position.pixels + _scrollSpeed,
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            );
          } else {
            _scrollController.jumpTo(0);
          }
        });
      } else {
        _scrollTimer.cancel();
      }
    });
  }

  void _onBottomNavTap(int index) {
    if (index != 5) {
      if (_isAutoScrolling) {
        _toggleAutoScroll();
      }
    }

    setState(() {
      _currentIndex = index;

         if (index == 0) {
         _isBlackBackground = !_isBlackBackground;
        }

        else if (index == 1) {
         _increaseTextSize();
        }
        else if (index == 2) {
          _decreaseTextSize();
        }
        else if (index == 3) {
          _shareContent();
        }
        else if (index == 4) {
          _showCopyMessage();
        }
        else if (index == 5) {
          _toggleAutoScroll();
        }

    });
   }

  void _increaseTextSize() {
    setState(() {
      _textSizeLevel ++;

      print(_textSizeLevel);
      // Increase text size by 2
    });
  }


  void _decreaseTextSize() {
    setState(() {
      _textSizeLevel --; // Increase text size by 2
    });
  }


  int _showMoreItems = 10;

  BlogDetails? subCategoryDataDetils;

  Future<void>getDetails() async{

    setState(() {
      _isLoading = true;
    });

    try{

      print(" My titile is ${widget.title}");

      final Map<String, dynamic>? res = await ApiService().getCategory("https://mahakal.rizrv.in/api/v1/blog/get-blog-detail/${widget.title}");
      print(res);

      if(res!.containsKey("status") &&  res.containsKey('data') && res['data'] != null){

        final blogDetails = BlogDetails.fromJson(res);
        subCategoryDataDetils = blogDetails;

        print(blogDetails.data.title);
      }

    } catch(e){
      print("Error blog details $e");
    } finally{
      setState(() {
        _isLoading = false;
      });
    }

  }

  // Future<void> _saveBookmark(SubCategoryData data) async {
  //   try {
  //     Map<String, dynamic> bookmark = {
  //       'title': data.title ?? 'Untitled', // Ensure title is not null
  //       'image': data.imageBig ?? '', // Ensure image is not null
  //     };
  //
  //     // Check if the item is already bookmarked
  //     if (bookmarkedIds.contains(data.id)) {
  //       // If it is, remove the bookmark
  //       await dbHelper.deleteBookmark(data.title);
  //       setState(() {
  //         bookmarkedIds.remove(data.id); // Update local state
  //       });
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Bookmark removed!')));
  //     } else {
  //       // If it isn't, save the bookmark
  //       await dbHelper.insertBookmark(bookmark);
  //       setState(() {
  //         bookmarkedIds.add(data.id); // Update local state
  //       });
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Bookmark saved!')));
  //     }
  //   } catch (e) {
  //     print("Error saving/removing bookmark: $e");
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Failed to update bookmark')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child:
      _isLoading ? Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator())) :
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: _isBlackBackground ? Colors.black : Colors.white,
          title: Text(
            "Blogs",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.orange,
              fontSize: screenWidth * 0.06,
              fontFamily: 'Roboto',
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
             // Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Frontpage(),));
            },
            child: Icon(Icons.arrow_back, color:_isBlackBackground ? Colors.white : Colors.black, size: 25),
          ),
        ),
        backgroundColor: _isBlackBackground ? Colors.black : Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Consumer<LanguageProvider>(
              builder: (BuildContext context, languageProvider, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(image: NetworkImage(widget.imageTop ?? ''),fit: BoxFit.cover)
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              color:
                                  _isBlackBackground ? Colors.white : Colors.black),
                          SizedBox(width: screenWidth * 0.01),
                          SizedBox(width: screenWidth * 0.3,
                            child: Text("${subCategoryDataDetils!.data.createdAt}",
                              style: TextStyle(
                                color:
                                    _isBlackBackground ? Colors.white : Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.remove_red_eye_outlined,
                              color:
                                  _isBlackBackground ? Colors.white : Colors.black),
                          SizedBox(width: screenWidth * 0.01),
                          Text("${subCategoryDataDetils!.data.hit}",
                            style: TextStyle(
                                color: _isBlackBackground
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(subCategoryDataDetils!.data.title,style: TextStyle(fontSize: screenWidth * 0.05,fontWeight: FontWeight.bold,color: _isBlackBackground ? Colors.white : Colors.black),),
                    ),

                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Html(data: subCategoryDataDetils!.data.content,
                              style: {
                              "body": Style(
                                color:  _isBlackBackground ? Colors.white : Colors.black,
                                fontSize: FontSize(_textSizeLevel),
                                alignment: Alignment.topCenter

                              ),
                              },)
                        ],
                      ),

                    widget.remainingItems.isEmpty ? Container() :

                    Column(
                      children: [


                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          child: Consumer<LanguageProvider>(
                            builder: (BuildContext context, languageProvider, Widget? child) {
                              return Row(
                                children: [
                                  Container(
                                    height: screenHeight * 0.03,
                                    width: screenWidth * 0.01,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 90, 0, 1)),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Text(
                                    languageProvider.isEnglish ? "Popular Post" : "लोकप्रिय पोस्ट",
                                    style: TextStyle(
                                        color:  _isBlackBackground ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenWidth * 0.04),
                                  ),
                                  Spacer(),
                                  // GestureDetector(
                                  //
                                  //   onTap: () {
                                  //     //final subCategoryItem = subCategoryList;
                                  //
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) => ViewallScreen(
                                  //             subCategoryData: widget.remainingItems,
                                  //           ),
                                  //         ));
                                  //   },
                                  //   child: Text(
                                  //     languageProvider.isEnglish ? "View All" : "सभी को देखें",
                                  //     style: TextStyle(
                                  //         color: Color.fromRGBO(255, 139, 33, 1),
                                  //         fontWeight: FontWeight.bold
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight * 0.20, // Height for ListView
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.remainingItems.length > 10 ? 10 : widget.remainingItems.length,
                                itemBuilder: (context, index) {

                                  final subCategoryItem = widget.remainingItems[index];
                                  final isBookmarked = bookmarkedIds.contains(subCategoryItem.id); // Check if item is bookmarked

                                  final randomColor1 = _itemColors[index]; // Color for preceding words
                                  final randomColor2 = _getRandomColor();

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsPage(
                                            remainingItems: widget.remainingItems, title: subCategoryItem.titleSlug, imageTop: subCategoryItem.imageBig ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3), // Adjusted padding
                                      child: Container(
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromRGBO(231, 231, 231, 1)), // Black border
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenWidth * 0.03),
                                              child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [


                                                    SizedBox(
                                                      width: screenWidth * 0.4,
                                                      child: RichText(
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 3,
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                            fontSize: screenWidth * 0.036,
                                                            color: _isBlackBackground ? Colors.white : Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: subCategoryItem.title?.split(' ').take(subCategoryItem.title!.split(' ').length - 2).join(' ') ?? '',
                                                              style: TextStyle(
                                                                  color: randomColor1
                                                                // color:  _isBlackBackground ? Colors.blue : Colors.red, // Color for the preceding words
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' ${subCategoryItem.title?.split(' ').last} ${subCategoryItem.title?.split(' ')[subCategoryItem.title!.split(' ').length - 2]}',
                                                              style: TextStyle(
                                                                  color: _isBlackBackground ? Colors.white : Colors.black // Change to your desired color
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),


                                                    // SizedBox(
                                                    //   width: screenWidth * 0.4,
                                                    //   child: Text(
                                                    //        subCategoryItem.title ?? '',
                                                    //        overflow: TextOverflow
                                                    //            .ellipsis, // Add this line
                                                    //        maxLines: 3, // Add this line
                                                    //        style: TextStyle(
                                                    //          fontSize: screenWidth * 0.04,
                                                    //          color:  _isBlackBackground ? Colors.white : Colors.black,
                                                    //          fontWeight: FontWeight.bold,
                                                    //        ),
                                                    //      ),
                                                    // ),

                                                    Spacer(),

                                                    Container(
                                                      height: screenWidth * 0.2,
                                                      width: screenWidth * 0.4,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          image: DecorationImage(image: NetworkImage(subCategoryItem.imageBig ?? ''),fit: BoxFit.cover)
                                                      ),
                                                    )
                                                  ]
                                              ),
                                            ),

                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: screenWidth * 0.02),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time_outlined,
                                                      color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                      size: screenWidth * 0.04,
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.01,
                                                    ),
                                                    Text("12/01/2002",
                                                      // DateFormat.yMMMd().format(DateTime.parse(subCategoryItem.createdAt.toString())),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: screenWidth * 0.03,
                                                      ),
                                                    ),
                                                    // Spacer(),
                                                    SizedBox(width: screenWidth * 0.01,),

                                                    Icon(Icons.new_releases_outlined,size: screenWidth * 0.04,color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),),

                                                    SizedBox(
                                                      width: screenWidth * 0.01,
                                                    ),
                                                    Text(
                                                      '120',
                                                      style: TextStyle(
                                                        color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: screenWidth * 0.03,
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: screenWidth * 0.01,
                                                    ),

                                                    Icon(Icons.remove_red_eye_outlined,size: screenWidth * 0.04,
                                                      color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                    ),

                                                    SizedBox(
                                                      width: screenWidth * 0.01,
                                                    ),
                                                    Text(
                                                      "${subCategoryItem.hit}",
                                                      style: TextStyle(
                                                        color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: screenWidth * 0.03,
                                                      ),
                                                    ),

                                                    Spacer(),

                                                    Consumer<BookmarkProvider>(
                                                      builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                                        final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == widget.remainingItems[index].title);

                                                        return GestureDetector(
                                                          onTap: () {
                                                            bookmarkProvider.toggleBookmark(widget.remainingItems[index]);
                                                          },
                                                          child: Consumer<LanguageProvider>(
                                                            builder: (BuildContext context, languageProvider, Widget? child) {
                                                              return Row(
                                                                children: [
                                                                  Icon(
                                                                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                                    size: screenWidth * 0.07,
                                                                    color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),

                                                                  ),
                                                                  Text(languageProvider.isEnglish ? "Save" : "सेव",style: TextStyle(
                                                                    color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),

                                                                  ),)
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),

                                                    SizedBox(width: screenWidth * 0.02,),
                                                    IconButton(
                                                      color: Colors.transparent,
                                                      highlightColor:
                                                      Colors.transparent,
                                                      icon: Consumer<LanguageProvider>(
                                                        builder: (BuildContext context, languageProvider, Widget? child) {
                                                          return Row(
                                                            children: [
                                                              Icon(
                                                                Icons.share_outlined,
                                                                color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                              ),
                                                              Text(languageProvider.isEnglish ? "Share" : "शेयर",style: TextStyle(
                                                                color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                              ),)
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                      onPressed: () {
                                                        shareMusic.shareSong(
                                                            widget.remainingItems[index]);
                                                      },
                                                    ), //


                                                  ],
                                                )
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),


                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          child: Consumer<LanguageProvider>(
                            builder: (BuildContext context, languageProvider, Widget? child) {
                              return Row(
                                children: [
                                  Container(
                                    height: screenHeight * 0.03,
                                    width: screenWidth * 0.01,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 90, 0, 1)),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Text(
                                    languageProvider.isEnglish ? "Trending" : "ट्रेंडिंग",
                                    style: TextStyle(
                                        color:  _isBlackBackground ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenWidth * 0.04),
                                  ),
                                  Spacer(),
                                  // GestureDetector(
                                  //
                                  //   onTap: () {
                                  //     //final subCategoryItem = subCategoryList;
                                  //
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) => ViewallScreen(
                                  //             subCategoryData: widget.remainingItems,
                                  //           ),
                                  //         ));
                                  //   },
                                  //   child: Text(
                                  //     languageProvider.isEnglish ? "View All" : "सभी को देखें",
                                  //     style: TextStyle(
                                  //         color: Color.fromRGBO(255, 139, 33, 1),
                                  //         fontWeight: FontWeight.bold
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight * 0.20, // Height for ListView
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.remainingItems.length > 10 ? widget.remainingItems.length - 10 : 0,
                                // itemCount:  widget.remainingItems.skip(10).take(10).length,
                                itemBuilder: (context, index) {

                                  final subCategoryItem = widget.remainingItems[index + 10];
                                  final isBookmarked = bookmarkedIds.contains(subCategoryItem.id);

                                  final randomColor1 = _itemColors[index];
                                  final randomColor2 = _getRandomColor();

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsPage(
                                            remainingItems: widget.remainingItems, title: subCategoryItem.titleSlug, imageTop: subCategoryItem.imageBig ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3), // Adjusted padding
                                      child: Container(
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromRGBO(231, 231, 231, 1)), // Black border
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenWidth * 0.03),
                                              child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [


                                                    SizedBox(
                                                      width: screenWidth * 0.4,
                                                      child: RichText(
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 3,
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                            fontSize: screenWidth * 0.036,
                                                            color: _isBlackBackground ? Colors.white : Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: subCategoryItem.title?.split(' ').take(subCategoryItem.title!.split(' ').length - 2).join(' ') ?? '',
                                                              style: TextStyle(
                                                                  color: randomColor1
                                                                // color:  _isBlackBackground ? Colors.blue : Colors.red, // Color for the preceding words
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' ${subCategoryItem.title?.split(' ').last} ${subCategoryItem.title?.split(' ')[subCategoryItem.title!.split(' ').length - 2]}',
                                                              style: TextStyle(
                                                                  color: _isBlackBackground ? Colors.white : Colors.black // Change to your desired color
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    // SizedBox(
                                                    //   width: screenWidth * 0.4,
                                                    //   child: Text(
                                                    //     subCategoryItem.title ?? '',
                                                    //     overflow: TextOverflow
                                                    //         .ellipsis, // Add this line
                                                    //     maxLines: 3, // Add this line
                                                    //     style: TextStyle(
                                                    //       fontSize: screenWidth * 0.04,
                                                    //       color:  _isBlackBackground ? Colors.white : Colors.black87,
                                                    //       fontWeight: FontWeight.bold,
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                    Spacer(),

                                                    Container(
                                                      height: screenWidth * 0.2,
                                                      width: screenWidth * 0.4,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          image: DecorationImage(image: NetworkImage(subCategoryItem.imageBig ?? ''),fit: BoxFit.cover)
                                                      ),
                                                    )
                                                  ]
                                              ),
                                            ),

                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: screenWidth * 0.02),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time_outlined,
                                                      color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                      size: screenWidth * 0.04,
                                                    ),
                                                    SizedBox(width: screenWidth * 0.01,),
                                                    Text("12/01/2002",
                                                      // DateFormat.yMMMd().format(DateTime.parse(subCategoryItem.createdAt.toString())),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: screenWidth * 0.03,

                                                      ),
                                                    ),
                                                    // Spacer(),
                                                    SizedBox(width: screenWidth * 0.01,),

                                                    Icon(Icons.new_releases_outlined,size: screenWidth * 0.04,
                                                      color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                    ),

                                                    SizedBox(
                                                      width: screenWidth * 0.01,
                                                    ),
                                                    Text(
                                                      '120',
                                                      style: TextStyle(
                                                        color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: screenWidth * 0.03,
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: screenWidth * 0.01,
                                                    ),

                                                    Icon(Icons.remove_red_eye_outlined,size: screenWidth * 0.04,
                                                      color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                    ),

                                                    SizedBox(
                                                      width: screenWidth * 0.01,
                                                    ),
                                                    Text(
                                                      "${subCategoryItem.hit}",
                                                      style: TextStyle(
                                                        color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: screenWidth * 0.03,
                                                      ),
                                                    ),

                                                    Spacer(),

                                                    Consumer<BookmarkProvider>(
                                                      builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                                        final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == widget.remainingItems[index + 10].title);

                                                        return GestureDetector(
                                                          onTap: () {
                                                            bookmarkProvider.toggleBookmark(widget.remainingItems[index + 10]);
                                                          },
                                                          child: Consumer<LanguageProvider>(
                                                            builder: (BuildContext context, languageProvider, Widget? child) {
                                                              return Row(
                                                                children: [
                                                                  Icon(
                                                                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                                    size: screenWidth * 0.07,
                                                                    color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                                  ),
                                                                  Text(languageProvider.isEnglish ? "Save" : "सेव",style: TextStyle(
                                                                    color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),

                                                                  ),)
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),

                                                    SizedBox(width: screenWidth * 0.02,),
                                                    IconButton(
                                                      color: Colors.transparent,
                                                      highlightColor:
                                                      Colors.transparent,
                                                      icon: Consumer<LanguageProvider>(
                                                        builder: (BuildContext context, languageProvider, Widget? child) {
                                                          return Row(
                                                            children: [
                                                              Icon(
                                                                Icons.share_outlined,
                                                                color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                              ),
                                                              Text(languageProvider.isEnglish ? "Share" : "शेयर",style: TextStyle(
                                                                color:  _isBlackBackground ? Colors.white : Color.fromRGBO(128, 128, 128, 1),
                                                              ),)
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                      onPressed: () {
                                                        shareMusic.shareSong(
                                                            widget.remainingItems[index + 10]);
                                                      },
                                                    ), //


                                                  ],
                                                )
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02,),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentIndex == 5)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Text(
                      "Adjust Scroll Speed",
                      style: TextStyle(
                        color: _isBlackBackground ? Colors.white : Colors.black,
                      ),
                    ),
                    Slider(
                      value: _scrollSpeed,
                      min: 1.0,
                      max: 10.0, // Maximum speed set to a reasonable value
                      divisions: 9,
                      label: _scrollSpeed.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _scrollSpeed = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

            BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onBottomNavTap,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.sunny, color: Colors.black),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_increase_outlined, color: Colors.black),
                  label: 'Zoom In',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_decrease, color: Colors.black),
                  label: 'Zoom Out',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.share_outlined, color: Colors.black),
                  label: 'Share',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.save, color: Colors.black),
                  label: 'Copy',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.slideshow, color: Colors.black),
                  label: 'Slide',
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

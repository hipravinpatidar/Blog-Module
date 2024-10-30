import 'dart:math';
import 'package:blogstask/Controller/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/Bookmark Provider.dart';
import 'Detailspage.dart';
import 'model/SubCategory_model.dart';

class ViewallScreen extends StatefulWidget {

  List<SubCategoryData> subCategoryData;
   ViewallScreen({super.key,required this.subCategoryData});

  @override

  State<ViewallScreen> createState() => _ViewallScreenState();

}

class _ViewallScreenState extends State<ViewallScreen> {


  List<SubCategoryData> subData = [];


  @override
  void initState() {
    super.initState();
    subData = widget.subCategoryData as List<SubCategoryData>;
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
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black87, size: 25),
        ),
        title:
            Consumer<LanguageProvider>(
              builder: (BuildContext context, languageProvider, Widget? child) {
                return Text(
                  languageProvider.isEnglish ? "All Blogs" : "सभी ब्लॉग",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05,
                  ),
                );
              },
            ),
      ),

      body:

      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.90, // Height for ListView
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
               itemCount: subData.length,
               // itemCount: widget.remainingItems.length > 10 ? 10 : widget.remainingItems.length,
                itemBuilder: (context, index) {

                  final subCategoryItem = subData[index];
                 // final isBookmarked = bookmarkedIds.contains(subCategoryItem.id); // Check if item is bookmarked

                  final randomColor1 = _getRandomColor(); // Color for preceding words
                  final randomColor2 = _getRandomColor();

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            remainingItems: subData, title: subCategoryItem.titleSlug, imageTop: subData[index].imageBig ?? '',
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9,vertical: screenWidth * 0.01), // Adjusted padding
                      child: Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent
                              //color: Color.fromRGBO(231, 231, 231, 1)
                          ), // Black border
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenWidth * 0.02),
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
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: subCategoryItem.title?.split(' ').take(subCategoryItem.title!.split(' ').length - 1).join(' ') ?? '',
                                              style: TextStyle(
                                                  color: randomColor1
                                                // color:  _isBlackBackground ? Colors.blue : Colors.red, // Color for the preceding words
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ${subCategoryItem.title?.split(' ').last} ${subCategoryItem.title?.split(' ')[subCategoryItem.title!.split(' ').length - 1]}',
                                              style: TextStyle(
                                                  color: Colors.black // Change to your desired color
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
                                      color:  Color.fromRGBO(128, 128, 128, 1),
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
                                        color: Color.fromRGBO(128, 128, 128, 1),
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                    // Spacer(),
                                    SizedBox(width: screenWidth * 0.01,),

                                    Icon(Icons.new_releases_outlined,size: screenWidth * 0.04,color:  Color.fromRGBO(128, 128, 128, 1),),

                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),
                                    Text(
                                      '120',
                                      style: TextStyle(
                                        color: Color.fromRGBO(128, 128, 128, 1),
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),

                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),

                                    Icon(Icons.remove_red_eye_outlined,size: screenWidth * 0.04,
                                      color:  Color.fromRGBO(128, 128, 128, 1),
                                    ),

                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),
                                    Text(
                                      "${subCategoryItem.hit}",
                                      style: TextStyle(
                                        color:  Color.fromRGBO(128, 128, 128, 1),
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),

                                    Spacer(),

                                    Consumer<BookmarkProvider>(
                                      builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                        final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == subData[index].title);

                                        return GestureDetector(
                                          onTap: () {
                                            bookmarkProvider.toggleBookmark(subData[index]);
                                          },
                                          child: Consumer<LanguageProvider>(
                                            builder: (BuildContext context, languageProvider, Widget? child) {
                                              return Row(
                                                children: [
                                                  Icon(
                                                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                    size: screenWidth * 0.07,
                                                    color:  Color.fromRGBO(128, 128, 128, 1),

                                                  ),
                                                  Text(languageProvider.isEnglish ? "Save" : "सेव",style: TextStyle(
                                                    color:  Color.fromRGBO(128, 128, 128, 1),

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
                                                color: Color.fromRGBO(128, 128, 128, 1),
                                              ),
                                              Text(languageProvider.isEnglish ? "Share" : "शेयर",style: TextStyle(
                                                color:  Color.fromRGBO(128, 128, 128, 1),
                                              ),)
                                            ],
                                          );
                                        },
                                      ), onPressed: () {  },
                                      // onPressed: () {
                                      //   shareMusic.shareSong(
                                      //       widget.remainingItems[index]);
                                      // },
                                    ), //


                                  ],
                                )
                            ),

                            Divider()

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
      ),



      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      //   child: GridView.builder(
      //     padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 2,
      //       crossAxisSpacing: 10,
      //       mainAxisSpacing: 23,
      //       childAspectRatio: 0.75,
      //     ),
      //     itemCount: subData.length,
      //     itemBuilder: (context, index) {
      // return GestureDetector(
      //         onTap: () {
      //         },
      //         child: Container(
      //           decoration: BoxDecoration(
      //             border: Border.all(color: Color.fromRGBO(231, 231, 231, 1)),
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Container(
      //                 width: double.infinity,
      //                 height: screenHeight * 0.17,
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.only(
      //                     bottomLeft: Radius.circular(12),
      //                     bottomRight: Radius.circular(12),
      //                     topRight: Radius.circular(5),
      //                     topLeft: Radius.circular(5),
      //                   ),
      //                   child: Image.network(
      //                     "${subData[index].imageBig}", // Replace with your actual image URL
      //                     fit: BoxFit.cover,
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(height: screenHeight * 0.01),
      //               Padding(
      //                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      //                 child: Container(
      //                   width: double.infinity,
      //                   height: screenHeight * 0.03,
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(5),
      //                     color: Colors.orange.shade100,
      //                   ),
      //                   child: Center(
      //                     child: SizedBox(
      //                       width: screenWidth * 0.32,
      //                       child: Text(
      //                           "${widget.subCategoryData[index].title}",
      //                           // "${widget.subCategoryData[index].createdAt}",
      //                           style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,
      //                         ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(height: screenHeight * 0.01),
      //               Padding(
      //                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      //                 child: SizedBox(
      //                   width: screenWidth * 0.27,
      //                   child: Text(
      //                     "${widget.subCategoryData[index].createdAt}",
      //                     // (widget.subCategoryData[index].title),
      //                    // overflow: TextOverflow.ellipsis,
      //                     textAlign: TextAlign.start,
      //                     maxLines: 1,
      //                     style: TextStyle(
      //                       fontSize: screenWidth * 0.04,
      //                       fontWeight: FontWeight.w500,
      //                       color: Color.fromRGBO(
      //                           128, 128, 128, 1),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(height: screenHeight * 0.001),
      //              Padding(
      //                padding:  EdgeInsets.only(left: screenWidth * 0.02),
      //                child: Row(
      //                  children: [
      //                    Icon(Icons.remove_red_eye_outlined,  color: Color.fromRGBO(
      //                        128, 128, 128, 1),),
      //                    SizedBox(width: screenWidth * 0.01,),
      //                    Text("${subData[index].hit}",style: TextStyle(
      //                      color: Color.fromRGBO(
      //                          128, 128, 128, 1),
      //                    ),)
      //                  ],
      //                ),
      //              )
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),



    );
  }
}

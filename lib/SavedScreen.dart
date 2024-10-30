import 'dart:math';
import 'package:blogstask/frontpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/Bookmark Provider.dart';
import 'Controller/language_provider.dart';
import 'Detailspage.dart';
import 'SQLite Helper Class/database_helper.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {


  final dbHelper = DatabaseHelper(); // SQLite helper instance
//  List<Map<String, dynamic>> _bookmarkedItems = [];


  @override
  void initState() {
    super.initState();
   // _loadBookmarks(); // Load saved bookmarks from database
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


  //
  // Future<void> _loadBookmarks() async {
  //   try {
  //     final bookmarks = await dbHelper.getBookmarks(); // Fetch bookmarks from DB
  //     setState(() {
  //       _bookmarkedItems = bookmarks;
  //     });
  //   } catch (e) {
  //     print("Error loading bookmarks: $e"); // Print any errors
  //   }
  // }
  //
  // Future<void> _bookmarkItem(String title, String image) async {
  //   Map<String, dynamic> row = {
  //     'title': title,
  //     'image': image,
  //   };
  //   await dbHelper.insertBookmark(row); // Save the bookmark
  //   _loadBookmarks(); // Reload the bookmarks after adding a new one
  // }
  //
  // Future<void> _deleteBookmark(String title) async {
  //   try {
  //     await dbHelper.deleteBookmark(title); // Delete the bookmark from DB
  //     _loadBookmarks(); // Reload the bookmarks after deletion
  //   } catch (e) {
  //     print("Error deleting bookmark: $e"); // Print any errors
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<BookmarkProvider>(
      builder: (BuildContext context, bookmarkProvider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white,
            title: Text(
              "Saved",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                  fontSize: screenWidth * 0.06,
                  fontFamily: 'Roboto'),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.black87, size: 25),
            ),
          ),
          body:
          bookmarkProvider.bookMarkedShlokes.isEmpty ? Column(
            children: [

              SizedBox(height: screenWidth * 0.2,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05,),
                    child: Consumer<LanguageProvider>(
                      builder: (BuildContext context, languageProvider, Widget? child) {
                        return  Column(
                          children: [

                            SizedBox(height: screenWidth * 0.03,),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(image: NetworkImage("https://i2.pngimg.me/thumb/f/720/m2i8A0d3d3N4m2b1.jpg"))
                              ),
                            ),

                            SizedBox(height: screenWidth * 0.02,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.14),
                              child: Text(
                                languageProvider.isEnglish ? "You haven't liked any blogs yet!" : "आपने अभी तक कोई ब्लॉग पसंद नहीं किया है!",
                                textAlign: TextAlign.center,style: TextStyle(fontSize: screenWidth * 0.04,color: Colors.black,fontWeight: FontWeight.bold),),
                            ),

                            SizedBox(height: screenWidth * 0.05,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                              child: Text(
                                languageProvider.isEnglish ? "Please go to the blogs collection and list your favorite music!" : "कृपाया ब्लॉग संग्रह में जाए और अपने पसंदीदा ब्लॉग की सूची बनाएं!",
                                textAlign: TextAlign.center,style: TextStyle(fontSize: screenWidth * 0.04,color: Colors.black.withOpacity(0.5),),),
                            ),

                            SizedBox(height: screenWidth * 0.02,),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Frontpage()
                                    ,));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02,horizontal: screenWidth * 0.03),
                                    child: Consumer<LanguageProvider>(
                                      builder: (BuildContext context, languageProvider, Widget? child) {
                                        return Row(
                                          children: [

                                            const Icon(Icons.add_box_outlined,color: CupertinoColors.activeBlue,),
                                            SizedBox(width: screenWidth * 0.03,),
                                            Text(
                                            languageProvider.isEnglish ? "like Blog" : "ब्लॉग पसंद करे"
                                               // languageManager.selectedLanguage == 'English' ? "like Music" : "ब्लॉग पसंद करे"
                                                ,style: const TextStyle(fontWeight: FontWeight.bold,color: CupertinoColors.activeBlue))
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              )

            ],
          ) :

          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.90, // Height for ListView
                  child: Consumer<BookmarkProvider>(
                    builder: (BuildContext context, bookmarkProvider, Widget? child) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount:  bookmarkProvider.bookMarkedShlokes.length,
                        itemBuilder: (context, index) {

                          final subCategoryItem = bookmarkProvider.bookMarkedShlokes[index];
                          // final isBookmarked = bookmarkedIds.contains(subCategoryItem.id); // Check if item is bookmarked

                          final randomColor1 = _getRandomColor(); // Color for preceding words
                          final randomColor2 = _getRandomColor();

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    remainingItems: [], title: subCategoryItem.titleSlug, imageTop: bookmarkProvider.bookMarkedShlokes[index].imageBig ?? '',
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
                                    //  color: Color.fromRGBO(231, 231, 231, 1)
                                  ),
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
                                                      text: bookmarkProvider.bookMarkedShlokes[index].title ?.split(' ').take(bookmarkProvider.bookMarkedShlokes[index].title!.split(' ').length - 1).join(' ') ?? '',
                                                      style: TextStyle(
                                                          color: randomColor1
                                                        // color:  _isBlackBackground ? Colors.blue : Colors.red, // Color for the preceding words
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: ' ${bookmarkProvider.bookMarkedShlokes[index].title ?.split(' ').last} ${bookmarkProvider.bookMarkedShlokes[index].title ?.split(' ')[bookmarkProvider.bookMarkedShlokes[index].title.split(' ').length - 1]}',
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

                                                final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == bookmarkProvider.bookMarkedShlokes[index].title
                                                );
                                                return GestureDetector(
                                                  onTap: () {
                                                    bookmarkProvider.toggleBookmark(bookmarkProvider.bookMarkedShlokes[index]);
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),





          // SingleChildScrollView(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       SizedBox(
          //         height: screenHeight * 0.8, // Adjust height to fit screen
          //         child: Consumer<BookmarkProvider>(
          //           builder: (BuildContext context, bookmarkProvider, Widget? child) {
          //             return  ListView.builder(
          //               padding: EdgeInsets.zero,
          //               itemCount: bookmarkProvider.bookMarkedShlokes.length ,// Use dynamic count based on bookmarks
          //               itemBuilder: (context, index) {
          //                // final bookmark = bookmarkProvider.bookMarkedShlokes;
          //                 return GestureDetector(
          //                   child:
          //
          //
          //
          //
          //
          //                   // Padding(
          //                   //   padding: EdgeInsets.symmetric(
          //                   //       horizontal: 8, vertical: screenHeight * 0.02),
          //                   //   child: Container(
          //                   //     width: screenWidth * 0.7,
          //                   //     decoration: BoxDecoration(
          //                   //       border: Border.all(
          //                   //           color: Color.fromRGBO(231, 231, 231, 1)),
          //                   //       borderRadius: BorderRadius.circular(10),
          //                   //     ),
          //                   //     child: Column(
          //                   //       crossAxisAlignment: CrossAxisAlignment.start,
          //                   //       children: [
          //                   //         // Dynamic image from bookmark
          //                   //         Container(
          //                   //           width: double.infinity,
          //                   //           height: screenHeight * 0.2,
          //                   //           child: ClipRRect(
          //                   //             borderRadius: BorderRadius.vertical(
          //                   //                 top: Radius.circular(13)),
          //                   //             child: Image.network(
          //                   //               bookmarkProvider.bookMarkedShlokes[index].imageBig ?? '',
          //                   //               //bookmark['image'] ?? '', // Load bookmark image
          //                   //               fit: BoxFit.cover,
          //                   //             ),
          //                   //           ),
          //                   //         ),
          //                   //         SizedBox(height: screenHeight * 0.00),
          //                   //         Padding(
          //                   //           padding: EdgeInsets.symmetric(
          //                   //               horizontal: screenWidth * 0.02),
          //                   //           child: Column(
          //                   //             crossAxisAlignment: CrossAxisAlignment.start,
          //                   //             children: [
          //                   //               Text(
          //                   //                 bookmarkProvider.bookMarkedShlokes[index].title ?? '',
          //                   //                 style: TextStyle(
          //                   //                   fontSize: screenWidth * 0.04,
          //                   //                   color: Colors.black87,
          //                   //                   fontWeight: FontWeight.w500,
          //                   //                 ),
          //                   //               ),
          //                   //
          //                   //               SizedBox(height: screenHeight * 0.01),
          //                   //               Row(
          //                   //                 children: [
          //                   //
          //                   //                   Icon(Icons.share_outlined),
          //                   //                   SizedBox(width: screenWidth * 0.05),
          //                   //
          //                   //                   Consumer<BookmarkProvider>(
          //                   //                     builder: (BuildContext context, bookmarkProvider, Widget? child) {
          //                   //                       final isBookmarked = bookmarkProvider.bookMarkedShlokes.any(
          //                   //                               (bookmarked) => bookmarked.title == bookmarkProvider.bookMarkedShlokes[index].title
          //                   //                       );
          //                   //
          //                   //                       return GestureDetector(
          //                   //                         onTap: () {
          //                   //                           bookmarkProvider.toggleBookmark(bookmarkProvider.bookMarkedShlokes[index]);
          //                   //                         },
          //                   //                         child: Icon(
          //                   //                           isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          //                   //                           size: screenWidth * 0.07,
          //                   //                         ),
          //                   //                       );
          //                   //                     },
          //                   //                   ),
          //                   //
          //                   //                   // GestureDetector(
          //                   //                   //   onTap: () {
          //                   //                   //
          //                   //                   //     _deleteBookmark(
          //                   //                   //       bookmark['title'] ?? '',
          //                   //                   //     );
          //                   //                   //   },
          //                   //                   //   child: Icon(
          //                   //                   //     Icons.bookmark,
          //                   //                   //     size: screenWidth * 0.07,
          //                   //                   //     color: Colors.black, // Always black
          //                   //                   //   ),
          //                   //                   // ),
          //                   //
          //                   //                 ],
          //                   //               ),
          //                   //               SizedBox(
          //                   //                 height: screenHeight * 0.01,
          //                   //               ),
          //                   //             ],
          //                   //           ),
          //                   //         ),
          //                   //       ],
          //                   //     ),
          //                   //   ),
          //                   // ),
          //
          //
          //                 );
          //               },
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),


        );
      },
    );
  }
}
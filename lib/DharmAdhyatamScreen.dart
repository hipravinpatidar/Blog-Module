import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/Bookmark Provider.dart';
import 'Controller/ShareScreen.dart';
import 'Detailspage.dart';
import 'SQLite Helper Class/database_helper.dart';
import 'apiservice/apiservice.dart';
import 'model/SubCategory_model.dart';

class DharmAdhyatamScreen extends StatefulWidget {
  final int myId;
  final int mylanguageid;

  DharmAdhyatamScreen({super.key, required this.myId, required this.mylanguageid});

  @override
  State<DharmAdhyatamScreen> createState() => _DharmAdhyatamScreenState();
}

class _DharmAdhyatamScreenState extends State<DharmAdhyatamScreen> {
  bool _isLoading = false;

  final shareMusic = ShareMusic();
  bool showAll = false;

  List<SubCategoryData> subCategoryList = [];
  final DatabaseHelper dbHelper = DatabaseHelper(); // Create a new instance directly

  // List to track bookmarked item IDs
  List<int> bookmarkedIds = [];

  @override
  void initState() {
    super.initState();
    getSubCategory();
  }

  Future<void> getSubCategory() async {
    setState(() {
      _isLoading = true;
    }
    );

    try {
      final Map<String, dynamic> res = await ApiService().getSubCategory(
          "https://mahakal.rizrv.in/api/v1/blog/category-by-blog?languageId=${widget.mylanguageid}&categoryId=${widget.myId}") as Map<String, dynamic>;

      if (res.containsKey('status') && res.containsKey('data') && res['data'] != null) {
        final categoryData = SubCategoryModel.fromJson(res);
        setState(() {
          subCategoryList = categoryData.data;
        });
      } else {
        print("Error in SubCategory: ${res['message']}");
      }
    } catch (error) {
      print("Error fetching subcategories: $error");
    } finally {
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
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bookmark removed!')));
  //     } else {
  //       // If it isn't, save the bookmark
  //       await dbHelper.insertBookmark(bookmark);
  //       setState(() {
  //         bookmarkedIds.add(data.id); // Update local state
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bookmark saved!')));
  //     }
  //   } catch (e) {
  //     print("Error saving/removing bookmark: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update bookmark')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      body: _isLoading // Show loading indicator if loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: subCategoryList.length,
              itemBuilder: (context, index) {
                final subCategoryItem = subCategoryList[index];
                final isBookmarked = bookmarkedIds.contains(subCategoryItem.id); // Check if item is bookmarked

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          remainingItems: subCategoryList, title: subCategoryItem.titleSlug, imageTop: subCategoryItem.imageBig ?? '',),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: screenWidth * 0.01),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(231, 231, 231, 1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: screenHeight * 0.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                subCategoryItem.imageBig ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subCategoryItem.title ?? '',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.black87,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                  ),maxLines: 2,
                                ),


                                SizedBox(
                                    height: screenHeight *
                                        0.01), // Reduced spacing

                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_outlined,
                                      color: Color.fromRGBO(
                                          128, 128, 128, 1),
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
                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),

                                    Icon(Icons.new_releases_outlined,size: screenWidth * 0.04,color: Color.fromRGBO(128,128,128,1),),

                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),
                                    Text(
                                      '120',
                                      style: TextStyle(
                                        color: Color.fromRGBO(128,128,128,1),                                                          fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),

                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),

                                    Icon(Icons.remove_red_eye_outlined,size: screenWidth * 0.04,color: Color.fromRGBO(128,128,128,1),),

                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),
                                    Text(
                                      "${subCategoryItem.hit}",
                                      style: TextStyle(
                                        color: Color.fromRGBO(128,128,128,1),                                                          fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),

                                    Spacer(),

                                    IconButton(
                                      color: Colors.transparent,
                                      highlightColor:
                                      Colors.transparent,
                                      icon: Icon(
                                          Icons.share_outlined,
                                          color: Color.fromRGBO(
                                              128, 128, 128, 1)),
                                      onPressed: () {
                                        shareMusic.shareSong(
                                            subCategoryList[
                                            index]);
                                      },
                                    ), //
                                    // SizedBox(
                                    //   width: screenWidth * 0.01,
                                    // ),

                                    Consumer<BookmarkProvider>(
                                      builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                        final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == subCategoryList[index].title);

                                        return GestureDetector(
                                          onTap: () {
                                            bookmarkProvider.toggleBookmark(subCategoryList[index]);
                                          },
                                          child: Icon(
                                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                            size: screenWidth * 0.07,
                                            color: Color.fromRGBO(128, 128, 128, 1),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),

                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),



                                // Row(
                                //   children: [
                                //     Icon(Icons.access_time_outlined, color: Color.fromRGBO(128, 128, 128, 1), size: screenWidth * 0.04),
                                //     SizedBox(width: screenWidth * 0.01),
                                //     // Text(
                                //     //   DateFormat.yMMMd().format(DateTime.parse(subCategoryItem.createdAt.toString())),
                                //     //   style: TextStyle(
                                //     //     color: Color.fromRGBO(128, 128, 128, 1),
                                //     //     fontWeight: FontWeight.w500,
                                //     //     fontSize: screenWidth * 0.03,
                                //     //   ),
                                //     // ),
                                //     SizedBox(width: screenWidth * 0.01,),
                                //     Icon(Icons.remove_red_eye_outlined, color: Color.fromRGBO(128, 128, 128, 1), size: screenWidth * 0.04),
                                //     SizedBox(width: screenWidth * 0.01),
                                //     Text(
                                //       "${subCategoryItem.hit}",
                                //       style: TextStyle(
                                //         color: Color.fromRGBO(128, 128, 128, 1),
                                //         fontWeight: FontWeight.w500,
                                //         fontSize: screenWidth * 0.03,
                                //       ),
                                //     ),
                                //     Spacer(),
                                //     IconButton(
                                //       color: Colors.transparent,
                                //       highlightColor: Colors.transparent,
                                //
                                //
                                //       icon: Icon(Icons.share_outlined, color: Color.fromRGBO(128, 128, 128, 1)),
                                //       onPressed: () {
                                //
                                //         shareMusic.shareSong(subCategoryList[index]);
                                //
                                //       },
                                //     ),
                                //
                                //     Consumer<BookmarkProvider>(
                                //       builder: (BuildContext
                                //       context,
                                //           bookmarkProvider,
                                //           Widget? child) {
                                //         final isBookmarked = bookmarkProvider
                                //             .bookMarkedShlokes
                                //             .any((bookmarked) =>
                                //         bookmarked!.title==
                                //             subCategoryList[
                                //             index].title);
                                //
                                //         return
                                //
                                //           GestureDetector(
                                //           onTap: () {
                                //             bookmarkProvider
                                //                 .toggleBookmark(
                                //                 subCategoryList[
                                //                 index]);
                                //           },
                                //           child: Icon(
                                //             isBookmarked
                                //                 ? Icons
                                //                 .bookmark
                                //                 : Icons
                                //                 .bookmark_border,
                                //             size:
                                //             screenWidth *
                                //                 0.07,
                                //           ),
                                //         );
                                //       },
                                //     ),
                                //
                                //
                                //
                                //
                                //   ],
                                // ),


                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

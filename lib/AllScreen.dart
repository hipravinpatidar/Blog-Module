import 'package:blogstask/Controller/language_provider.dart';
import 'package:blogstask/SavedScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/Bookmark Provider.dart';
import 'Controller/ShareScreen.dart';
import 'Detailspage.dart';
import 'SQLite Helper Class/database_helper.dart';
import 'ViewallScreen.dart';
import 'apiservice/apiservice.dart';
import 'model/SubCategory_model.dart';

class AllScreen extends StatefulWidget {
  const AllScreen({super.key});

  @override
  State<AllScreen> createState() => _AllScreenState();
}

int _currentIndex = 0;
int currentIndex = 0;

class _AllScreenState extends State<AllScreen> {

  late CarouselController _carouselController;

  bool _isLoading = false;

  BookmarkProvider bookmarkProvider = BookmarkProvider();

  final DatabaseHelper dbHelper =
  DatabaseHelper(); // Create a new instance directly
  List<int> bookmarkedIds = [];
  bool showAll = false;

  final shareMusic = ShareMusic();

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    getSubCategory();
  }


  void _nextPage() {
    print("Clicked next");
    _carouselController.nextPage();
  }

  void _prevPage() {
    print("Clicked previous");
    _carouselController.previousPage();
  }


  List<SubCategoryData> subCategoryList = [];

  Future<void> getSubCategory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

      print(languageProvider.isEnglish ? "English" : "Hindi");

      final Map<String, dynamic> resHindi = await ApiService().getSubCategory(
          "https://mahakal.rizrv.in/api/v1/blog/category-by-blog?languageId=${languageProvider.isEnglish ? 1 : 2}") as Map<String, dynamic>;
      // Process Hindi subcategories
      if (resHindi.containsKey('status') && resHindi.containsKey('data') && resHindi['data'] != null) {
        final categoryDataHindi = SubCategoryModel.fromJson(resHindi);
        subCategoryList = categoryDataHindi.data;
        subCategoryList.sort((a, b) => b.hit!.compareTo(a.hit!)); // Sort by 'hit' in descending order
      }

      setState(() {
       // print("English SubCategory List Count: ${subCategoryListEnglish.length}");
        print("Hindi SubCategory List Count: ${subCategoryList[0].title}");
      });
    } catch (error) {
      print("Error fetching subcategories: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Consumer<LanguageProvider>(
      builder: (BuildContext context, languageProvider, Widget? child) {

       // var itemList = languageProvider.isEnglish ? subCategoryListEnglish : subCategoryList;

        return Scaffold(
            body: _isLoading // Show loading indicator if loading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                        child: Column(
                          children: [

                           // CustomCarousel(subCategoryList:subCategoryList),

                            CarouselSlider(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 200.0,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                autoPlayAnimationDuration: const Duration(milliseconds: 200),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                              ),
                              items: subCategoryList.map((category) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade400,
                                        image: DecorationImage(
                                          image: NetworkImage(category.imageSlider ?? ''),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                                  onPressed: _prevPage,
                                                ),
                                                Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => DetailsPage(
                                                            remainingItems: subCategoryList,
                                                            title: category.titleSlug,
                                                            imageTop: category.imageBig ?? '',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(255, 118, 10, 1),
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenWidth * 0.02),
                                                          child: Text(
                                                            languageProvider.isEnglish ? "Vrat Katha" : "व्रत कथा",
                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                                                  onPressed: _nextPage,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              category.title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),

                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Container(
                                width: double.infinity,
                                height: screenHeight * 0.05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(255, 238, 238, 1)),
                                child: Padding(
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
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: screenWidth * 0.04),
                                          ),
                                          Spacer(),
                                          GestureDetector(

                                            onTap: () {
                                              //final subCategoryItem = subCategoryList;

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ViewallScreen(
                                                      subCategoryData: subCategoryList,
                                                    ),
                                                  ));
                                            },
                                            child: Text(
                                              languageProvider.isEnglish ? "View All" : "सभी को देखें",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(255, 139, 33, 1),
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.32, // Height for ListView
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: subCategoryList.length > 10 ? 10 : subCategoryList.length,
                                    itemBuilder: (context, index) {
                                      final subCategoryItem = subCategoryList[index];
                                      final isBookmarked = bookmarkedIds.contains(
                                          subCategoryItem
                                              .id); // Check if item is bookmarked

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailsPage(
                                                remainingItems: subCategoryList, title: subCategoryItem.titleSlug, imageTop: subCategoryList[index].imageBig ?? '',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8), // Adjusted padding
                                          child: Container(
                                            width: screenWidth * 0.8,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(231, 231, 231,
                                                      1)), // Black border
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: screenHeight * 0.20,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(12)),
                                                    child: Image.network(
                                                      subCategoryItem.imageBig ?? '',
                                                      fit: BoxFit
                                                          .cover, // Adjusted BoxFit
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenHeight * 0.00),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: screenWidth * 0.02),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        subCategoryItem.title ?? '',
                                                        overflow: TextOverflow
                                                            .ellipsis, // Add this line
                                                        maxLines: 1, // Add this line
                                                        style: TextStyle(
                                                          fontSize: screenWidth * 0.04,
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      // Reduced spacing

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
                                                          SizedBox(width: screenWidth * 0.01,),
                                                          SizedBox(width: screenWidth * 0.2,
                                                            child: Text(subCategoryItem.createdAt.toString(),
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Color.fromRGBO(128, 128, 128, 1),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: screenWidth * 0.03,
                                                              ),
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
                                                          Text("${5}",
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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),


                            Container(
                                width: double.infinity,
                                height: screenHeight * 0.05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(255, 238, 238, 1)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02),
                                  child: Row(
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
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: screenWidth * 0.04),
                                      ),
                                      Spacer(),
                                      GestureDetector(

                                        onTap: () {
                                          final subCategoryItem = subCategoryList[currentIndex];

                                          Navigator.push(
                                              context,

                                              MaterialPageRoute(
                                                builder: (context) => ViewallScreen(
                                                  subCategoryData: subCategoryList,
                                                ),
                                              ));
                                        },
                                        child: Text(
                                          languageProvider.isEnglish ? "View All" : "सभी को देखें",
                                          style: TextStyle(
                                              color: Color.fromRGBO(255, 139, 33, 1),
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.32, // Height for ListView
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    //itemCount: subCategoryList.skip(10).take(10).length,
                                    itemCount:subCategoryList.length > 10 ? subCategoryList.length - 10 : 0,
                                    itemBuilder: (context, index) {
                                     // final subCategoryItem = subCategoryList.skip(10).elementAt(index);
                                      final subCategoryItem = subCategoryList[index + 10];
                                      final isBookmarked = bookmarkedIds.contains(subCategoryItem.id); // Check if item is bookmarked

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailsPage(
                                                remainingItems: subCategoryList, title: subCategoryItem.titleSlug, imageTop: subCategoryItem.imageBig ?? '',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8), // Adjusted padding
                                          child: Container(
                                            width: screenWidth * 0.8,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(231, 231, 231,
                                                      1)), // Black border
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: screenHeight * 0.2,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(12)),
                                                    child: Image.network(
                                                      subCategoryItem.imageBig ?? '',
                                                      fit: BoxFit
                                                          .cover, // Adjusted BoxFit
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenHeight * 0.00),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: screenWidth * 0.02),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        subCategoryItem.title ?? '',
                                                        overflow: TextOverflow
                                                            .ellipsis, // Add this line
                                                        maxLines: 1, // Add this line
                                                        style: TextStyle(
                                                          fontSize: screenWidth * 0.04,
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      // Reduced spacing

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
                                                              shareMusic.shareSong(subCategoryList[index + 10]);
                                                            },
                                                          ), //
                                                          // SizedBox(
                                                          //   width: screenWidth * 0.01,
                                                          // ),

                                                          Consumer<BookmarkProvider>(
                                                            builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                                            //  final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == subCategoryList.skip(10).elementAt(index).title);
                                                              final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == subCategoryList[index + 10].title);

                                                              return GestureDetector(
                                                                onTap: () {
                                                                 // bookmarkProvider.toggleBookmark(subCategoryList.skip(10).elementAt(index));
                                                                  bookmarkProvider.toggleBookmark(subCategoryList[index + 10]);

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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Container(
                              height: screenHeight * 0.3,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(209, 209, 209, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Text(
                                    'Add banner e commerce',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.05),
                                  )),
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Container(
                                width: double.infinity,
                                height: screenHeight * 0.05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(255, 238, 238, 1)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02),
                                  child: Row(
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
                                        languageProvider.isEnglish ? "Random Posts'" : "रैंडम पोस्ट",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: screenWidth * 0.04),
                                      ),
                                      Spacer(),
                                      GestureDetector(

                                        onTap: () {
                                          final subCategoryItem = subCategoryList[currentIndex];

                                          Navigator.push(
                                              context,

                                              MaterialPageRoute(
                                                builder: (context) => ViewallScreen(
                                                  subCategoryData: subCategoryList,
                                                ),
                                              ));
                                        },
                                        child: Text(
                                          languageProvider.isEnglish ? "View All" : "सभी को देखें",
                                          style: TextStyle(
                                              color: Color.fromRGBO(255, 139, 33, 1),
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.32, // Height for ListView
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                   // itemCount: subCategoryList.skip(30).take(10).length,
                                    itemCount:subCategoryList.length > 20 ? subCategoryList.length - 20 : 0,
                                    itemBuilder: (context, index) {
                                     // final subCategoryItem = subCategoryList.skip(30).elementAt(index);
                                      final subCategoryItem = subCategoryList[index + 20];
                                      final isBookmarked = bookmarkedIds.contains(subCategoryItem.id); // Check if item is bookmarked

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailsPage(
                                                remainingItems: subCategoryList, title: subCategoryItem.titleSlug, imageTop: subCategoryItem.imageBig ?? '',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8), // Adjusted padding
                                          child: Container(
                                            width: screenWidth * 0.8,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(231, 231, 231, 1)), // Black border
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: screenHeight * 0.2,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(12)),
                                                    child: Image.network(
                                                      subCategoryItem.imageBig ?? '',
                                                      fit: BoxFit
                                                          .cover, // Adjusted BoxFit
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenHeight * 0.00),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: screenWidth * 0.02),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        subCategoryItem.title ?? '',
                                                        overflow: TextOverflow
                                                            .ellipsis, // Add this line
                                                        maxLines: 1, // Add this line
                                                        style: TextStyle(
                                                          fontSize: screenWidth * 0.04,
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      // Reduced spacing

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
                                                              color: Color.fromRGBO(128,128,128,1),
                                                              fontWeight: FontWeight.w500,
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
                                                                  subCategoryList[index + 20]);
                                                            },
                                                          ), //
                                                          // SizedBox(
                                                          //   width: screenWidth * 0.01,
                                                          // ),

                                                          Consumer<BookmarkProvider>(
                                                            builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                                             // final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == subCategoryList.skip(20).elementAt(index).title);
                                                              final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == subCategoryList[index + 20].title);

                                                              return GestureDetector(
                                                                onTap: () {
                                                                 // bookmarkProvider.toggleBookmark(subCategoryList.skip(20).elementAt(index));
                                                                  bookmarkProvider.toggleBookmark(subCategoryList[index + 20]);
                                                                },
                                                                child: Icon(
                                                                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                                  size: screenWidth * 0.07,
                                                                  color:  Color.fromRGBO(128, 128, 128, 1),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: screenHeight * 0.01,
                                                      ),
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      bookmarkProvider.bookMarkedShlokes.isEmpty ? Container() :
                      Column(
                        children: [
                          Container(
                            height: screenHeight * 0.39,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(235, 248, 255, 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: screenHeight * 0.03,
                                          width: screenWidth * 0.01,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(255, 90, 0, 1),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Text(
                                          languageProvider.isEnglish ? "Favorites" : "पसंदीदा",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: screenWidth * 0.05,
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to the 'View All' page
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SavedScreen()
                                                    //AllBookmarksScreen(), // Navigate to the new screen
                                              ),
                                            );
                                          },
                                          child: Text(
                                            languageProvider.isEnglish ? "View All" : "सभी को देखें",
                                            style: TextStyle(
                                                color: Color.fromRGBO(255, 139, 33, 1),
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),

                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Consumer<BookmarkProvider>(
                                        builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [

                                              Container(
                                                height: 200,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(image: NetworkImage("https://r2.erweima.ai/imgcompressed/compressed_9d52c59421e261edb11e06bd19535878.webp"),fit: BoxFit.cover)
                                                ),
                                              ),
                                              Container(
                                                height: 205,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: bookmarkProvider.bookMarkedShlokes.length ,
                                                  scrollDirection: Axis.horizontal,
                                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,),
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(left: screenWidth * 0.03),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => DetailsPage(
                                                                remainingItems: [], title: subCategoryList[index].titleSlug, imageTop: bookmarkProvider.bookMarkedShlokes[index].imageBig ?? '',
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: screenWidth * 0.4,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              color: Colors.white
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01,horizontal: screenWidth * 0.03),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [

                                                                SizedBox(height: screenWidth * 0.01,),
                                                                Container(
                                                                  height: 80,
                                                                  width: 133,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                      image: DecorationImage(image: NetworkImage(bookmarkProvider.bookMarkedShlokes[index].imageBig ?? ''),fit: BoxFit.cover)
                                                                  ),
                                                                ),

                                                                SizedBox(height: screenWidth * 0.02,),
                                                                SizedBox(width: screenWidth * 0.2,child: Text(bookmarkProvider.bookMarkedShlokes[index].title ?? '',style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth * 0.03,color: Colors.black,overflow: TextOverflow.ellipsis),maxLines: 2,)),

                                                                SizedBox(height: screenWidth * 0.01,),
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
                                                                  ],
                                                                ),


                                                                Row(
                                                                  children: [

                                                                    Icon(Icons.remove_red_eye_outlined,size: screenWidth * 0.04,color: Color.fromRGBO(128,128,128,1),),

                                                                    SizedBox(
                                                                      width: screenWidth * 0.01,
                                                                    ),
                                                                    Text(
                                                                      "400",
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
                                                                          size: screenWidth * 0.06,
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
                                                                        final isBookmarked = bookmarkProvider.bookMarkedShlokes.any(
                                                                                (bookmarked) => bookmarked.title == bookmarkProvider.bookMarkedShlokes[index].title
                                                                        );

                                                                        return GestureDetector(
                                                                          onTap: () {
                                                                            bookmarkProvider.toggleBookmark(bookmarkProvider.bookMarkedShlokes[index]);
                                                                          },
                                                                          child: Icon(
                                                                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                                            size: screenWidth * 0.07,
                                                                            color: Color.fromRGBO(128, 128, 128, 1),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),

                                                                    // Consumer<BookmarkProvider>(
                                                                    //   builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                                                    //     final isBookmarked = bookmarkProvider.bookMarkedShlokes.any((bookmarked) => bookmarked.title == subCategoryList[index].title);
                                                                    //
                                                                    //     return GestureDetector(
                                                                    //       onTap: () {
                                                                    //         bookmarkProvider.toggleBookmark(bookmarkProvider.bookMarkedShlokes[index]);
                                                                    //       },
                                                                    //       child: Icon(
                                                                    //         isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                                    //         size: screenWidth * 0.06,
                                                                    //         color: Color.fromRGBO(128, 128, 128, 1),
                                                                    //       ),
                                                                    //     );
                                                                    //   },
                                                                    // )


                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )




                                  // SizedBox(
                                  //   height: screenHeight * 0.40, // Adjust height to fit screen
                                  //   child: Consumer<BookmarkProvider>(
                                  //     builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                  //       return  ListView.builder(
                                  //         scrollDirection: Axis.horizontal,
                                  //         padding: EdgeInsets.zero,
                                  //         itemCount: bookmarkProvider.bookMarkedShlokes.length ,// Use dynamic count based on bookmarks
                                  //         itemBuilder: (context, index) {
                                  //           // final bookmark = bookmarkProvider.bookMarkedShlokes;
                                  //           return GestureDetector(
                                  //             child: Padding(
                                  //               padding: EdgeInsets.symmetric(
                                  //                   horizontal: 8, vertical: screenHeight * 0.05),
                                  //               child: Container(
                                  //                  width: screenWidth * 0.8,
                                  //                 decoration: BoxDecoration(
                                  //                   border: Border.all(
                                  //                       color: Color.fromRGBO(231, 231, 231, 1)),
                                  //                   borderRadius: BorderRadius.circular(10),
                                  //                 ),
                                  //                 child: Column(
                                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                                  //                   children: [
                                  //                     // Dynamic image from bookmark
                                  //                     Container(
                                  //                       width: double.infinity,
                                  //                       height: screenHeight * 0.2,
                                  //                       child: ClipRRect(
                                  //                         borderRadius: BorderRadius.vertical(
                                  //                             top: Radius.circular(12)),
                                  //                         child: Image.network(
                                  //                           bookmarkProvider.bookMarkedShlokes[index].imageBig ?? '',
                                  //                           //bookmark['image'] ?? '', // Load bookmark image
                                  //                           fit: BoxFit.cover,
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                     SizedBox(height: screenHeight * 0.00),
                                  //
                                  //                     //
                                  //                     // Padding(
                                  //                     //   padding: EdgeInsets.symmetric(
                                  //                     //       horizontal: screenWidth * 0.02),
                                  //                     //   child: Column(
                                  //                     //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //                     //     children: [
                                  //
                                  //
                                  //                           Padding(
                                  //                             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                                  //                             child: Text(
                                  //                               bookmarkProvider.bookMarkedShlokes[index].title ?? '',
                                  //                               style: TextStyle(
                                  //                                 fontSize: screenWidth * 0.04,
                                  //                                 color: Colors.black87,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //
                                  //                           Padding(
                                  //                             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02,),
                                  //                             child: Row(
                                  //                               children: [
                                  //
                                  //                                 Icon(Icons.share_outlined),
                                  //                                 SizedBox(width: screenWidth * 0.05),
                                  //
                                  //                                 Consumer<BookmarkProvider>(
                                  //                                   builder: (BuildContext context, bookmarkProvider, Widget? child) {
                                  //                                     final isBookmarked = bookmarkProvider.bookMarkedShlokes.any(
                                  //                                             (bookmarked) => bookmarked.title == bookmarkProvider.bookMarkedShlokes[index].title
                                  //                                     );
                                  //
                                  //                                     return GestureDetector(
                                  //                                       onTap: () {
                                  //                                         bookmarkProvider.toggleBookmark(bookmarkProvider.bookMarkedShlokes[index]);
                                  //                                       },
                                  //                                       child: Icon(
                                  //                                         isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  //                                         size: screenWidth * 0.07,
                                  //                                       ),
                                  //                                     );
                                  //                                   },
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //
                                  //
                                  //
                                  //
                                  //                     //     ],
                                  //                     //   ),
                                  //                     // ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           );
                                  //         },
                                  //       );
                                  //     },
                                  //   ),
                                  // ),


                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}

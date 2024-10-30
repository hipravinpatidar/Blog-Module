// import 'package:flutter/material.dart';
// import 'AllScreen.dart';
// import 'Controller/language_provider.dart';
// import 'DharmAdhyatamScreen.dart';
// import 'package:provider/provider.dart';
// import 'SavedScreen.dart';
// import 'apiservice/apiservice.dart';
// import 'model/Category_model.dart';
//
// class Frontpage extends StatefulWidget {
//   const Frontpage({super.key});
//
//   @override
//   State<Frontpage> createState() => _FrontpageState();
// }
//
// class _FrontpageState extends State<Frontpage> {
//   @override
//   void initState() {
//     super.initState();
//     // Get English category data
//     getCategoryData();
//     // Get Hindi category data
//   }
//
//   bool _isLoading = true;
//
//   LanguageProvider languageProvider = LanguageProvider();
//
//   List<Category> categoryListEnglish = [];
//  // List<Category> categoryListHindi = [];
//
//   Future<void> refresh() async {
//     await getCategoryData();
//   }
//
//   Future<void> getCategoryData() async {
//     _isLoading = true;
//
//     try {
//       final Map<String, dynamic> resEnglish = await ApiService().getCategory("https://mahakal.rizrv.in/api/v1/blog/category-blog?languageId=${languageProvider.isEnglish ? 2 : 1}") as Map<String, dynamic>;
//     //  final Map<String, dynamic> resHindi = await ApiService().getCategory("https://mahakal.rizrv.in/api/v1/blog/category-blog?languageId=1") as Map<String, dynamic>;
//
//       print(resEnglish);
//      // print(resHindi);
//
//       if (resEnglish.containsKey('status') && resEnglish.containsKey('categories') && resEnglish['categories'] != null) {
//         final categoryDataEnglish = CategoryModel.fromJson(resEnglish);
//         categoryListEnglish = categoryDataEnglish.categories;
//       }
//
//       // if (resHindi.containsKey('status') && resHindi.containsKey('categories') && resHindi['categories'] != null) {
//       //   final categoryDataHindi = CategoryModel.fromJson(resHindi);
//       //   categoryListHindi = categoryDataHindi.categories;
//       // }
//
//       setState(() {
//         print(categoryListEnglish.length);
//         //print(categoryListHindi.length);
//       });
//     } catch (e) {
//       print(e);
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     var screenWidth = MediaQuery.of(context).size.width;
//     var screenHeight = MediaQuery.of(context).size.height;
//
//     return Consumer<LanguageProvider>(
//       builder: (context, languageProvider, child) {
//         return
//           //SafeArea(
//          // child:
//           DefaultTabController(
//             length: categoryListEnglish.length,
//            // length: languageProvider.isEnglish ? categoryListEnglish.length + 1 : categoryListHindi.length + 1,
//             child: Scaffold(
//               backgroundColor: Colors.white,
//               appBar: AppBar(
//                 elevation: 0,
//                 toolbarHeight: screenWidth * 0.13,
//                 shadowColor: Colors.transparent,
//                 backgroundColor: Colors.white,
//                 title: Text(
//                   "Blogs",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.orange,
//                     fontSize: MediaQuery.of(context).size.width * 0.06,
//                     fontFamily: 'Roboto',
//                   ),
//                 ),
//                 centerTitle: true,
//                 leading: Icon(Icons.arrow_back, color: Colors.black, size: MediaQuery.of(context).size.width * 0.06,),
//
//                 actions: [
//                   SizedBox(width: MediaQuery.of(context).size.width * 0.02),
//
//                   IconButton(
//                     icon: Icon(Icons.translate),  // Use a single icon
//                     onPressed: () {
//                       languageProvider.toggleLanguage();
//                       refresh();// Toggle the language without changing the icon
//                     },
//                   ),
//
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => SavedScreen()),
//                       );
//                     },
//                     child: Icon(
//                       Icons.bookmark_border_outlined,
//                       size: MediaQuery.of(context).size.width * 0.07,
//                     ),
//                   ),
//
//                   SizedBox(width: screenWidth * 0.04,)
//                 ],
//                 bottom: TabBar(
//
//                   unselectedLabelColor: Colors.grey,
//                   labelColor: Colors.black,
//                   padding: EdgeInsets.symmetric(horizontal: 10,vertical: screenWidth * 0.03),
//                   indicatorColor: Colors.orangeAccent,
//                   dividerColor: Colors.transparent,
//                   splashFactory: NoSplash.splashFactory,
//                   indicatorSize: TabBarIndicatorSize.tab,
//
//
//                   tabAlignment: TabAlignment.start,
//                    isScrollable: true,
//                   // indicatorColor: Colors.orange,
//                   // indicatorWeight: 0.5,
//                   // dividerColor: Colors.transparent,
//                   // splashFactory: NoSplash.splashFactory,
//                   // unselectedLabelColor: Colors.black,
//                   // labelColor: Colors.orange,
//                   labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
//                   tabs: [
//                     Column(
//                       children: [
//                         Text(languageProvider.isEnglish ? "सभी" : "All"),
//                       ],
//                     ),
//                     ...categoryListEnglish.map((cat) =>  Column(children: [Text(cat.name)])
//                     )
//
//
//                     // ...languageProvider.isEnglish
//                     //     ? List.generate(categoryListEnglish.length, (index) => Column(children: [Text("${categoryListEnglish[index].name}")]))
//                     //     : List.generate(categoryListHindi.length, (index) => Column(children: [Text("${categoryListHindi[index].name}")]))
//                   ],
//                 ),
//               ),
//               body: TabBarView(
//                 children: [
//                    const AllScreen(),
//
//                   ...categoryListEnglish.map((cat) => DharmAdhyatamScreen(myId: cat.id, mylanguageid: cat.langId,))
//
//                   //
//                   // ...languageProvider.isEnglish
//                   //     ? categoryListEnglish.map((cat) => DharmAdhyatamScreen(myId: cat.id, mylanguageid: cat.langId,))
//                   //     : categoryListHindi.map((cat) => DharmAdhyatamScreen(myId: cat.id, mylanguageid: cat.langId,)),
//
//                 ],
//               ),
//             ),
//           );
//        // );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'AllScreen.dart';
import 'Controller/language_provider.dart';
import 'DharmAdhyatamScreen.dart';
import 'package:provider/provider.dart';
import 'SavedScreen.dart';
import 'apiservice/apiservice.dart';
import 'model/Category_model.dart';

class Frontpage extends StatefulWidget {
  const Frontpage({super.key});

  @override
  State<Frontpage> createState() => _FrontpageState();
}

class _FrontpageState extends State<Frontpage> {
  bool _isLoading = true;
  List<Category> categoryList = [];

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  Future<void> refresh() async {
    await getCategoryData();
  }

  Future<void> getCategoryData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final String url = "https://mahakal.rizrv.in/api/v1/blog/category-blog?languageId=${languageProvider.isEnglish ? 1 : 2}";
      final Map<String, dynamic> response = await ApiService().getCategory(url) as Map<String, dynamic>;

      if (response.containsKey('status') && response.containsKey('categories') && response['categories'] != null) {
        final categoryData = CategoryModel.fromJson(response);
        setState(() {
          categoryList = categoryData.categories;
        });
      }
    } catch (error) {
      print("Error fetching categories: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return DefaultTabController(
          length: categoryList.length + 1,
          child: SafeArea(
            child:
            _isLoading ? Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator())) :
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: screenWidth * 0.13,
                backgroundColor: Colors.white,
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
                leading: Icon(Icons.arrow_back, color: Colors.black, size: screenWidth * 0.06),
                actions: [
                  IconButton(
                    icon: Icon(Icons.translate),
                    onPressed: () async {
                      languageProvider.toggleLanguage();
                      await refresh();  // Refresh data with new language
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SavedScreen()));
                    },
                    child: Icon(
                      Icons.bookmark_border_outlined,
                      size: screenWidth * 0.07,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                ],
                bottom: TabBar(

                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: screenWidth * 0.03),
                  indicatorColor: Colors.orangeAccent,
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),


                  tabs: [
                    Text(languageProvider.isEnglish ? "All" : "सभी"),
                    ...categoryList.map((cat) => Text(cat.name)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  const AllScreen(),
                  ...categoryList.map((cat) => DharmAdhyatamScreen(myId: cat.id, mylanguageid: cat.langId)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


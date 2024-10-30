import 'package:flutter/foundation.dart';

import '../database/bookmark_database_helper.dart';
import '../model/SubCategory_model.dart';

class BookmarkProvider with ChangeNotifier {
  List<SubCategoryData> _bookMarkedShlokes = [];

  List<SubCategoryData> get bookMarkedShlokes => _bookMarkedShlokes;

  BookmarkProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    // Load bookmarks from the database using the DBHelper class
    _bookMarkedShlokes = await DBHelper.getBookmarks();
    notifyListeners();
  }

  Future<void> toggleBookmark(SubCategoryData shlok) async {
    // Check if the shlok is already bookmarked by comparing the title
    bool isBookmarked = _bookMarkedShlokes.any(
          (bookmarked) => bookmarked.title == shlok.title,
    );

    if (isBookmarked) {
      // If already bookmarked, remove the bookmark
      await DBHelper.deleteBookmark(shlok);
      _bookMarkedShlokes.removeWhere(
            (bookmarked) => bookmarked.title == shlok.title,
      );
    } else {
      // If not bookmarked, add the bookmark
      await DBHelper.insertBookmark(shlok);
      _bookMarkedShlokes.add(shlok);
    }

    // Notify listeners to update the UI after bookmarking changes
    notifyListeners();
  }

  bool isBookmarked(SubCategoryData shlok) {
    // Check if the item is already bookmarked
    return _bookMarkedShlokes.any(
          (bookmarked) => bookmarked.title == shlok.title,
    );
  }
}

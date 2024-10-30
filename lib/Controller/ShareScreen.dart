import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import '../model/SubCategory_model.dart';

class ShareMusic extends ChangeNotifier {
  void shareSong(SubCategoryData myData) {
    print("My Share Song ${myData.title}");
    Share.share(
      'Check out this song: ${myData.title} by ${myData.content}\nListen here: ${myData.imageUrl}',
    );
    notifyListeners();
  }
}

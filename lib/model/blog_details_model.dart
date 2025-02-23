// // To parse this JSON data, do
// //
// //     final blogDetails = blogDetailsFromJson(jsonString);
//
// import 'dart:convert';
//
// BlogDetails blogDetailsFromJson(String str) => BlogDetails.fromJson(json.decode(str));
//
// String blogDetailsToJson(BlogDetails data) => json.encode(data.toJson());
//
// class BlogDetails {
//   int status;
//   Data data;
//
//   BlogDetails({
//     required this.status,
//     required this.data,
//   });
//
//   factory BlogDetails.fromJson(Map<String, dynamic> json) => BlogDetails(
//     status: json["status"],
//     data: Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "data": data.toJson(),
//   };
// }
//
// class Data {
//   int id;
//   int langId;
//   String title;
//   String titleSlug;
//   dynamic titleHash;
//   String summary;
//   String content;
//   String keywords;
//   int userId;
//   int categoryId;
//   String imageBig;
//   String imageMid;
//   String imageSmall;
//   String imageSlider;
//   String imageMime;
//   String imageStorage;
//   int isSlider;
//   int isPicked;
//   int hit;
//   int sliderOrder;
//   String optionalUrl;
//   String postType;
//   String videoUrl;
//   String videoEmbedCode;
//   String imageUrl;
//   int needAuth;
//   int feedId;
//   dynamic postUrl;
//   int showPostUrl;
//   int visibility;
//   int status;
//   DateTime createdAt;
//
//   Data({
//     required this.id,
//     required this.langId,
//     required this.title,
//     required this.titleSlug,
//     required this.titleHash,
//     required this.summary,
//     required this.content,
//     required this.keywords,
//     required this.userId,
//     required this.categoryId,
//     required this.imageBig,
//     required this.imageMid,
//     required this.imageSmall,
//     required this.imageSlider,
//     required this.imageMime,
//     required this.imageStorage,
//     required this.isSlider,
//     required this.isPicked,
//     required this.hit,
//     required this.sliderOrder,
//     required this.optionalUrl,
//     required this.postType,
//     required this.videoUrl,
//     required this.videoEmbedCode,
//     required this.imageUrl,
//     required this.needAuth,
//     required this.feedId,
//     required this.postUrl,
//     required this.showPostUrl,
//     required this.visibility,
//     required this.status,
//     required this.createdAt,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     id: json["id"],
//     langId: json["lang_id"],
//     title: json["title"],
//     titleSlug: json["title_slug"],
//     titleHash: json["title_hash"],
//     summary: json["summary"],
//     content: json["content"],
//     keywords: json["keywords"],
//     userId: json["user_id"],
//     categoryId: json["category_id"],
//     imageBig: json["image_big"],
//     imageMid: json["image_mid"],
//     imageSmall: json["image_small"],
//     imageSlider: json["image_slider"],
//     imageMime: json["image_mime"],
//     imageStorage: json["image_storage"],
//     isSlider: json["is_slider"],
//     isPicked: json["is_picked"],
//     hit: json["hit"],
//     sliderOrder: json["slider_order"],
//     optionalUrl: json["optional_url"],
//     postType: json["post_type"],
//     videoUrl: json["video_url"],
//     videoEmbedCode: json["video_embed_code"],
//     imageUrl: json["image_url"],
//     needAuth: json["need_auth"],
//     feedId: json["feed_id"],
//     postUrl: json["post_url"],
//     showPostUrl: json["show_post_url"],
//     visibility: json["visibility"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "lang_id": langId,
//     "title": title,
//     "title_slug": titleSlug,
//     "title_hash": titleHash,
//     "summary": summary,
//     "content": content,
//     "keywords": keywords,
//     "user_id": userId,
//     "category_id": categoryId,
//     "image_big": imageBig,
//     "image_mid": imageMid,
//     "image_small": imageSmall,
//     "image_slider": imageSlider,
//     "image_mime": imageMime,
//     "image_storage": imageStorage,
//     "is_slider": isSlider,
//     "is_picked": isPicked,
//     "hit": hit,
//     "slider_order": sliderOrder,
//     "optional_url": optionalUrl,
//     "post_type": postType,
//     "video_url": videoUrl,
//     "video_embed_code": videoEmbedCode,
//     "image_url": imageUrl,
//     "need_auth": needAuth,
//     "feed_id": feedId,
//     "post_url": postUrl,
//     "show_post_url": showPostUrl,
//     "visibility": visibility,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//   };
// }


// To parse this JSON data, do
//
//     final blogDetails = blogDetailsFromJson(jsonString);

import 'dart:convert';

BlogDetails blogDetailsFromJson(String str) => BlogDetails.fromJson(json.decode(str));

String blogDetailsToJson(BlogDetails data) => json.encode(data.toJson());

class BlogDetails {
  int status;
  Data data;

  BlogDetails({
    required this.status,
    required this.data,
  });

  factory BlogDetails.fromJson(Map<String, dynamic> json) => BlogDetails(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  int langId;
  String title;
  String titleSlug;
  dynamic titleHash;
  String summary;
  String content;
  String keywords;
  int userId;
  int categoryId;
  dynamic imageBig;
  dynamic imageMid;
  dynamic imageSmall;
  dynamic imageSlider;
  String imageMime;
  String imageStorage;
  int isSlider;
  int isPicked;
  int hit;
  int sliderOrder;
  String optionalUrl;
  String postType;
  String videoUrl;
  String videoEmbedCode;
  dynamic imageUrl;
  int needAuth;
  int feedId;
  dynamic postUrl;
  int showPostUrl;
  int visibility;
  int status;
  DateTime createdAt;

  Data({
    required this.id,
    required this.langId,
    required this.title,
    required this.titleSlug,
    required this.titleHash,
    required this.summary,
    required this.content,
    required this.keywords,
    required this.userId,
    required this.categoryId,
    required this.imageBig,
    required this.imageMid,
    required this.imageSmall,
    required this.imageSlider,
    required this.imageMime,
    required this.imageStorage,
    required this.isSlider,
    required this.isPicked,
    required this.hit,
    required this.sliderOrder,
    required this.optionalUrl,
    required this.postType,
    required this.videoUrl,
    required this.videoEmbedCode,
    required this.imageUrl,
    required this.needAuth,
    required this.feedId,
    required this.postUrl,
    required this.showPostUrl,
    required this.visibility,
    required this.status,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    langId: json["lang_id"],
    title: json["title"],
    titleSlug: json["title_slug"],
    titleHash: json["title_hash"],
    summary: json["summary"],
    content: json["content"],
    keywords: json["keywords"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    imageBig: json["image_big"],
    imageMid: json["image_mid"],
    imageSmall: json["image_small"],
    imageSlider: json["image_slider"],
    imageMime: json["image_mime"],
    imageStorage: json["image_storage"],
    isSlider: json["is_slider"],
    isPicked: json["is_picked"],
    hit: json["hit"],
    sliderOrder: json["slider_order"],
    optionalUrl: json["optional_url"],
    postType: json["post_type"],
    videoUrl: json["video_url"],
    videoEmbedCode: json["video_embed_code"],
    imageUrl: json["image_url"],
    needAuth: json["need_auth"],
    feedId: json["feed_id"],
    postUrl: json["post_url"],
    showPostUrl: json["show_post_url"],
    visibility: json["visibility"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lang_id": langId,
    "title": title,
    "title_slug": titleSlug,
    "title_hash": titleHash,
    "summary": summary,
    "content": content,
    "keywords": keywords,
    "user_id": userId,
    "category_id": categoryId,
    "image_big": imageBig,
    "image_mid": imageMid,
    "image_small": imageSmall,
    "image_slider": imageSlider,
    "image_mime": imageMime,
    "image_storage": imageStorage,
    "is_slider": isSlider,
    "is_picked": isPicked,
    "hit": hit,
    "slider_order": sliderOrder,
    "optional_url": optionalUrl,
    "post_type": postType,
    "video_url": videoUrl,
    "video_embed_code": videoEmbedCode,
    "image_url": imageUrl,
    "need_auth": needAuth,
    "feed_id": feedId,
    "post_url": postUrl,
    "show_post_url": showPostUrl,
    "visibility": visibility,
    "status": status,
    "created_at": createdAt.toIso8601String(),
  };
}

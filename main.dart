import 'package:flutter/material.dart';

import "package:provider/provider.dart";

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => GalleryModel(),
    child: const MyApp(),
  ));
}

List urls = [
  "https://live.staticflickr.com/65535/50489498856_67fbe52703_w.jpg", // Example direct image URL
  "https://live.staticflickr.com/65535/50488789168_ff9f1f8809_w.jpg",
  "https://live.staticflickr.com/65535/50489498856_67fbe52703_w.jpg",
  "https://live.staticflickr.com/65535/50488789168_ff9f1f8809_w.jpg",
];

class PhotoState {
  final String url;
  bool selected;
  bool display;
  Set<String> tags = {};

  PhotoState(
      {required this.url,
      this.display = true,
      this.selected = false,
      required this.tags});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: "app", home: Gallery());
  }
}

class GalleryModel extends ChangeNotifier {
  bool isTagging = false;
  List<PhotoState> state =
      List.of(urls.map((s) => PhotoState(url: s, tags: {})));
  Set<String> tags = {"all", "nature", "cats"};

  onTagging(String? url) {
    isTagging = !isTagging;
    for (var ps in state) {
      if (isTagging && ps.url == url) {
        ps.selected = true;
      } else {
        ps.selected = false;
      }
    }
    notifyListeners();
  }

  onPhotoSelect(String url, bool selected) {
    for (var ps in state) {
      if (ps.url == url) {
        ps.selected = true;
      }
    }
    notifyListeners();
  }

  selectedTag(String tag) {
    if (isTagging) {
      if (tag != "all") {
        for (var ps in state) {
          if (ps.selected == true) {
            ps.tags.add(tag);
          }
        }
      }
      onTagging(null);
    } else {
      for (var ps in state) {
        ps.display = tag == "all" ? true : ps.tags.contains(tag);
      }
    }
    notifyListeners();
  }
}

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryModel>(
        builder: (context, gallery, child) => Scaffold(
            appBar: AppBar(
              title: const Text("Welcome"),
            ),
            body: GridView.count(
              primary: false,
              crossAxisCount: 2,
              children: List.of(
                  gallery.state.where((ps) => ps.display).map((state) => Photo(
                        state: state,
                        selectable: gallery.isTagging,
                        onLongPress: gallery.onTagging,
                        onSelect: gallery.onPhotoSelect,
                      ))),
            ),
            drawer: Drawer(
              child: ListView(
                children: List.of(gallery.tags.map((t) => ListTile(
                      title: Text(t),
                      onTap: () {
                        gallery.selectedTag(t);
                        Navigator.of(context).pop();
                      },
                    ))),
              ),
            )));
  }
}

class Photo extends StatelessWidget {
  final PhotoState state;
  final bool selectable;
  final Function onSelect;
  final Function onLongPress;
  const Photo(
      {super.key,
      required this.state,
      required this.selectable,
      required this.onLongPress,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      GestureDetector(
        onLongPress: () => onLongPress(state.url),
        child: Image.network(state.url),
      )
    ];

    if (selectable) {
      children.add(Positioned(
          top: 0,
          left: 10,
          child: Theme(
              data: Theme.of(context)
                  .copyWith(unselectedWidgetColor: Colors.grey[400]),
              child: Checkbox(
                value: state.selected,
                activeColor: Colors.white,
                checkColor: Colors.black,
                onChanged: (value) => onSelect(state.url, value),
              ))));
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: children,
      ),
    );
  }
}





      //
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// void main() {
//   runApp(const MyApp());
// }

// List urls = [
//   "https://live.staticflickr.com/65535/50489498856_67fbe52703_w.jpg", // Example direct image URL
//   "https://live.staticflickr.com/65535/50488789168_ff9f1f8809_w.jpg",
//   "https://live.staticflickr.com/65535/50489498856_67fbe52703_w.jpg",
//   "https://live.staticflickr.com/65535/50488789168_ff9f1f8809_w.jpg",
// ];

// class PhotoState {
//   final String url;
//   bool selected;
//   bool display;
//   Set<String> tags = {};

//   PhotoState(
//       {required this.url,
//       this.display = true,
//       this.selected = false,
//       required this.tags});
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool isTagging = false;
//   List<PhotoState> state =
//       List.of(urls.map((s) => PhotoState(url: s, tags: {})));
//   Set<String> tags = {"all", "nature", "cats"};

//   onTagging(String? url) {
//     setState(() {
//       isTagging = !isTagging;
//       for (var ps in state) {
//         if (isTagging && ps.url == url) {
//           ps.selected = true;
//         } else {
//           ps.selected = false;
//         }
//       }
//     });
//   }

//   onPhotoSelect(String url, bool selected) {
//     setState(() {
//       for (var ps in state) {
//         if (ps.url == url) {
//           ps.selected = true;
//         }
//       }
//     });
//   }

//   selectedTag(String tag) {
//     setState(() {
//       if (isTagging) {
//         if (tag != "all") {
//           for (var ps in state) {
//             if (ps.selected == true) {
//               ps.tags.add(tag);
//             }
//           }
//         }
//         onTagging(null);
//       } else {
//         for (var ps in state) {
//           ps.display = tag == "all" ? true : ps.tags.contains(tag);
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: "app",
//         home: Gallery(
//             state: state,
//             tagging: isTagging,
//             tags: tags,
//             onTagging: onTagging,
//             selectTag: selectedTag,
//             onPhotoSelect: onPhotoSelect));
//   }
// }

// class Gallery extends StatelessWidget {
//   final List<PhotoState> state;
//   final Set<String> tags;
//   final bool tagging;

//   final Function onTagging;
//   final Function selectTag;
//   final Function onPhotoSelect;
//   const Gallery(
//       {required this.state,
//       required this.tagging,
//       required this.tags,
//       required this.onTagging,
//       required this.selectTag,
//       required this.onPhotoSelect,
//       super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Welcome"),
//         ),
//         body: GridView.count(
//           primary: false,
//           crossAxisCount: 2,
//           children:
//               List.of(state.where((ps) => ps.display).map((state) => Photo(
//                     state: state,
//                     selectable: tagging,
//                     onLongPress: onTagging,
//                     onSelect: onPhotoSelect,
//                   ))),
//         ),
//         drawer: Drawer(
//           child: ListView(
//             children: List.of(tags.map((t) => ListTile(
//                   title: Text(t),
//                   onTap: () {
//                     selectTag(t);
//                     Navigator.of(context).pop();
//                   },
//                 ))),
//           ),
//         ));
//   }
// }

// class Photo extends StatelessWidget {
//   final PhotoState state;
//   final bool selectable;
//   final Function onSelect;
//   final Function onLongPress;
//   const Photo(
//       {super.key,
//       required this.state,
//       required this.selectable,
//       required this.onLongPress,
//       required this.onSelect});

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> children = [
//       GestureDetector(
//         onLongPress: () => onLongPress(state.url),
//         child: Image.network(state.url),
//       )
//     ];

//     if (selectable) {
//       children.add(Positioned(
//           top: 0,
//           left: 10,
//           child: Theme(
//               data: Theme.of(context)
//                   .copyWith(unselectedWidgetColor: Colors.grey[400]),
//               child: Checkbox(
//                 value: state.selected,
//                 activeColor: Colors.white,
//                 checkColor: Colors.black,
//                 onChanged: (value) => onSelect(state.url, value),
//               ))));
//     }

//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: Stack(
//         alignment: Alignment.center,
//         children: children,
//       ),
//     );
//   }
// }







     //stateful
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// var url = "https://images.app.goo.gl/AB3j1xibNe4fbCXk7";

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: "app",
//       home: Gallery(),
//     );
//   }
// }

// List urls = [
//   "https://live.staticflickr.com/65535/50489498856_67fbe52703_w.jpg", // Example direct image URL
//   "https://live.staticflickr.com/65535/50488789168_ff9f1f8809_w.jpg",
//   "https://live.staticflickr.com/65535/50489498856_67fbe52703_w.jpg",
//   "https://live.staticflickr.com/65535/50488789168_ff9f1f8809_w.jpg",
// ];

// class Gallery extends StatelessWidget {
//   const Gallery({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Welcome"),
//         ),
//         body: GridView.count(
//           primary: false,
//           crossAxisCount: 2,
//           children: List.of(urls.map((url) => Photo(url: url))),
//         ));
//   }
// }

// class Photo extends StatefulWidget {
//   final String url;
//   const Photo({super.key, required this.url});

//   @override
//   PhotoState createState() => PhotoState();
// }

// class PhotoState extends State<Photo> {
//   late String currentUrl;
//   var index = 0;

//   @override
//   initState() {
//     super.initState();
//     currentUrl = widget.url;
//   }

//   onTap() {
//     setState(() {
//       index >= urls.length - 1 ? index = 0 : index++;
//     });
//     currentUrl = urls[index];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Image.network(currentUrl),
//       ),
//     );
//   }
// }





     //injection
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// var url = "https://images.app.goo.gl/AB3j1xibNe4fbCXk7";

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: "app",
//       home: Gallery(),
//     );
//   }
// }

// List urls = [
//   "https://live.staticflickr.com/65535/50489498856_67fbe52703_w.jpg", // Example direct image URL
//   "https://live.staticflickr.com/65535/50488789168_ff9f1f8809_w.jpg",
//   "https://live.staticflickr.com/65535/50489498856_67fbe52703_w.jpg",
//   "https://live.staticflickr.com/65535/50488789168_ff9f1f8809_w.jpg",
// ];

// class Gallery extends StatelessWidget {
//   const Gallery({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Welcome"),
//         ),
//         body: GridView.count(
//           primary: false,
//           crossAxisCount: 2,
//           children: List.of(urls.map((url) => Photo(url: url))),
//         ));
//   }
// }

// class Photo extends StatelessWidget {
//   const Photo({super.key, required this.url});
//   final String url;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: Image.network(url),
//     );
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//mock data
import 'package:flutter/services.dart' show rootBundle;

class Game {
  final int id;
  final String title;
  final String cover;
  final String shortText;
  final String coverColor;
  final List<dynamic> contributors;

  Game(
      {required this.id,
      required this.title,
      required this.cover,
      required this.shortText,
      required this.coverColor,
      required this.contributors});

  factory Game.fromJson(Map<String, dynamic> json, itchJson) {
    return Game(
      id: json['id'] ?? 0,
      title: json['title'] ?? '---',
      cover: json['cover'] ?? '',
      coverColor: json['cover_color'] ?? '',
      shortText: json['short_text'] ?? '',
      contributors: itchJson['contributors'] != null
          ? List<dynamic>.from(itchJson['contributors'])
          : [],
    );
  }
}

class SliverGamesFromItch extends StatefulWidget {
  final ScrollController scrollController;
  const SliverGamesFromItch({Key? key, required this.scrollController})
      : super(key: key);

  @override
  _SliverGamesFromItchState createState() => _SliverGamesFromItchState();
}

class _SliverGamesFromItchState extends State<SliverGamesFromItch> {
  List<Game> games = [];
  double offset = 0;

  Future<void> fetchGames() async {
    // final response =
    // await http.get(Uri.parse('https://itch.io/jam/328643/entries.json'));

    // if (response.statusCode == 200) {
    //   final jsonData = jsonDecode(utf8.decode(response.bodyBytes));

    // mockd
    Future<String> _loadJsonFile() async {
      return await rootBundle.loadString('assets/entries.json');
    }

    String jsonString = await _loadJsonFile();
    Map<String, dynamic> jsonData = json.decode(jsonString);

    setState(() {
      games = (jsonData['jam_games'] as List)
          .map((gameJson) => Game.fromJson(gameJson['game'], gameJson))
          .toList();
    });

    // } else {
    //   throw Exception('Failed to load games');
    // }
  }

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    // log scrollcontrollers position on the page to the console
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          constraints: BoxConstraints(
            minHeight: 100,
          ),
          child: ConstrainedSliverWidth(
            maxWidth: 450,
            child: Center(
              child: Card(
                elevation: 0,
                child: ListTile(
                  // open dialog with game details

                  onTap: () => Navigator.push(
                    context,
                    HeroDialogRoute(
                      // fullscreenDialog: true,

                      builder: (BuildContext context) => Container(
                        constraints: BoxConstraints(
                          minHeight: 200,
                          maxWidth: 400,
                        ),
                        child: Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.all(10),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // clipBehavior: Clip.none,
                              // alignment: Alignment.center,
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)),
                                        color: Colors.grey[50],
                                      ),
                                      constraints: BoxConstraints(
                                        minHeight: 200,
                                        maxWidth: 400,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      constraints: BoxConstraints(
                                        minHeight: 200,
                                        maxWidth: 400,
                                      ),
                                      child: Hero(
                                          tag: games[index].id,
                                          child: ShowImage(
                                              game: games[index],
                                              square: false)),
                                    ),
                                  ],
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight: 200,
                                    maxWidth: 400,
                                  ),
                                  //round bottom corners
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    color: Colors.white,
                                  ),

                                  // height: 200,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(15),
                                  //     color: Colors.lightBlue),
                                  padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(games[index].title,
                                          style: TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center),
                                      SizedBox(height: 16),
                                      Text(games[index].shortText,
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center),
                                      SizedBox(height: 32),
                                      Text(
                                          games[index]
                                              .contributors
                                              .map((e) => e['name'])
                                              .join(', '),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xffff9105E6)),
                                          textAlign: TextAlign.center),
                                      SizedBox(height: 32),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.maybePop(context),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text('Back'),
                                            ),
                                          ),
                                          // TextButton(
                                          //   onPressed: () {},
                                          //   child: Text('Download'),
                                          // ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                // Positioned(
                                //   top: -100,
                                //   child:

                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(games[index].title),
                  subtitle: Text(games[index].shortText,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  contentPadding: EdgeInsets.all(24),
                  // add rounded corners to the listtile
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // subtitle: Text(games[index].contributors.map((e) => e['name']).join(', ')),
                  leading: Container(
                    child: Hero(
                        tag: games[index].id,
                        child: ShowImage(game: games[index], square: true)),
                  ),
                ),
              ),
            ),
          ),
        ),
        childCount: games.length,
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({
    super.key,
    required this.game,
    required this.square,
  });

  final Game game;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: !square
          ? BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))
          : BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: square ? 1 : (630 / 500),
        child: Container(
          color: Colors.white,
          child: Image.network(
            game.cover,
            fit: BoxFit.cover,
            //buid rounded corners
            frameBuilder: (BuildContext context, Widget child, int? frame,
                bool? wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded!) {
                return child;
              }
              return AnimatedOpacity(
                child: child,
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
              );
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Text('🕹️');
            },
          ),
        ),
      ),
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      // with easeOut curve
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),

      child: new FadeTransition(
          opacity:
              new CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String? get barrierLabel => "Game Details";
}

class ConstrainedSliverWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ConstrainedSliverWidth({
    Key? key,
    required this.child,
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = (size.width - maxWidth) / 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: max(padding, 0)),
      child: child,
    );
  }
}

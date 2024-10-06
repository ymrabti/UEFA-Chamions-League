import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:botola_max/lib.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ChampionshipModel extends ChampionshipModelParent {
  DataCompetition matchesStandings;
  ChampionshipModel({
    required super.assetAnthem,
    required super.color,
    required super.colorText,
    required super.competion,
    required this.matchesStandings,
  });
}

class ChampionshipModelParent {
  String assetAnthem;
  Color color;
  Color colorText;
  Competitions competion;
  ChampionshipModelParent({
    required this.assetAnthem,
    required this.color,
    required this.colorText,
    required this.competion,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen(
    this.competitions,
    this.today, {
    super.key,
  });
  final BotolaHappening today;
  final ElBotolaChampionsList competitions;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Competition? _competition;

  bool _splashing = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> chuldren = children(context);
    return WidgetWithWaiter(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Botola Max'),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/max-botola-logo.png',
            ),
          ),
          actions: [
            ThemeModeToggler(),
            if (kDebugMode)
              InkWell(
                onTap: () {},
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.textsms,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              )
          ],
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              //   expandedHeight: 200.0,
              leading: Builder(builder: (context) {
                String? comp = _competition?.emblem;
                return comp == null
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AppFileImageViewer(
                          url: context.watch<AppState>().exchangeCrest(comp),
                          color: elbrem.contains(_competition?.code)
                              ? Theme.of(context).colorScheme.background.transform(
                                    true,
                                  )
                              : null,
                        ),
                      );
              }),
              floating: false,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                title: dropDown(context),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return chuldren.elementAt(index);
                },
                childCount: chuldren.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> children(BuildContext context) {
    return [
      ...getTodaySubPhases.map(
        (e) => Stack(
          children: [
            ExpansionTile(
              key: e.title.globalKey,
              maintainState: true,
              title: Text(e.title.name),
              initiallyExpanded: true,
              children: e.matches.map((f) => f.view()).toList(),
            ),
            if (_competition?.code == e.title.code && _splashing)
              Positioned.fill(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withOpacity(0.7),
                    Theme.of(context).brightness == Brightness.dark ? BlendMode.lighten : BlendMode.multiply,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      ),
      ExpansionTile(
        title: Text('Competitions'),
        children: widget.competitions.competitions
            .map(
              (Competitions e) => e.view(),
            )
            .toList(),
      )
    ];
  }

  Stack bottom(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        dropDown(context),
      ],
    );
  }

  DropdownButton<Competition> dropDown(BuildContext context) {
    return DropdownButton<Competition>(
      isExpanded: true,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      value: _competition,
      underline: SizedBox(),
      dropdownColor: Theme.of(context).colorScheme.primary,
      items: getTodaySubPhases
          .map(
            (GeneralStageWithMatchesData<Competition> e) => DropdownMenuItem<Competition>(
              value: e.title,
              child: Card(
                color: Theme.of(context).colorScheme.primary,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppFileImageViewer(
                        url: context.watch<AppState>().exchangeCrest(e.title.emblem),
                        color: elbrem.contains(e.title.code) ? Theme.of(context).colorScheme.background.transform(true) : null,
                      ),
                    ),
                    Gap(20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.title.name),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {});
        _competition = value;
        scrollToTile(value);
      },
    );
  }

  BuildContext? _getContext(GlobalKey targetKey) {
    BuildContext? currentContext = targetKey.currentContext;
    return currentContext;
  }

  void scrollToTile(Competition? value) {
    GlobalKey? globalKey = value?.globalKey;
    if (globalKey == null) return;
    BuildContext? currentContext = _getContext(globalKey);
    if (currentContext == null) {
      logg(value?.code, name: 'CURRENTCONTEXT is NULL');
      return;
    }
    setState(() {
      _splashing = true;
    });
    Scrollable.ensureVisible(
      currentContext,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    ).then((value) {
      Future.delayed(
        Duration(milliseconds: 400),
        () {
          setState(() {
            _splashing = false;
          });
        },
      );
    });
  }

  List<GeneralStageWithMatchesData<Competition>> get getTodaySubPhases {
    return GeneralStageWithMatches<Competition>(
      getTitle: (data) => data.competition,
      matches: widget.today.matches,
      test: (prev, last) => prev.code == last.code,
    ).subphases;
  }
}

class AppFileImageViewer extends StatelessWidget {
  const AppFileImageViewer({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.color,
    this.boxFit = BoxFit.cover,
    this.blendMode,
  });
  final String? url;
  final BlendMode? blendMode;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit boxFit;
  @override
  Widget build(BuildContext context) {
    return Image(
      image: _imageSource(url),
      width: width, color: color,
      height: height, fit: boxFit,

      loadingBuilder: (context, child, loadingProgress) {
        var loading = loadingProgress;
        if (loading == null) return child;
        int? expectedTotalBytes = loading.expectedTotalBytes;
        if (expectedTotalBytes == null) return child;
        return CircularProgressIndicator(
          value: loading.cumulativeBytesLoaded / expectedTotalBytes,
        );
      },
      alignment: Alignment.center,

      colorBlendMode: blendMode,
      // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => wasSynchronouslyLoaded ? child : CupertinoActivityIndicator(),
      errorBuilder: (context, error, stackTrace) {
        log(error.toString());
        return Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 50,
        );
      },
    );
  }

  ImageProvider<Object> _imageSource(String? e) {
    var img = e;
    if (img == null) return AssetImage('assets/logo-light.png');
    if (img.endsWith('.svg')) {
      return Svg(img, source: SvgSource.file);
    } else {
      return FileImage(File(img));
    }
  }
}

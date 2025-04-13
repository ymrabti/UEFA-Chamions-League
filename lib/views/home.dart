import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:botola_max/lib.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
    this.competitions,
    this.today, {
    super.key,
  });
  final BotolaHappening today;
  final ElBotolaChampionsList competitions;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Competition? _competition;

  bool _splashing = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldBuilder(
        appBar: AppBar(
          title: Text('Botola Max'),
          leading: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/max-botola-logo.png',
              ),
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
        body: bodyLV(),
      ),
    );
  }

  Widget bodyLV() {
    return Column(
      children: [
        Container(color: Theme.of(context).colorScheme.primary, child: bottom()),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: children(),
            ),
          ),
        ),
      ],
    );
  }

  Builder bodyCSV() {
    return Builder(builder: (context) {
      List<Widget> chuldren = children();
      return CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            //   expandedHeight: 200.0,
            leading: Builder(
              builder: (context) {
                String? comp = _competition?.emblem;
                if (comp == null) {
                  return SizedBox();
                } else {
                  bool condition = elbrem.contains(_competition?.code);
                  Color bg = Theme.of(context).colorScheme.background;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppFileImageViewer(
                      url: (comp),
                      color: condition ? bg.invers(true) : null,
                    ),
                  );
                }
              },
            ),
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: dropDown(),
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
      );
    });
  }

  List<Widget> children() {
    List<TheCompetition> competitions = widget.competitions.competitions;
    return [
      ExpansionTile(
        title: Text('Available Competitions'),
        initiallyExpanded: true,
        maintainState: true,
        children: [for (TheCompetition comp in competitions) comp.view()],
      ),
      for (var compMatches in getTodaySubPhases) _matchToday(compMatches),
    ];
  }

  Builder _matchToday(GeneralStageWithMatchesData<Competition> e) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              ExpansionTile(
                key: e.title.globalKey,
                maintainState: true,
                title: Text(e.title.name),
                initiallyExpanded: !e.allFinished,
                children: e.matches.map((f) => f.view).toList(),
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
        );
      },
    );
  }

  Builder bottom() {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            /* ClipPath(
              clipper: Customshape(),
              child: Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.primary,
              ),
            ), */
            dropDown(),
          ],
        );
      },
    );
  }

  Builder dropDown() {
    return Builder(builder: (context) {
      return DropdownButton<Competition>(
        isExpanded: true,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
        value: _competition,
        enableFeedback: true,
        hint: Text('Select a competition'),
        elevation: 0,
        underline: SizedBox(),
        dropdownColor: Theme.of(context).colorScheme.primary,
        items: getTodaySubPhases
            .map(
              (e) => DropdownMenuItem<Competition>(
                value: e.title,
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppFileImageViewer(
                          url: (e.title.emblem),
                          color: elbrem.contains(e.title.code) ? Theme.of(context).colorScheme.background.invers(true) : null,
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
    });
  }

  void _getScroll(GlobalKey key) {
    RenderObject? renderBox = key.currentContext?.findRenderObject();
    if (renderBox == null) return;
    if (renderBox is! RenderBox) return;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    logg('Item position: $position');
  }

  BuildContext? _getContext(GlobalKey targetKey) {
    BuildContext? currentContext = targetKey.currentContext;
    return currentContext;
  }

  void scrollToTile(Competition? value) {
    GlobalKey? globalKey = value?.globalKey;
    if (globalKey == null) return;
    BuildContext? currentContext = _getContext(globalKey);
    _getScroll(globalKey);
    if (currentContext == null) {
      logg(value?.code, name: 'CURRENTCONTEXT is NULL');
      return;
    }
    _splashing = true;
    setState(() {});
    Scrollable.ensureVisible(
      currentContext,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    ).then((value) {
      Future.delayed(
        Duration(milliseconds: 400),
        () {
          _splashing = false;
          setState(() {});
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

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body:
      _AppStateWrapper(
          child: widget
      ),
    );
  }
}

class _AppStateWrapper extends InheritedWidget {

//  final  _blocMainMap

  const _AppStateWrapper({
    Key key,
    @required Widget child,
  })
      : assert(child != null),
        super(key: key, child: child);

  static _AppStateWrapper of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(_AppStateWrapper) as _AppStateWrapper;
  }

  @override
  bool updateShouldNotify(_AppStateWrapper old) {
    return true;
  }
}

//
//class _MainMapStateProvider extends InheritedWidget {
//
//  final MainMapBloc mainMapBloc;
//
//  const _MainMapStateProvider({
//    Key key,
//    @required Widget child,
//    @required this.mainMapBloc
//  })
//      : assert(child != null),
//        super(key: key, child: child);
//
//  static _MainMapStateProvider of(BuildContext context) {
//    return context.inheritFromWidgetOfExactType(
//        _MainMapStateProvider) as _MainMapStateProvider;
//  }
//
//  @override
//  bool updateShouldNotify(_MainMapStateProvider old) {
//    return true;
//  }
//}

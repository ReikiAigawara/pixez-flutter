import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixez/component/illust_card.dart';
import 'package:pixez/page/hello/new/new_illust/bloc/bloc.dart';

class NewIllustPage extends StatefulWidget {
  @override
  _NewIllustPageState createState() => _NewIllustPageState();
}

class _NewIllustPageState extends State<NewIllustPage> {
  Completer<void> _refreshCompleter, _loadCompleter;
  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => NewIllustBloc()..add(FetchEvent()),
      child: BlocListener<NewIllustBloc, NewIllustState>(listener: (context, state) {
        if (state is DataNewIllustState) {
          _loadCompleter?.complete();
          _loadCompleter = Completer();
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      }, child: BlocBuilder<NewIllustBloc, NewIllustState>(
        builder: (context, state) {
          if (state is DataNewIllustState)
            return EasyRefresh(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: state.illusts.length,
                itemBuilder: (context, index) {
                  return IllustCard(state.illusts[index]);
                },
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              ),
              onRefresh: () async {
                BlocProvider.of<NewIllustBloc>(context).add(FetchEvent());
                return _refreshCompleter.future;
              },
              onLoad: () async {
                BlocProvider.of<NewIllustBloc>(context)
                    .add(LoadMoreEvent(state.nextUrl, state.illusts));
                return _loadCompleter.future;
              },
            );
          return Container();
        },
      )),
    );
  }
}

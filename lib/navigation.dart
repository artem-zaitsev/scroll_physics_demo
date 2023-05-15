import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_play/main.dart';
import 'package:scroll_play/physics.dart';
import 'package:scroll_play/scroll_play.dart';
import 'package:scroll_play/simulation_scroll_play.dart';

final phs = [
  'Clear',
  'Momentum',
  'UserOffset',
  'Boundary',
  'Ballistic',
];

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainPage(),
      routes: [
        GoRoute(
          path: 'clear',
          name: phs[0],
          builder: (context, state) => ScrollPlay(
            physics: (v) => ScrollConfiguration.of(context).getScrollPhysics(context),
            min: 0,
            max: 1,
            defValue: .5,
            clear: true,
          ),
        ),
        GoRoute(
          path: 'momentum',
          name: phs[1],
          builder: (context, state) => ScrollPlay(
            physics: (v) => MomentumScrollPhysics(valueMagnifier: v).applyTo(BouncingScrollPhysics()),
            min: 0,
            max: 1,
            defValue: .5,
          ),
        ),
        GoRoute(
          path:'user_offset',
          name: phs[2],
          builder: (context, state) => ScrollPlay(
            physics: (v) => UserOffsetScrollPhysics(offsetMafnifier: v).applyTo(BouncingScrollPhysics()),
            min: -100,
            max: 100,
            defValue: 5,
          ),
        ),
        GoRoute(
          path: 'boundary',
          name: phs[3],
          builder: (context, state) => ScrollPlay(
            physics: (v) => BoundaryConditionScrollPhysics(valueMagnifier: v),
            min: -1,
            max: 1,
            defValue: 0,
          ),
        ),
        GoRoute(
          path: 'ballistic',
          name: phs[4],
          builder: (context, state) => const SimulationScrollPlay(),
        ),
      ],
    ),
  ],
);

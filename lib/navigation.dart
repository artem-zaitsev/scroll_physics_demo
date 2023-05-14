import 'package:go_router/go_router.dart';
import 'package:scroll_play/main.dart';
import 'package:scroll_play/physics.dart';
import 'package:scroll_play/scroll_play.dart';
import 'package:scroll_play/simulation_scroll_play.dart';

final phs = [
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
          path: 'momentum',
          name: phs[0],
          builder: (context, state) => ScrollPlay(
            physics: (v) => MomentumScrollPhysics(valueMagnifier: v),
            min: 0,
            max: 100,
            defValue: 5,
          ),
        ),
        GoRoute(
          path:'user_offset',
          name: phs[1],
          builder: (context, state) => ScrollPlay(
            physics: (v) => UserOffsetScrollPhysics(offsetMafnifier: v),
            min: 0,
            max: 100,
            defValue: 5,
          ),
        ),
        GoRoute(
          path: 'boundary',
          name: phs[2],
          builder: (context, state) => ScrollPlay(
            physics: (v) => BoundaryConditionScrollPhysics(valueMagnifier: v),
            min: 0,
            max: 100,
            defValue: 5,
          ),
        ),
        GoRoute(
          path: 'ballistic',
          name: phs[3],
          builder: (context, state) => const SimulationScrollPlay(),
        ),
      ],
    ),
  ],
);

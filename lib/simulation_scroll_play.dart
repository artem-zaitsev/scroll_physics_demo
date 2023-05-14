import 'package:flutter/material.dart';
import 'package:scroll_play/physics.dart';
import 'package:scroll_play/scroll_data.dart';

class SimulationScrollPlay extends StatefulWidget {
  const SimulationScrollPlay({
    super.key,
  });

  @override
  State<SimulationScrollPlay> createState() => _SimulationScrollPlayState();
}

class _SimulationScrollPlayState extends State<SimulationScrollPlay> {
  late ScrollPhysics _physics = BallisticScrollPhysics();
  late double _mass = 1;
  late double _drag = 1;
  late double _stiffness = 1;
  late double _damping = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _Body(
              physics: _physics,
            ),
          ),
          Column(
            children: [
              Text('Drag: $_drag'),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text('min: 0'),
                  Expanded(
                    child: Slider(
                      value: _drag,
                      min: 0,
                      max: 100,
                      label: '$_drag',
                      onChanged: (double value) {
                        _drag = value;
                        _rebuildPhysics();
                        setState(() {});
                      },
                    ),
                  ),
                  Text('max: 100'),
                ],
              ),
              Text('Stiffness: $_stiffness'),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('min: 0'),
                  Slider(
                    value: _stiffness,
                    min: 0,
                    max: 1,
                    onChanged: (double value) {
                      _stiffness = value;
                      _rebuildPhysics();
                      setState(() {});
                    },
                  ),
                  Text('max: 1'),
                ],
              ),
              Text('Mass: $_mass'),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('min: 0'),
                  Slider(
                    value: _mass,
                    min: 0,
                    max: 100,
                    onChanged: (double value) {
                      _mass = value;
                      _rebuildPhysics();
                      setState(() {});
                    },
                  ),
                  Text('max: 100'),
                ],
              ),
              Text('Damping: $_damping'),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('min: -1'),
                  Slider(
                    value: _damping,
                    min: -1,
                    max: 1,
                    onChanged: (double value) {
                      _damping = value;
                      _rebuildPhysics();
                      setState(() {});
                    },
                  ),
                  Text('max: 1'),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void _rebuildPhysics() {
    _physics = BallisticScrollPhysics(
      damping: _damping,
      mass: _mass,
      drag: _drag,
      stiffness: _stiffness,
    );
  }
}

class _Body extends StatelessWidget {
  final ScrollPhysics physics;
  const _Body({
    required this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics,
      itemBuilder: (context, index) => Text(listData[index].name),
      itemCount: listData.length,
    );
  }
}

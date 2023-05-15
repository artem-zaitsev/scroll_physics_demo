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
  late ScrollPhysics _physics =
      BallisticScrollPhysics().applyTo(BouncingScrollPhysics());
  late double _mass = 0.5;
  late double _drag = 0.2;
  late double _stiffness = 1;
  late double _damping = 1;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          switch (_loading) {
            true => Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            _ => Expanded(
                child: _Body(
                  physics: _physics,
                ),
              ),
          },
          Column(
            children: [
              Text('Drag: $_drag'),
              SliderWithLabels(
                min: 0,
                max: 1,
                value: _drag,
                onChanged: (value) {
                  _drag = value;
                  _rebuildPhysics();
                },
              ),
              Text('Stiffness: $_stiffness'),
              SliderWithLabels(
                min: 0,
                max: 1000,
                value: _stiffness,
                onChanged: (value) {
                  _stiffness = value;
                  _rebuildPhysics();
                },
              ),
              Text('Mass: $_mass'),
              SliderWithLabels(
                min: 0,
                max: 10,
                value: _mass,
                onChanged: (value) {
                  _mass = value;
                  _rebuildPhysics();
                },
              ),
              Text('Damping: $_damping'),
              SliderWithLabels(
                min: 0,
                max: 3,
                value: _damping,
                onChanged: (value) {
                  _damping = value;
                  _rebuildPhysics();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _rebuildPhysics() async {
    _physics = BouncingScrollPhysics();
    _loading = true;
    setState(() {});
    await Future.delayed(Duration(milliseconds: 200));
    _loading = false;
    _physics = BallisticScrollPhysics(
      damping: _damping,
      mass: _mass,
      drag: _drag,
      stiffness: _stiffness,
    ).applyTo(BouncingScrollPhysics());
    setState(() {});
  }
}

class _Body extends StatelessWidget {
  final ScrollPhysics physics;
  const _Body({
    required this.physics,
  });

  @override
  Widget build(BuildContext context) {
    print('DEVVV: ph: ${physics.hashCode}');
    return ListView.builder(
      physics: physics,
      itemBuilder: (context, index) => Text(listData[index].name),
      itemCount: listData.length,
    );
  }
}

class SliderWithLabels extends StatelessWidget {
  final double min, max, value;
  final void Function(double) onChanged;
  const SliderWithLabels(
      {super.key,
      required this.min,
      required this.max,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('min: $min'),
        Expanded(
            child: Slider(
          value: value,
          min: min,
          max: max,
          onChanged: (double value) {
            onChanged(value);
          },
        )),
        Text('max: $max'),
      ],
    );
  }
}

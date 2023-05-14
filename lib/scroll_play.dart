import 'package:flutter/material.dart';
import 'package:scroll_play/scroll_data.dart';

class ScrollPlay extends StatefulWidget {
  final ScrollPhysics Function(double) physics;
  final double defValue, min, max;
  const ScrollPlay({
    super.key,
    required this.physics,
    required this.defValue,
    required this.min,
    required this.max,
  });

  @override
  State<ScrollPlay> createState() => _ScrollPlayState();
}

class _ScrollPlayState extends State<ScrollPlay> {
  late ScrollPhysics _physics = widget.physics(widget.defValue);
  late double _value = widget.defValue;

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Current value: $_value'),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('min: ${widget.min}'),
                  Expanded(
                    child: Slider(
                      value: _value,
                      min: widget.min,
                      max: widget.max,
                      label: _value.toString(),
                      onChanged: (double value) {
                        _value = value;
                        _physics = widget.physics(value);
                        setState(() {});
                      },
                    ),
                  ),
                  Text('max: ${widget.max}'),
                ],
              ),
            ],
          )
        ],
      ),
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

import 'package:flutter/material.dart';
import 'package:scroll_play/scroll_data.dart';

class ScrollPlay extends StatefulWidget {
  final ScrollPhysics Function(double) physics;
  final double defValue, min, max;
  final bool clear;
  const ScrollPlay({
    super.key,
    required this.physics,
    required this.defValue,
    required this.min,
    required this.max,
    this.clear = false,
  });

  @override
  State<ScrollPlay> createState() => _ScrollPlayState();
}

class _ScrollPlayState extends State<ScrollPlay> {
  late ScrollPhysics _physics =
      widget.physics(widget.defValue);
  late double _value = widget.defValue;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          switch (isLoading) {
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
          if (!widget.clear) Column(
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
                      onChanged: (double value) async {
                        _value = value;
                        _physics = NeverScrollableScrollPhysics();

                        isLoading = true;
                        setState(() {});
                        await Future.delayed(Duration(milliseconds: 100));
                        _physics = widget
                            .physics(value);
                        isLoading = false;
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
    print('DEVVV: ph: ${physics.hashCode}');
    return ListView.builder(
      physics: physics,
      itemBuilder: (context, index) => Text(listData[index].name),
      itemCount: listData.length,
    );
  }
}

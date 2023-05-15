import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

abstract interface class ParametrizedPhysics {
  double get min;
  double get max;
}

class UserOffsetScrollPhysics extends ScrollPhysics
    implements ParametrizedPhysics {
  final double offsetMafnifier;
  const UserOffsetScrollPhysics({this.offsetMafnifier = 1, super.parent});

  @override
  UserOffsetScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return UserOffsetScrollPhysics(
        parent: buildParent(ancestor), offsetMafnifier: offsetMafnifier);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    print(
      'DEVvvv: applyPhysicsToUserOffset minExtent: ${position.minScrollExtent}, maxExtent: ${position.maxScrollExtent}, offset: $offset, pix: ${position.pixels})',
    );
    print("Current param: $offsetMafnifier");
    if (!position.outOfRange) {
      return offsetMafnifier * offset;
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  // TODO: implement max
  double get max => 100;

  @override
  // TODO: implement min
  double get min => -100;
}

class BoundaryConditionScrollPhysics extends ScrollPhysics
    implements ParametrizedPhysics {
  final double valueMagnifier;
  const BoundaryConditionScrollPhysics({this.valueMagnifier = 1, super.parent});

  @override
  BoundaryConditionScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BoundaryConditionScrollPhysics(
        parent: buildParent(ancestor), valueMagnifier: valueMagnifier);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    print(
      'DEVvvv: boundary: value: $value, px: ${position.pixels})',
    );

    print("Current param: $valueMagnifier");

    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      print('underscroll');
      // Underscroll.
      return valueMagnifier * (value - position.pixels);
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      print('overscroll');
      // Overscroll.
      return valueMagnifier * (value - position.pixels);
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      print('// Hit top edge');
      return valueMagnifier * (value - position.minScrollExtent);
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      print('// Hit bottom edge.');
      return valueMagnifier * (value - position.maxScrollExtent);
    }

    return 0;
  }

  @override
  // TODO: implement max
  double get max => -10;

  @override
  // TODO: implement min
  double get min => 10;
}

class BallisticScrollPhysics extends ScrollPhysics {
  final double damping, mass, stiffness, drag;
  const BallisticScrollPhysics({
    this.damping = 1,
    this.mass = 100,
    this.stiffness = 1,
    this.drag = 0.2,
    super.parent,
  });

  @override
  BallisticScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BallisticScrollPhysics(
        parent: buildParent(ancestor),
        damping: damping,
        mass: mass,
        stiffness: stiffness,
        drag: drag);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    print(
      "devvv simulation: direction: ${position.axisDirection}, vel: ${velocity}, out: ${position.outOfRange} ",
    );

    print(
        'devvv params: drag: $drag, stf: $stiffness, mass: $mass, damp: $damping');

    if (position.outOfRange) {
      return ScrollSpringSimulation(
        SpringDescription.withDampingRatio(
            ratio: damping, mass: mass, stiffness: stiffness),
        position.pixels,
        position.pixels >= position.maxScrollExtent
            ? position.maxScrollExtent
            : position.minScrollExtent,
        velocity,
      );
    }
    return FrictionSimulation(drag, position.pixels, velocity);
  }
}

class MomentumScrollPhysics extends ScrollPhysics
    implements ParametrizedPhysics {
  final double valueMagnifier;
  const MomentumScrollPhysics({this.valueMagnifier = 1, super.parent});

  @override
  MomentumScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return MomentumScrollPhysics(
        parent: buildParent(ancestor), valueMagnifier: valueMagnifier);
  }

  @override
  double carriedMomentum(double existingVelocity) {
    print("Current param: $valueMagnifier, $existingVelocity");
    return valueMagnifier * existingVelocity;
  }

  @override
  // TODO: implement max
  double get max => 0;

  @override
  // TODO: implement min
  double get min => 100;
}

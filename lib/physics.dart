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
    return UserOffsetScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    print(
      'DEVvvv: applyPhysicsToUserOffset minExtent: ${position.minScrollExtent}, maxExtent: ${position.maxScrollExtent}, offset: $offset, pix: ${position.pixels})',
    );
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
    return BoundaryConditionScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    print(
      'DEVvvv: boundary: value: $value, px: ${position.pixels})',
    );

    if (position.atEdge) {
      return valueMagnifier * value;
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
    this.mass = 1,
    this.stiffness = 1,
    this.drag = 1,
    super.parent,
  });

  @override
  BallisticScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BallisticScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    print(
      "devvv simulation: direction: ${position.axisDirection}, vel: ${velocity}, out: ${position.outOfRange} ",
    );

    if (position.outOfRange) {
      return ScrollSpringSimulation(
        const SpringDescription(damping: 0.5, mass: 100, stiffness: 1),
        position.pixels,
        position.pixels >= position.maxScrollExtent
            ? position.pixels - 100
            : position.pixels + 100,
        velocity,
      );
    }
    return FrictionSimulation(0.2, position.pixels, velocity);
  }
}

class MomentumScrollPhysics extends ScrollPhysics
    implements ParametrizedPhysics {
  final double valueMagnifier;
  const MomentumScrollPhysics({this.valueMagnifier = 1, super.parent});

  @override
  MomentumScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return MomentumScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double carriedMomentum(double existingVelocity) {
    return valueMagnifier * existingVelocity;
  }

  @override
  // TODO: implement max
  double get max => 0;

  @override
  // TODO: implement min
  double get min => 100;
}

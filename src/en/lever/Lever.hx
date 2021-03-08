package en.lever;

import en.lever.states.LeverPulledLeftState;
import en.lever.states.LeverPulledRightState;
import en.lever.states.LeverLockedState;

enum LeverDirection {
	Left;
	Right;
}

class Lever extends Trigger {

	public var direction = LeverDirection.Right;
	public var locked = false;

	private var machine: StateMachine<Lever>;

	public function new(x, y) {
		super(x, y);
		hasCollision = false;
		machine = new StateMachine<Lever>(this);
		machine.addState(new LeverLockedState());
		machine.addState(new LeverPulledLeftState());
		machine.addState(new LeverPulledRightState());
		machine.onStateChanged = (stateName) -> {
			var state = stateName.split(".").pop();
			debug(state);
		}
		addGraphcisSquare(Color.pickUniqueColorFor("lever"));
	}

	override function update() {
		super.update();
		machine.update(tmod);
	}

	override function interact(from: Entity) {
		super.interact(from);
		if (direction == Right) {
			direction = Left;
		} else {
			direction = Right;
		}
	}
}

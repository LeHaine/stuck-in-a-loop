package en.gate;

import en.gate.states.GateClosedState;
import en.gate.states.GateOpenedState;

class Gate extends Actionable {

	public var opened: Bool;
	public var alignment: Alignment;

	private var machine: StateMachine<Gate>;

	public function new(cx, cy, opened, alignment, optional, reactionId) {
		super(cx, cy, optional, -1, reactionId);
		this.opened = opened;
		this.alignment = alignment;
		machine = new StateMachine<Gate>(this);
		machine.addState(new GateOpenedState());
		machine.addState(new GateClosedState());
		machine.onStateChanged = (stateName) -> {
			#if debug
			var state = stateName.split(".").pop();
			debug(state);
			#end
		}

		determineSprite();
		active = false;
		//	addGraphcisSquare(Color.pickUniqueColorFor("gate"));
	}

	public function determineSprite() {
		zPriorityOffset = 0;
		if (alignment == Horizontal) {
			if (opened) {
				spr.set("gateOpened_h");
			} else {
				spr.set("gateClosed_h");
			}
		} else {
			if (opened) {
				spr.set("gateOpened_v");
				zPriorityOffset = -99;
			} else {
				spr.set("gateClosed_v");
			}
		}
	}

	override function update() {
		super.update();
		machine.update(tmod);
	}

	override function react() {
		super.react();
		opened = !opened;
		completed = true;
	}
}

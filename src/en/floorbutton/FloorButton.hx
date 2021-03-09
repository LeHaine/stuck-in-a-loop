package en.floorbutton;

import en.floorbutton.states.FloorButtonDownState;
import en.floorbutton.states.FloorButtonUpState;

class FloorButton extends Actionable {

	public var sticks: Bool;
	public var entityOnMe: Entity;

	private var machine: StateMachine<FloorButton>;

	public function new(x, y, sticks, optional, actionId) {
		super(x, y, optional, actionId);
		this.sticks = sticks;
		active = false;
		machine = new StateMachine<FloorButton>(this);
		machine.addState(new FloorButtonDownState());
		machine.addState(new FloorButtonUpState());
		machine.onStateChanged = (stateName) -> {
			#if debug
			debugFSM(stateName);
			#end
		}
		zPriorityOffset = -99;
	}

	override function update() {
		super.update();
		machine.update(tmod);
	}

	public function getEntityStandingOnMe() {
		for (entity in Entity.ALL) {
			if (entity != this && atEntity(entity)) {
				return entity;
			}
		}
		return null;
	}
}

package en.floorbutton;

import en.floorbutton.states.FloorButtonDownState;
import en.floorbutton.states.FloorButtonUpState;

class FloorButton extends Actionable {

	public var sticks: Bool;
	public var entityOnMe: Entity;

	private var machine: StateMachine<FloorButton>;

	public function new(x, y, sticks, optional, actionIds, reactionIds) {
		super(x, y, actionIds, reactionIds, optional);
		this.sticks = sticks;
		active = false;
		hasCollision = false;
		machine = new StateMachine<FloorButton>(this);
		machine.addState(new FloorButtonDownState());
		machine.addState(new FloorButtonUpState());
		machine.onStateChanged = (stateName) -> {
			#if debug
			debugFSM(stateName);
			#end
		}
		zPriorityOffset = -13;
	}

	override function update() {
		super.update();
		machine.update(tmod);
	}

	override function react() {
		super.react();
		sticks = !sticks;
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

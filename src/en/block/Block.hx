package en.block;

import en.block.states.BlockTeleportingState;
import en.block.states.BlockLockedInState;
import en.block.states.BlockStationaryState;
import en.block.states.BlockMovingState;

class Block extends Actionable {

	public var goal: LPoint;

	public var pushX: Int;
	public var pushY: Int;
	public var moveSpeed = 0.02;
	public var teleporting = false;

	private var machine: StateMachine<Block>;

	public function new(cx, cy, optional, actionId, reactionId, goal: LPoint) {
		super(cx, cy, actionId, reactionId, optional);
		this.goal = goal;
		pivotY = 0.5;
		yr = 0.5;
		machine = new StateMachine<Block>(this);
		machine.addState(new BlockLockedInState());
		machine.addState(new BlockTeleportingState());
		machine.addState(new BlockMovingState());
		machine.addState(new BlockStationaryState());
		machine.onStateChanged = (stateName) -> {
			#if debug
			debugFSM(stateName);
			#end
		}
		labelText = Lang.t._("Push\nHold Shift for big push");
		spr.set("block");
	}

	override function update() {
		super.update();
		machine.update(tmod);
	}

	override function interact(from: Entity) {
		super.interact(from);
		if (pushX == 0 && pushY == 0) {
			push(from);
		}
	}

	override function secondaryInteract(from: Entity) {
		super.secondaryInteract(from);
		if (pushX == 0 && pushY == 0) {
			push(from, 2);
		}
	}

	public function push(from: Entity, distance = 1) {
		pushX = -caseDirToX(from) * distance;
		if (pushX == 0) {
			pushY = -caseDirToY(from) * distance;
		} else {
			pushY = 0;
		}
	}

	override public function setPosCase(x: Int, y: Int) {
		setExtraCollision(false);
		teleporting = true;
		super.setPosCase(x, y);
		yr = 0.5;
		setExtraCollision(true);
	}

	private inline function caseDirToX(to: Entity) return if (to.cx < cx) -1 else if (to.cx > cx) 1 else 0;

	private inline function caseDirToY(to: Entity) return if (to.cy < cy) -1 else if (to.cy > cy) 1 else 0;
}

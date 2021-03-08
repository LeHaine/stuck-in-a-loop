package en.block;

import en.block.states.BlockLockedInState;
import en.block.states.BlockStationaryState;
import en.block.states.BlockMovingState;

class Block extends Actionable {

	public var goal: LPoint;

	public var pushX: Int;
	public var pushY: Int;
	public var moveSpeed = 0.02;

	private var machine: StateMachine<Block>;

	public function new(cx, cy, optional, actionId, reactionId, goal: LPoint) {
		super(cx, cy, optional, actionId, reactionId);
		this.goal = goal;

		machine = new StateMachine<Block>(this);
		machine.addState(new BlockLockedInState());
		machine.addState(new BlockMovingState());
		machine.addState(new BlockStationaryState());
		machine.onStateChanged = (stateName) -> {
			#if debug
			var state = stateName.split(".").pop();
			debug(state);
			#end
		}
		labelText = Lang.t._("Push");
		addGraphcisSquare(Color.pickUniqueColorFor("block"));
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

	public function push(from: Entity) {
		pushX = -caseDirToX(from);
		pushY = -caseDirToY(from);
	}

	private inline function caseDirToX(to: Entity) return if (to.cx < cx) -1 else if (to.cx > cx) 1 else 0;

	private inline function caseDirToY(to: Entity) return if (to.cy < cy) -1 else if (to.cy > cy) 1 else 0;
}

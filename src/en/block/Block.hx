package en.block;

class Block extends Actionable {

	public var goal: LPoint;

	public function new(cx, cy, optional, actionId, reactionId, goal: LPoint) {
		super(cx, cy, optional, actionId, reactionId);
		this.goal = goal;

		setExtraCollision(true);
		addGraphcisSquare(Color.pickUniqueColorFor("block"));
	}
}

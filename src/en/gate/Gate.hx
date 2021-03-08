package en.gate;

class Gate extends Actionable {

	public var opened: Bool;
	public var alignment: Alignment;

	public function new(cx, cy, opened, alignment, reactionId) {
		super(cx, cy, false, -1, reactionId);
		this.opened = opened;
		this.alignment = alignment;

		setExtraCollision(!opened);
		addGraphcisSquare(Color.pickUniqueColorFor("gate"));
	}

	override function react() {
		super.react();
		opened = !opened;
		setExtraCollision(!opened);
	}
}

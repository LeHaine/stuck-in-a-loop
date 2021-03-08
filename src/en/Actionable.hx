package en;

class Actionable extends Interactable {

	public static var ALL: Array<Actionable> = [];

	public var completed = false;
	public var optionial = false;
	public var actionId = -1;
	public var reactionId = -1;

	public function new(x, y, optional = false, actionId = -1, reactionId = -1) {
		super(x, y);
		this.optionial = optional;
		this.actionId = actionId;
		this.reactionId = reactionId;
		ALL.push(this);
	}

	override function interact(from: Entity) {
		super.interact(from);
		if (actionId == -1) {
			return;
		}
		for (actionable in ALL) {
			if (actionable.reactionId == actionId) {
				actionable.react();
			}
		}
	}

	public function react() {}

	override function dispose() {
		super.dispose();
		ALL.remove(this);
	}
}

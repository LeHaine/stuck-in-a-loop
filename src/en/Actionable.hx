package en;

class Actionable extends Interactable {

	public static var ALL: Array<Actionable> = [];

	public var completed = false;
	public var optionial = true;
	public var actionIds: Array<Int>;
	public var reactionIds: Array<Int>;

	public function new(x, y, actionIds, reactionIds, optional = true) {
		super(x, y);
		this.optionial = optional;
		this.actionIds = actionIds;
		this.reactionIds = reactionIds;
		ALL.push(this);
	}

	override function interact(from: Entity) {
		super.interact(from);
		if (actionIds == null || actionIds.length == 0) {
			return;
		}
		for (actionable in ALL) {
			for (actionId in actionIds) {
				if (actionable.reactionIds != null && actionable.reactionIds.contains(actionId)) {
					actionable.react();
				}
			}
		}
	}

	public function react() {}

	override function dispose() {
		super.dispose();
		ALL.remove(this);
	}
}

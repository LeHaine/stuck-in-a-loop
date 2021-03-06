package en.floorbutton.states;

class FloorButtonDownState extends FloorButtonState {

	private var totalClicks = 0;
	private var shouldPopUpNext = false;
	private var waitingForToggle = false;
	private var lastEntity: Entity;

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.entityOnMe != null || waitingForToggle;
	}

	override function begin() {
		super.begin();
		waitingForToggle = context.sticks;
		lastEntity = context.entityOnMe;
		context.interact(lastEntity);
		context.spr.set("floorbuttonDown");
	}

	override function update(tmod: Float) {
		super.update(tmod);
		if (waitingForToggle) {
			if (context.entityOnMe == null) {
				shouldPopUpNext = true;
			} else if (shouldPopUpNext) {
				shouldPopUpNext = false;
				waitingForToggle = false;
			}
		}
	}

	override function end() {
		super.end();
		context.interact(lastEntity);
		lastEntity = null;
		Assets.SLIB.floorbutton0().playOnGroup(Const.HERO_ACTION, 1);
	}
}

package en.floorbutton.states;

class FloorButtonDownState extends FloorButtonState {

	private var totalClicks = 0;
	private var shouldPopUpNext = false;
	private var waitingForToggle = false;

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.entityOnMe != null || waitingForToggle;
	}

	override function begin() {
		super.begin();
		waitingForToggle = context.sticks;
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
}

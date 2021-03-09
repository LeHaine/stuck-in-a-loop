package en.floorbutton.states;

class FloorButtonUpState extends FloorButtonState {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.entityOnMe == null;
	}

	override function begin() {
		super.begin();
		context.spr.set("floorbuttonUp");
	}
}

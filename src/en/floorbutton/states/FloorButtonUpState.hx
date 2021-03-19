package en.floorbutton.states;

class FloorButtonUpState extends FloorButtonState {

	var initial = true;

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.entityOnMe == null;
	}

	override function begin() {
		super.begin();
		context.spr.set("floorbuttonUp");
		if (initial) {
			initial = !initial;
		} else {
			context.completed = !context.completed;
		}
		Assets.SLIB.floor_button0().playOnGroup(Const.HERO_ACTION, 1);
	}

	override function end() {
		super.end();
		context.completed = !context.completed;
	}
}

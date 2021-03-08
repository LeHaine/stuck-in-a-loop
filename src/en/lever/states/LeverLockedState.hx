package en.lever.states;

class LeverLockedState extends State<Lever> {

	public function new() {
		super();
	}

	override public function reason() {
		return context.locked;
	}

	override function begin() {
		super.begin();
		context.active = false;
	}

	override function end() {
		super.end();
		context.active = true;
	}
}

package en.lever.states;

class LeverPulledRightState extends State<Lever> {

	public function new() {
		super();
	}

	override public function reason() {
		return context.direction == Right;
	}

	override function begin() {
		super.begin();
		context.labelText = Lang.t._("Pull left");
	}
}

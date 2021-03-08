package en.lever.states;

class LeverPulledLeftState extends State<Lever> {

	public function new() {
		super();
	}

	override public function reason() {
		return context.direction == Left;
	}

	override function begin() {
		super.begin();
		context.labelText = Lang.t._("Pull right");
	}
}
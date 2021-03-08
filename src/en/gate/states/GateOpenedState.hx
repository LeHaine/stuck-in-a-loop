package en.gate.states;

class GateOpenedState extends State<Gate> {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.opened;
	}

	override function begin() {
		super.begin();
		context.setExtraCollision(false);
	}
}

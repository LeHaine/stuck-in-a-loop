package en.floorbutton.states;

class FloorButtonState extends State<FloorButton> {

	public function new() {
		super();
	}

	override function update(tmod: Float) {
		super.update(tmod);
		context.entityOnMe = context.getEntityStandingOnMe();
	}
}

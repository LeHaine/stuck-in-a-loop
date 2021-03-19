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
		context.spr.set("leverRight");
	}

	override function end() {
		super.end();
		Assets.SLIB.lever0().playOnGroup(Const.HERO_ACTION, 1);
	}
}

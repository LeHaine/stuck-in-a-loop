package en.block.states;

class BlockStationaryState extends State<Block> {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.pushX == 0 && context.pushY == 0;
	}

	override function begin() {
		super.begin();
		context.setExtraCollision(true);
		trace("stationary: begin");
	}

	override function end() {
		super.end();
		trace("stationary: end");
		context.setExtraCollision(false);
	}
}

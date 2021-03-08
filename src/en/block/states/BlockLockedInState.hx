package en.block.states;

class BlockLockedInState extends State<Block> {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.goal.cx == context.cx && context.goal.cy == context.cy;
	}

	override function begin() {
		super.begin();
		context.active = false;
		context.setExtraCollision(true);
	}
}

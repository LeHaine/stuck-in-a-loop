package en.block.states;

class BlockTeleportingState extends State<Block> {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.teleporting;
	}

	override function begin() {
		super.begin();
		context.dx = 0;
		context.dy = 0;
		context.pushX = 0;
		context.pushY = 0;
		context.teleporting = false;
	}
}

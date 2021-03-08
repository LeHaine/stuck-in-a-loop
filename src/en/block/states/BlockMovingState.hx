package en.block.states;

import hl.I64;

class BlockMovingState extends State<Block> {

	private var goalX: Int;
	private var goalY: Int;

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.pushX != 0 || context.pushY != 0;
	}

	override function begin() {
		super.begin();
		goalX = context.cx + context.pushX;
		goalY = context.cy + context.pushY;
	}

	override function update(tmod: Float) {
		super.update(tmod);
		var speed = context.moveSpeed;
		if (goalX != -1) {
			if (goalX > context.cx) {
				context.dx += speed * tmod;
			}
			if (goalX < context.cx) {
				context.dx -= speed * tmod;
			}

			if (goalX == context.cx) {
				goalX = -1;
				context.pushX = 0;
			}
		}

		if (goalY != -1) {
			if (goalY > context.cy) {
				context.dy += speed * tmod;
			}
			if (goalY < context.cy) {
				context.dy -= speed * tmod;
			}

			if (goalY == context.cy) {
				goalY = -1;
				context.pushY = 0;
			}
		}
	}
}
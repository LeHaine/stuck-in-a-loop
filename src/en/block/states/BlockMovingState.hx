package en.block.states;

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
		var xDir = M.sign(context.pushX);
		var yDir = M.sign(context.pushY);
		var x = context.cx;
		var y = context.cy;
		if (goalX == context.cx && goalY == context.cy) {
			goalX = -1;
			goalY = -1;
			context.pushX = 0;
			context.pushY = 0;
		} else {
			while (x != goalX || y != goalY) {
				if (xDir != 0) {
					x += xDir;
				} else {
					y += yDir;
				}

				if (context.level.hasCollision(x, y)) {
					x -= xDir;
					y -= yDir;
					break;
				}
			}
			goalX = x;
			goalY = y;
		}

		if (goalX != -1 && goalY != -1) {
			context.level.setExtraCollision(goalX, goalY, true);
			context.hasCollision = false;
		} else {
			context.setExtraCollision(true);
		}
		Assets.SLIB.block0().playOnGroup(Const.HERO_ACTION, 1);
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

	override function end() {
		super.end();
		context.hasCollision = true;
	}
}

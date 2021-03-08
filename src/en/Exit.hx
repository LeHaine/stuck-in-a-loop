package en;

class Exit extends Entity {

	public function new(x, y) {
		super(x, y);
		hasCollision = false;
		addGraphcisSquare(Color.pickUniqueColorFor("exit"));
	}

	override function update() {
		super.update();

		if (hero.atEntity(this)) {
			hero.setPosCase(level.startPoint.cx, level.startPoint.cy);
		}
	}
}

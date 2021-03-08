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
			if (isLevelComplete()) {
				game.startNextLevel();
				destroy();
			} else {
				hero.setPosCase(level.startPoint.cx, level.startPoint.cy);
			}
		}
	}

	public function isLevelComplete() {
		for (actionable in Actionable.ALL) {
			if (!actionable.completed && !actionable.optionial) {
				return false;
			}
		}
		return true;
	}
}

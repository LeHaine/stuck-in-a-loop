package en;

class Exit extends Entity {

	public function new(x, y) {
		super(x, y);
		hasCollision = false;
		spr.anim.playAndLoop("portalGreen");
	}

	override function update() {
		super.update();

		// TODO create fsm
		if (isLevelComplete() && spr.groupName != "portalGreen") {
			spr.anim.playAndLoop("portalGreen");
		} else if (!isLevelComplete() && spr.groupName != "portalRed") {
			spr.anim.playAndLoop("portalRed");
		}

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

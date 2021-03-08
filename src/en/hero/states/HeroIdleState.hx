package en.hero.states;

class HeroIdleState extends HeroState {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return true;
	}

	override function begin() {
		super.begin();
	}

	override function update(tmod: Float) {
		super.update(tmod);
		calculateVelocity(tmod);
	}
}

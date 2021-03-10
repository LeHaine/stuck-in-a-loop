package en.hero.states;

class HeroRunState extends HeroState {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.running;
	}

	override function begin() {
		super.begin();
		context.spr.anim.playAndLoop("heroRun");
	}

	override function update(tmod: Float) {
		super.update(tmod);
		calculateVelocity(tmod);
	}
}

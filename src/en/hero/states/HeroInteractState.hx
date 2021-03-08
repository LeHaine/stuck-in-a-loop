package en.hero.states;

class HeroInteractState extends HeroState {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.canPerformInteraction;
	}

	override function begin() {
		super.begin();
		context.interact();
	}
}

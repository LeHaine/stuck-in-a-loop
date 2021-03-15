package en.portal.states;

class PortalLevelCompleteState extends State<Portal> {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return context.isLevelExit && context.isLevelComplete();
	}

	override function begin() {
		super.begin();
		context.spr.anim.playAndLoop('portalGreen');
	}

	override function update(tmod: Float) {
		super.update(tmod);
		if (context.hero.atEntity(context)) {
			context.completeLevel();
		}
	}
}

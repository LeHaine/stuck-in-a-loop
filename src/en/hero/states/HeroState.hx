package en.hero.states;

import dn.DecisionHelper;

class HeroState extends State<Hero> {

	public function new() {
		super();
	}

	private function calculateVelocity(tmod: Float) {
		if (context.hasAffect(Stun)) {
			return;
		}
		var ca = context.ca;

		if (ca.leftDist() > 0) {
			var dist = M.dist(0, 0, ca.lxValue(), ca.lyValue());
			var angle = Math.atan2(-ca.lyValue(), ca.lxValue());

			var speed = context.speed * dist * tmod;
			context.dx += Math.cos(angle) * speed;
			context.dy += Math.sin(angle) * speed;
			context.dir = M.sign(Math.cos(context.ca.leftAngle()));

			if (!context.cd.hasSetS("footstep", 0.35)) {
				Assets.SLIB.footstep0().playOnGroup(Const.HERO_RUN, 0.5);
			}
		} else {
			context.dx *= Math.pow(0.6, tmod);
			context.dy *= Math.pow(0.6, tmod);
		}
	}

	override function update(tmod: Float) {
		super.update(tmod);
		context.checkForInteractable();
	}
}

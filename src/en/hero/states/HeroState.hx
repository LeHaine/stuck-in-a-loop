package en.hero.states;

class HeroState extends State<Hero> {

	public function new() {
		super();
	}

	private function calculateVelocity(tmod: Float) {
		var ca = context.ca;

		if (ca.leftDist() > 0) {
			var dist = M.dist(0, 0, ca.lxValue(), ca.lyValue());
			var angle = Math.atan2(-ca.lyValue(), ca.lxValue());

			var speed = context.speed * dist * tmod;
			context.dx += Math.cos(angle) * speed;
			context.dy += Math.sin(angle) * speed;
		} else {
			context.dx *= Math.pow(0.6, tmod);
			context.dy *= Math.pow(0.6, tmod);
		}
	}
}

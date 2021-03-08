package en.hero;

import h2d.Graphics;
import h3d.Vector;
import en.hero.states.HeroRunState;
import en.hero.states.HeroIdleState;

class Hero extends Entity {

	public var speed = 0.03;

	public var running(get, never): Bool;

	public inline function get_running(): Bool {
		return M.fabs(dxTotal) >= 0.01 || M.fabs(dyTotal) >= 0.01;
	}

	public var ca: ControllerAccess;

	private var machine: StateMachine<Hero>;

	public function new(x, y) {
		super(x, y);
		ca = Main.ME.controller.createAccess("hero");
		ca.setLeftDeadZone(0.2);
		ca.setRightDeadZone(0.2);

		machine = new StateMachine<Hero>(this);
		machine.addState(new HeroRunState());
		machine.addState(new HeroIdleState());
		machine.onStateChanged = (stateName) -> {
			var state = stateName.split(".").pop();
			debug(state);
		}
		camera.trackEntity(this, true);
		addGraphcisSquare(Color.pickUniqueColorFor("hero"));
	}

	override function update() {
		super.update();
		machine.update(tmod);
	}
}

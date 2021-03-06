package en.hero;

import en.hero.states.HeroInteractState;
import dn.DecisionHelper;
import en.hero.states.HeroRunState;
import en.hero.states.HeroIdleState;

class Hero extends Entity {

	public var speed = 0.03;

	public var canPerformInteraction(get, never): Bool;

	public inline function get_canPerformInteraction(): Bool {
		return interactableFocus != null && ca.isPressed(X) && interactableFocus.canInteraction();
	}

	public var isSecondaryInteraction(get, never): Bool;

	public inline function get_isSecondaryInteraction(): Bool {
		return canPerformInteraction && ca.isDown(RB);
	}

	public var running(get, never): Bool;

	public inline function get_running(): Bool {
		return M.fabs(dxTotal) >= 0.01 || M.fabs(dyTotal) >= 0.01;
	}

	public var ca: ControllerAccess;

	private var machine: StateMachine<Hero>;
	private var interactableFocus: Null<Interactable>;

	public function new(x, y) {
		super(x, y);
		ca = Main.ME.controller.createAccess("hero");
		ca.setLeftDeadZone(0.2);
		ca.setRightDeadZone(0.2);

		machine = new StateMachine<Hero>(this);
		machine.addState(new HeroInteractState());
		machine.addState(new HeroRunState());
		machine.addState(new HeroIdleState());
		machine.onStateChanged = (stateName) -> {
			#if debug
			debugFSM(stateName);
			#end
		}
		camera.trackEntity(this, true);
	}

	override function update() {
		super.update();
		machine.update(tmod);
	}

	public function checkForInteractable() {
		var dh = new DecisionHelper(Interactable.ALL);
		dh.remove((e) -> return distCase(e) > e.focusRange || !e.active);
		dh.score((e) -> return -distCase(e));

		var best = dh.getBest();
		if (interactableFocus != best) {
			if (interactableFocus != null) {
				interactableFocus.unfocus();
			}

			interactableFocus = best;

			if (interactableFocus != null) {
				interactableFocus.focus();
			}
		}
	}

	public function interact() {
		interactableFocus.interact(this);
	}

	public function interactSecondary() {
		interactableFocus.secondaryInteract(this);
	}
}

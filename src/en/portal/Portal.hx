package en.portal;

import en.portal.states.PortalLevelCompleteState;
import en.portal.states.PortalReady;

class Portal extends Entity {

	public var isLevelExit: Bool;
	public var teleportPoint: LPoint;
	public var type: PortalType;

	private var machine: StateMachine<Portal>;

	public function new(x, y, type: PortalType, teleportPoint: LPoint, isLevelExit: Bool) {
		super(x, y);
		this.type = type;
		this.teleportPoint = teleportPoint;
		this.isLevelExit = isLevelExit;
		hasCollision = false;
		machine = new StateMachine<Portal>(this);
		machine.addState(new PortalLevelCompleteState());
		machine.addState(new PortalReady());
		machine.onStateChanged = (stateName) -> {
			#if debug
			debugFSM(stateName);
			#end
		}
	}

	override function update() {
		super.update();
		machine.update(tmod);
	}

	public function completeLevel() {
		Assets.SLIB.portal0().playOnGroup(Const.HERO_ACTION, 1);
		game.startNextLevel();
		destroy();
	}

	public function checkAndTeleportEntities() {
		for (entity in Entity.ALL) {
			if (entity != this && entity.atEntity(this) && !entity.cd.hasSetMs("recentlyTeleported", 500)) {
				entity.dx = 0;
				entity.dy = 0;
				entity.setAffectS(Stun, 0.5);
				teleportEntity(entity);
			}
		}
	}

	public function teleportEntity(entity: Entity) {
		if (isLevelExit && entity == hero && !isLevelComplete()) {
			entity.setPosCase(level.startPoint.cx, level.startPoint.cy);
		} else if (!isLevelExit) {
			entity.setPosCase(teleportPoint.cx, teleportPoint.cy);
		}
		Assets.SLIB.portal0().playOnGroup(Const.HERO_ACTION, 1);
	}

	public function getPortalColorString() {
		return switch type {
			case Green : "Green";
			case Red : "Red";
			case Blue : "Blue";
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

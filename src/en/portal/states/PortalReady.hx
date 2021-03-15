package en.portal.states;

class PortalReady extends State<Portal> {

	public function new() {
		super();
	}

	override function reason(): Bool {
		return true;
	}

	override function begin() {
		super.begin();
		if (context.isLevelExit) {
			context.spr.anim.playAndLoop('portalRed');
		} else {
			context.spr.anim.playAndLoop('portal${context.getPortalColorString()}');
		}
	}

	override function update(tmod: Float) {
		super.update(tmod);
		context.checkAndTeleportEntities();
	}
}

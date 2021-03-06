import ldtk.Point;
import en.portal.Portal;
import en.floorbutton.FloorButton;
import en.gate.Gate;
import en.block.Block;
import en.lever.Lever;
import en.hero.Hero;
import dn.Process;
import hxd.Key;

class Game extends Process {

	public static var ME: Game;

	/** Game controller (pad or keyboard) **/
	public var ca: dn.heaps.Controller.ControllerAccess;

	/** Particles **/
	public var fx: Fx;

	/** Basic viewport control **/
	public var camera: Camera;

	/** Container of all visual game objects. Ths wrapper is moved around by Camera. **/
	public var scroller: h2d.Layers;

	/** Level data **/
	public var level: Level;

	/** UI **/
	public var hud: ui.Hud;

	public var hero: Hero;

	/** Slow mo internal values**/
	var curGameSpeed = 1.0;

	var slowMos: Map<String, {id: String, t: Float, f: Float}> = new Map();

	/** LDtk world data **/
	public var worldData: World;

	public function new() {
		super(Main.ME);
		ME = this;
		ca = Main.ME.controller.createAccess("game");
		ca.setLeftDeadZone(0.2);
		ca.setRightDeadZone(0.2);
		createRootInLayers(Main.ME.root, Const.DP_BG);

		scroller = new h2d.Layers();
		root.add(scroller, Const.DP_BG);
		scroller.filter = new h2d.filter.Nothing(); // force rendering for pixel perfect

		worldData = new World();
		fx = new Fx();
		hud = new ui.Hud();
		camera = new Camera();

		var startingLevelIdx = 1;

		startLevel(worldData.levels[startingLevelIdx], startingLevelIdx);
	}

	/** Load a level **/
	function startLevel(l: World.World_Level, levelIdx: Int) {
		if (level != null)
			level.destroy();
		fx.clear();
		for (e in Entity.ALL) // <---- Replace this with more adapted entity destruction (eg. keep the player alive)
			e.destroy();
		garbageCollectEntities();

		level = new Level(l, levelIdx);
		// <---- Here: instanciate your level entities
		var heroData = l.l_Entities.all_Hero[0];
		hero = new Hero(heroData.cx, heroData.cy);
		level.startPoint = LPoint.fromCase(heroData.cx, heroData.cy);

		for (portal in l.l_Entities.all_Portal) {
			var teleportPoint = portal.f_teleportPoints.length != 0 ? LPoint.fromCase(portal.f_teleportPoints[0].cx, portal.f_teleportPoints[0].cy) : null;
			new Portal(portal.cx, portal.cy, portal.f_PortalType, teleportPoint, portal.f_isLevelExit);
		}
		for (lever in l.l_Entities.all_Lever) {
			new Lever(lever.cx, lever.cy, lever.f_optional, lever.f_action_ids);
		}

		for (block in l.l_Entities.all_Block) {
			var goal = if (block.f_Goal.length == 0) null else LPoint.fromCase(block.f_Goal[0].cx, block.f_Goal[0].cy);
			new Block(block.cx, block.cy, block.f_optional, null, null, goal);
		}

		for (gate in l.l_Entities.all_Gate) {
			new Gate(gate.cx, gate.cy, gate.f_opened, gate.f_alignment, gate.f_optional, gate.f_reaction_ids);
		}

		for (floorButton in l.l_Entities.all_FloorButton) {
			new FloorButton(floorButton.cx, floorButton.cy, floorButton.f_sticks, floorButton.f_optional, floorButton.f_action_ids,
				floorButton.f_reaction_ids);
		}

		for (text in l.l_Entities.all_Text) {
			new Text(text.cx, text.cy, text.f_value, text.f_color_int);
		}

		camera.recenter();
		hud.onLevelStart();
		Process.resizeAll();
	}

	public function startNextLevel() {
		var idx = level.levelIdx + 1;
		if (idx > 10) {
			idx = 1;
			fx.endScreen(0x0, 1, 6, 1);
			new Outro();
		}
		startLevel(worldData.levels[idx], idx);
	}

	public function resetLevel() {
		var idx = level.levelIdx;
		startLevel(worldData.levels[idx], idx);
	}

	/** CDB file changed on disk **/
	public function onCdbReload() {}

	/** LDtk file changed on disk **/
	public function onLdtkReload() {
		worldData.parseJson(hxd.Res.world.world.entry.getText());
		if (level != null)
			startLevel(worldData.getLevel(level.data.uid), level.levelIdx);
	}

	/** Window/app resize event **/
	override function onResize() {
		super.onResize();
	}

	/** Garbage collect any Entity marked for destruction. This is normally done at the end of the frame, but you can call it manually if you want to make sure marked entities are disposed right away, and removed from lists. **/
	public function garbageCollectEntities() {
		if (Entity.GC == null || Entity.GC.length == 0)
			return;

		for (e in Entity.GC)
			e.dispose();
		Entity.GC = [];
	}

	/** Called if game is destroyed, but only at the end of the frame **/
	override function onDispose() {
		super.onDispose();

		fx.destroy();
		for (e in Entity.ALL)
			e.destroy();
		garbageCollectEntities();
	}

	/**
		Start a cumulative slow-motion effect that will affect `tmod` value in this Process
		and all its children.

		@param sec Realtime second duration of this slowmo
		@param speedFactor Cumulative multiplier to the Process `tmod`
	**/
	public function addSlowMo(id: String, sec: Float, speedFactor = 0.3) {
		if (slowMos.exists(id)) {
			var s = slowMos.get(id);
			s.f = speedFactor;
			s.t = M.fmax(s.t, sec);
		} else
			slowMos.set(id, {id: id, t: sec, f: speedFactor});
	}

	/** The loop that updates slow-mos **/
	final function updateSlowMos() {
		// Timeout active slow-mos
		for (s in slowMos) {
			s.t -= utmod * 1 / Const.FPS;
			if (s.t <= 0)
				slowMos.remove(s.id);
		}

		// Update game speed
		var targetGameSpeed = 1.0;
		for (s in slowMos)
			targetGameSpeed *= s.f;
		curGameSpeed += (targetGameSpeed - curGameSpeed) * (targetGameSpeed > curGameSpeed ? 0.2 : 0.6);

		if (M.fabs(curGameSpeed - targetGameSpeed) <= 0.001)
			curGameSpeed = targetGameSpeed;
	}

	/**
		Pause briefly the game for 1 frame: very useful for impactful moments,
		like when hitting an opponent in Street Fighter ;)
	**/
	public inline function stopFrame() {
		ucd.setS("stopFrame", 0.2);
	}

	/** Loop that happens at the beginning of the frame **/
	override function preUpdate() {
		super.preUpdate();

		for (e in Entity.ALL)
			if (!e.destroyed)
				e.preUpdate();
	}

	/** Loop that happens at the end of the frame **/
	override function postUpdate() {
		super.postUpdate();

		// Update slow-motions
		updateSlowMos();
		baseTimeMul = (0.2 + 0.8 * curGameSpeed) * (ucd.has("stopFrame") ? 0.3 : 1);
		Assets.tiles.tmod = tmod;

		Entity.ALL.sort((a, b) -> Reflect.compare(a.bottom + a.sprOffY + a.zPriorityOffset, b.bottom + b.sprOffY + b.zPriorityOffset)); // y-sort
		// Entities post-updates
		for (e in Entity.ALL)
			if (!e.destroyed) {
				scroller.over(e.spr);
				e.postUpdate();
			}

		// Entities final updates
		for (e in Entity.ALL)
			if (!e.destroyed) {
				e.finalUpdate();
			}
		garbageCollectEntities();
	}

	/** Main loop but limited to 30 fps (so it might not be called during some frames) **/
	override function fixedUpdate() {
		super.fixedUpdate();

		// Entities "30 fps" loop
		for (e in Entity.ALL)
			if (!e.destroyed)
				e.fixedUpdate();
	}

	/** Main loop **/
	override function update() {
		super.update();

		// Entities main loop
		for (e in Entity.ALL)
			if (!e.destroyed)
				e.update();

		// Key shortcuts
		if (!ui.Console.ME.isActive() && !ui.Modal.hasAny()) {
			// Exit by pressing ESC twice
			#if hl
			if (ca.isKeyboardPressed(Key.ESCAPE))
				if (!cd.hasSetS("exitWarn", 3))
					trace(Lang.t._("Press ESCAPE again to exit."));
				else
					hxd.System.exit();
			#end

			// Attach debug drone (CTRL-SHIFT-D)
			#if debug
			if (ca.isKeyboardPressed(K.D) && ca.isKeyboardDown(K.CTRL)) {
				new en.DebugDrone(); // <-- HERE: provide an Entity as argument to attach Drone near it
			}
			#end

			// Restart whole game
			if (ca.selectPressed())
				resetLevel();
		}
	}
}

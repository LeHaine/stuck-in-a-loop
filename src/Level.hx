import format.pdf.Extract;

class Level extends dn.Process {

	var game(get, never): Game;

	inline function get_game() return Game.ME;

	var fx(get, never): Fx;

	inline function get_fx() return Game.ME.fx;

	/** Level grid-based width**/
	public var cWid(get, never): Int;

	inline function get_cWid() return data.l_Collisions.cWid;

	/** Level grid-based height **/
	public var cHei(get, never): Int;

	inline function get_cHei() return data.l_Collisions.cHei;

	/** Level pixel width**/
	public var pxWid(get, never): Int;

	inline function get_pxWid() return cWid * Const.GRID;

	/** Level pixel height**/
	public var pxHei(get, never): Int;

	inline function get_pxHei() return cHei * Const.GRID;

	public var collisionLayers = [1, 2];

	var extraCollison: Map<Int, Bool>;

	public var data: World.World_Level;

	public var startPoint: LPoint;

	public var levelIdx: Int;

	var tilesetSource: h2d.Tile;

	var marks: Map<LevelMark, Map<Int, Bool>> = new Map();
	var invalidated = true;

	public function new(ldtkLevel: World.World_Level, levelIdx: Int) {
		super(Game.ME);
		this.levelIdx = levelIdx;

		createRootInLayers(Game.ME.scroller, Const.DP_BG);
		data = ldtkLevel;
		tilesetSource = hxd.Res.world.tiles.toTile();
		extraCollison = new Map<Int, Bool>();
	}

	override function onDispose() {
		super.onDispose();
		data = null;
		tilesetSource = null;
		marks = null;
	}

	/** TRUE if given coords are in level bounds **/
	public inline function isValid(cx, cy) return cx >= 0 && cx < cWid && cy >= 0 && cy < cHei;

	/** Gets the integer ID of a given level grid coord **/
	public inline function coordId(cx, cy) return cx + cy * cWid;

	/** Ask for a level render that will only happen at the end of the current frame. **/
	public inline function invalidate() {
		invalidated = true;
	}

	/** Return TRUE if mark is present at coordinates **/
	public inline function hasMark(mark: LevelMark, cx: Int, cy: Int) {
		return !isValid(cx, cy) || !marks.exists(mark) ? false : marks.get(mark).exists(coordId(cx, cy));
	}

	/** Enable mark at coordinates **/
	public function setMark(mark: LevelMark, cx: Int, cy: Int) {
		if (isValid(cx, cy) && !hasMark(mark, cx, cy)) {
			if (!marks.exists(mark))
				marks.set(mark, new Map());
			marks.get(mark).set(coordId(cx, cy), true);
		}
	}

	/** Remove mark at coordinates **/
	public function removeMark(mark: LevelMark, cx: Int, cy: Int) {
		if (isValid(cx, cy) && hasMark(mark, cx, cy))
			marks.get(mark).remove(coordId(cx, cy));
	}

	/** Return TRUE if "Collisions" layer contains a collision value **/
	public inline function hasCollision(cx, cy): Bool {
		return !isValid(cx, cy) ? true : collisionLayers.contains(data.l_Collisions.getInt(cx, cy))
			|| extraCollison.exists(coordId(cx, cy));
	}

	public function setExtraCollision(cx, cy, enabled: Bool) {
		if (isValid(cx, cy)) {
			if (enabled) {
				extraCollison.set(coordId(cx, cy), true);
			} else {
				extraCollison.remove(coordId(cx, cy));
			}
		}
	}

	/** Render current level**/
	function render() {
		// Placeholder level render
		root.removeChildren();

		var tg = new h2d.TileGroup(tilesetSource, root);

		data.l_Ground.render(tg);
		data.l_Shadows.render(tg);
		data.l_Collisions.render(tg);
	}

	override function postUpdate() {
		super.postUpdate();

		if (invalidated) {
			invalidated = false;
			render();
		}
	}
}

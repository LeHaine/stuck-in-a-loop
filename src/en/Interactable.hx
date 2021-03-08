package en;

import h2d.filter.Outline;

class Interactable extends Entity {

	public static var ALL: Array<Interactable> = [];

	private var label(get, never): h2d.Text;

	public inline function get_label() {
		return game.hud.interactionLabel;
	}

	public var labelText(default, set): String;

	public inline function set_labelText(value) {
		if (label.visible) {
			label.text = value;
		}
		return labelText = value;
	}

	public var activationDelay = 0.3;

	public var active: Bool;

	public var focusRange = 2;

	public var onFocus: Null<() -> Void>;
	public var onUnfocus: Null<() -> Void>;

	private var _canInteract: Bool;
	private var outlineFilter: Outline;

	public function new(x, y) {
		super(x, y);
		ALL.push(this);

		active = true;
		outlineFilter = new Outline(0.5, 0xFFFF00);
	}

	override function dispose() {
		super.dispose();
		ALL.remove(this);
	}

	public function interact(from: Entity) {}

	public function canInteraction() {
		return _canInteract && isHeroNear();
	}

	public function isHeroNear() {
		return hero.within(cx, cy, focusRange, focusRange);
	}

	public function focus() {
		if (!active) {
			return;
		}
		if (onFocus != null) {
			onFocus();
		}
		label.text = labelText;
		label.visible = true;
		_canInteract = true;
		spr.filter = outlineFilter;
		game.tw.createS(label.alpha, 0 > 1, 0.2);
	}

	public function unfocus() {
		if (onUnfocus != null) {
			onUnfocus();
		}
		_canInteract = false;
		spr.filter = null;
		game.tw.createS(label.alpha, 0, 0.3).end(() -> {
			label.visible = false;
		});
	}
}

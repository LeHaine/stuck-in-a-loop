package en;

class Trigger extends Interactable {

	public static var ALL = [];

	public var completed = false;

	public function new(x, y) {
		super(x, y);
		ALL.push(this);
	}

	override function dispose() {
		super.dispose();
		ALL.remove(this);
	}
}

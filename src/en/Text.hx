package en;

class Text extends Entity {

	private var wrapper: h2d.Object;
	private var background: h2d.ScaleGrid;
	private var textField: h2d.Text;

	public function new(x, y, text, color: Int) {
		super(x, y);
		hasCollision = false;
		wrapper = new h2d.Object();
		game.scroller.add(wrapper, Const.DP_BG);
		background = new h2d.ScaleGrid(Assets.tiles.getTile("uiBox"), 5, 5, wrapper);
		textField = new h2d.Text(Assets.fontPixel, wrapper);
		textField.text = text;
		textField.textColor = color;
		textField.setPosition(8, 6);
		textField.maxWidth = 160;

		background.width = 16 + textField.textWidth;
		background.height = 12 + textField.textHeight;
		background.color.setColor(Color.addAlphaF(Color.interpolateInt(color, 0x222034, 0.8)));

		wrapper.x = Std.int(attachX - background.width * 0.5);
		wrapper.y = Std.int(attachY - background.height * 0.5 + 8);
	}

	override function postUpdate() {
		super.postUpdate();
		spr.visible = false;
	}

	override function dispose() {
		super.dispose();
		wrapper.remove();
	}
}

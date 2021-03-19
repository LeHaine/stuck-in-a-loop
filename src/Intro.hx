import h2d.Flow.FlowAlign;

class Intro extends dn.Process {

	var banner: HSprite;
	var cm = new dn.Cinematic(Const.FPS);
	var flow: h2d.Flow;

	public function new() {
		super(Main.ME);
		createRoot(Main.ME.root);

		flow = new h2d.Flow(root);
		flow.borderWidth = 7;
		flow.borderHeight = 7;
		flow.horizontalAlign = Middle;
		flow.layout = Vertical;
		flow.verticalSpacing = 2;
		banner = Assets.tiles.h_get("banner", flow);
		banner.setCenterRatio(0, 0);

		cm.create({
			tw.createMs(root.alpha, 0 > 1, 500);
			3000;
			tw.createMs(root.alpha, 0, 3000);
			3000;
			destroy();
			Main.ME.startGame();
		});
		text("A game by Colt Daily / LeHaine");
		text("Made during March 2021 during a One Month a Game Challenge");

		dn.Process.resizeAll();
	}

	function text(str: String, c = 0xFFFFFF) {
		var tf = new h2d.Text(Assets.fontPixelSmall, flow);
		tf.text = str;
		tf.textColor = c;
	}

	override function onResize() {
		super.onResize();
		root.setScale(Const.SCALE);
		var percent = 0.5;
		#if js
		percent = 0.55;
		#end
		var w = M.ceil(w() / Const.UI_SCALE);
		var h = M.ceil(h() / Const.UI_SCALE);
		flow.x = Std.int(w * 0.5 - flow.outerWidth * 0.5);
		flow.y = Std.int(h * 0.5 - flow.outerHeight * 0.5);
	}

	override function preUpdate() {
		super.preUpdate();
		cm.update(tmod);
	}
}

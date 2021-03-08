import dn.heaps.slib.*;

class Assets {

	public static var fontPixel: h2d.Font;
	public static var fontPixelSmall: h2d.Font;
	public static var fontPixelMedium: h2d.Font;
	public static var fontPixelLarge: h2d.Font;
	public static var fontTiny: h2d.Font;
	public static var fontSmall: h2d.Font;
	public static var fontMedium: h2d.Font;
	public static var fontLarge: h2d.Font;
	public static var tiles: SpriteLib;

	static var initDone = false;

	public static function init() {
		if (initDone)
			return;
		initDone = true;

		fontPixel = hxd.Res.fonts.m5x7_16.toFont();
		fontPixelSmall = hxd.Res.fonts.m5x7_16.toFont();
		fontPixelMedium = hxd.Res.fonts.m5x7_32.toFont();
		fontPixelLarge = hxd.Res.fonts.m5x7_48.toFont();
		fontTiny = hxd.Res.fonts.barlow_condensed_medium_regular_9.toFont();
		fontSmall = hxd.Res.fonts.barlow_condensed_medium_regular_11.toFont();
		fontMedium = hxd.Res.fonts.barlow_condensed_medium_regular_17.toFont();
		fontLarge = hxd.Res.fonts.barlow_condensed_medium_regular_32.toFont();
		tiles = dn.heaps.assets.Atlas.load("atlas/tiles.atlas");
	}
}

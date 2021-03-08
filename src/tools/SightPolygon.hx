package tools;

class Point {

	public var x: Float = 0.0;
	public var y: Float = 0.0;
	public var angle: Float = 0.0;

	public function new(x_: Float, y_: Float) {
		this.x = x_;
		this.y = y_;
	}
}

class Intersection {

	public var pt: Point;
	public var param: Float;
	public var angle: Float;

	public function new() {}
}

class Segment {

	public var p1: Point;
	public var p2: Point;

	public function new() {}
}

class Ray {

	public var p1: Point;
	public var p2: Point;

	public function new() {}
}

class SightPolygon {

	private var sightX: Float;
	private var sightY: Float;

	private var segments: Array<Segment>;

	public var output: Array<Point>;

	public function new(x: Float, y: Float) {
		sightX = x;
		sightY = y;
		segments = [];
		output = [];
	}

	public function addSegment(x1: Float, y1: Float, x2: Float, y2: Float) {
		var pt1 = new Point(x1, y1);
		var pt2 = new Point(x2, y2);
		var segment = new Segment();
		segment.p1 = pt1;
		segment.p2 = pt2;
		segments.push(segment);
	}

	public function sweep() {
		var points: Array<Point> = [];
		for (segment in segments) {
			points.push(segment.p1);
			points.push(segment.p2);
		}
		var pointSet: Map<String, Bool> = [];
		var uniquePoints = points.filter(point -> {
			var key = '${point.x},${point.y}';
			if (pointSet.exists(key)) {
				return false;
			} else {
				pointSet[key] = true;
				return true;
			}
		});

		var uniqueAngles: Array<Float> = [];
		for (point in uniquePoints) {
			var angle = Math.atan2(point.y - sightY, point.x - sightX);
			point.angle = angle;
			uniqueAngles.push(angle - 0.00001);
			uniqueAngles.push(angle);
			uniqueAngles.push(angle + 0.00001);
		}

		var intersections: Array<Intersection> = [];

		for (angle in uniqueAngles) {
			var dx = Math.cos(angle);
			var dy = Math.sin(angle);

			var ray = new Ray();
			ray.p1 = new Point(sightX, sightY);
			ray.p2 = new Point(sightX + dx, sightY + dy);

			var closestIntersect: Intersection = null;

			for (segment in segments) {
				var intersect = getIntersection(ray, segment);
				if (intersect == null) {
					continue;
				}
				if (closestIntersect == null || intersect.param < closestIntersect.param) {
					closestIntersect = intersect;
				}
			}
			if (closestIntersect == null) {
				continue;
			}
			closestIntersect.angle = angle;
			intersections.push(closestIntersect);
		}
		intersections.sort((a, b) -> M.sign(a.angle - b.angle));
		output = intersections.map(intersection -> intersection.pt);
	}

	private function getIntersection(ray: Ray, segment: Segment): Null<Intersection> {
		// RAY in parametric: Point + Delta*T1
		var r_px = ray.p1.x;
		var r_py = ray.p1.y;
		var r_dx = ray.p2.x - ray.p1.x;
		var r_dy = ray.p2.y - ray.p1.y;

		// SEGMENT in parametric: Point + Delta*T2
		var s_px = segment.p1.x;
		var s_py = segment.p1.y;
		var s_dx = segment.p2.x - segment.p1.x;
		var s_dy = segment.p2.y - segment.p1.y;

		// Are they parallel? If so, no intersect
		var r_mag = Math.sqrt(r_dx * r_dx + r_dy * r_dy);
		var s_mag = Math.sqrt(s_dx * s_dx + s_dy * s_dy);
		if (r_dx / r_mag == s_dx / s_mag && r_dy / r_mag == s_dy / s_mag) {
			// Unit vectors are the same.
			return null;
		}

		// SOLVE FOR T1 & T2
		// r_px+r_dx*T1 = s_px+s_dx*T2 && r_py+r_dy*T1 = s_py+s_dy*T2
		// ==> T1 = (s_px+s_dx*T2-r_px)/r_dx = (s_py+s_dy*T2-r_py)/r_dy
		// ==> s_px*r_dy + s_dx*T2*r_dy - r_px*r_dy = s_py*r_dx + s_dy*T2*r_dx - r_py*r_dx
		// ==> T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx)
		var T2 = (r_dx * (s_py - r_py) + r_dy * (r_px - s_px)) / (s_dx * r_dy - s_dy * r_dx);
		var T1 = (s_px + s_dx * T2 - r_px) / r_dx;

		// Must be within parametic whatevers for RAY/SEGMENT
		if (T1 < 0) {
			return null;
		}
		if (T2 < 0 || T2 > 1) {
			return null;
		}

		var intersection = new Intersection();
		intersection.pt = new Point(r_px + r_dx * T1, r_py + r_dy * T1);
		intersection.param = T1;
		return intersection;
	}
}

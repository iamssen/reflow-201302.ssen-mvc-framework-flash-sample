package ssen.mvc.samples.flash.model {
	import ssen.log.formatToString;

	public class Ball {
		public var id:int;

		public var r:int;
		public var x:Number;
		public var y:Number;

		public function toString():String {
			return formatToString('[Ball id="{0}" r="{1}" x="{2}" y="{3}"]', id, r, x, y);
		}
	}
}

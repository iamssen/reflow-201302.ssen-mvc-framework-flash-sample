package ssen.mvc.samples.flash.model {
	import ssen.log.formatToString;

	//=========================================================
	// ball 객체 하나에 대한 정의 입니다 (value object)
	//=========================================================
	public class Ball {
		/** primary id */
		public var id:int;

		/** radius */
		public var r:int;

		/** x position { 0 ~ 1 } */
		public var x:Number;
		/** y position { 0 ~ 1 } */
		public var y:Number;

		public function toString():String {
			return formatToString('[Ball id="{0}" r="{1}" x="{2}" y="{3}"]', id, r, x, y);
		}
	}
}

package {
import flash.display.Sprite;
import flash.events.Event;

public class Test extends Sprite {
	public function Test() {
		var sp1:Sp=new Sp(1);
		var sp2:Sp=new Sp(2);
		var sp3:Sp=new Sp(3);

		//==========================================================================================
		// view catcher 를 added to stage 로 할지, added 로 할지에 대해 결정해야 함
		// 가장 긴급한 문제...
		//==========================================================================================
		addEventListener(Event.ADDED_TO_STAGE, viewEvent, true);
//		addEventListener(Event.ADDED, viewEvent, true);

		addChild(sp3);
		sp3.addChild(sp2);
		sp2.addChild(sp1);
	}

	private function viewEvent(event:Event):void {
		// TODO Event :: viewEvent
		trace("viewEvent", event, event.target, event.currentTarget);

	}
}
}
import flash.display.Sprite;

import ssen.log.formatToString;

class Sp extends Sprite {
	public var id:int;

	public function Sp(id:int) {
		this.id=id;
	}

	/** @inheritDoc */
	override public function toString():String {
		return formatToString('[Sp id="{0}"]', id);
	}


}

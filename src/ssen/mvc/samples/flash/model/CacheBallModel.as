package ssen.mvc.samples.flash.model {
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	import ssen.mvc.base.Actor;

	public class CacheBallModel extends Actor implements BallModel {
		private const DELAY:int=100;
		private var table:BallTable;

		public function CacheBallModel() {
			table=new BallTable;

//			var so:SharedObject=SharedObject.getLocal("ballData");
//			if (so.data["backup"]) {
//				table.restoreBackup(so.data["backup"]);
//			}
		}

		override protected function destruct():void {
			super.destruct();

//			var so:SharedObject=SharedObject.getLocal("ballData");
//			so.data["backup"]=table.getBackup();

			table=null;
		}

		public function addBall(x:Number, y:Number, result:Function=null, fault:Function=null):void {
			setTimeout(function():void {
				var ball:Ball=table.addBall(x, y);

				if (result !== null) {
					result(ball);
				}
			}, DELAY);
		}

		public function removeBall(id:int, result:Function=null, fault:Function=null):void {
			setTimeout(function():void {
				if (table.removeBall(id)) {
					if (result !== null) {
						result(id);
					}
				} else {
					if (fault !== null) {
						fault(new Error("remove failed"));
					}
				}
			}, DELAY);
		}

		public function upBall(id:int, result:Function=null, fault:Function=null):void {
			setTimeout(function():void {
				var ball:Ball=table.getBall(id);
				ball.r=ball.r + 1;
				updateBall(ball, result, fault);
			}, DELAY);
		}

		public function downBall(id:int, result:Function=null, fault:Function=null):void {
			setTimeout(function():void {
				var ball:Ball=table.getBall(id);
				ball.r=ball.r - 1;
				updateBall(ball, result, fault);
			}, DELAY);
		}

		private function updateBall(ball:Ball, result:Function=null, fault:Function=null):void {
			if (table.updateBall(ball.id, ball.x, ball.y, ball.r)) {
				if (result !== null) {
					result(ball);
				}
			} else {
				if (fault !== null) {
					fault(new Error("update failed"));
				}
			}
		}

		public function getBallList(result:Function=null, fault:Function=null):void {
			setTimeout(function():void {
				var list:Vector.<Ball>=table.getBallList();

				if (list) {
					if (result !== null) {
						result(list);
					}
				} else {
					if (fault !== null) {
						fault(new Error("undefined ball list"));
					}
				}
			}, DELAY);
		}

		public function clearBallList(result:Function=null, fault:Function=null):void {
			setTimeout(function():void {
				if (table.removeAllBall()) {
					if (result !== null) {
						result();
					}
				} else {
					if (fault !== null) {
						fault(new Error("clear failed"));
					}
				}
			}, DELAY);
		}
	}
}
import ssen.common.DataTable;
import ssen.mvc.samples.flash.model.Ball;

class BallTable extends DataTable {
	public function getBackup():Array {
		return _getBackup();
	}

	public function restoreBackup(backup:Array):void {
		_restoreBackup(backup);
	}

	public function addBall(x:Number, y:Number):Ball {
		var ball:Ball=new Ball;
		ball.id=_create({x: x, y: y, r: 1});
		ball.x=x;
		ball.y=y;
		ball.r=1;

		return ball;
	}

	public function removeBall(id:int):Boolean {
		return _delete(id) !== null;
	}

	public function updateBall(id:int, x:int, y:int, r:int):Boolean {
		return _update(id, {x: x, y: y, r: r}) !== null;
	}

	public function getBall(id:int):Ball {
		var obj:Object=_read(id);

		var ball:Ball=new Ball;
		ball.x=obj["x"];
		ball.y=obj["y"];
		ball.r=obj["r"];

		return ball;
	}

	public function getBallList():Vector.<Ball> {
		var balls:Vector.<Ball>=new Vector.<Ball>;
		var ball:Ball, obj:Object;

		var f:int=-1;
		var fmax:int=length;
		while (++f < fmax) {
			obj=_read(f);

			if (obj) {
				ball=new Ball;
				ball.x=obj["x"];
				ball.y=obj["y"];
				ball.r=obj["r"];

				balls.push(ball);
			}
		}

		return balls;
	}

	public function removeAllBall():Boolean {
		_purge();
		return true;
	}
}

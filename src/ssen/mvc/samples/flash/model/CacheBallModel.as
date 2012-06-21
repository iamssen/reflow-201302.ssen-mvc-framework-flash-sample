package ssen.mvc.samples.flash.model {
	import flash.net.SharedObject;

	import ssen.mvc.base.Actor;

	//=========================================================
	// data 의 상태를 Shared Object 에 유지시키는 구현 Model 입니다
	//=========================================================
	public class CacheBallModel extends Actor implements BallModel {
		private var table:BallTable;
		private var dataid:int=0;

		//=========================================================
		// Cache point 를 하나로 고착시키면 Modular 에서 에러가 발생됩니다
		// 그렇기에 Cache point 가 될 dataid 를 받아들여서 작동합니다
		//=========================================================
		public function CacheBallModel(dataid:int) {
			this.dataid=dataid;

			table=new BallTable;

			restoreBackup();
		}

		//=========================================================
		// Actor destruct
		//=========================================================
		override protected function destruct():void {
			super.destruct();

			table=null;
		}

		//=========================================================
		// Shared Object 의 Data 백업, 복구 기능 입니다 
		//=========================================================
		private function restoreBackup():void {
			var so:SharedObject=SharedObject.getLocal("ballData");
			if (so.data["backup" + dataid]) {
				table.restoreBackup(so.data["backup" + dataid]);
			}
		}

		private function saveBackup():void {
			var so:SharedObject=SharedObject.getLocal("ballData");
			so.data["backup" + dataid]=table.getBackup();
		}

		//=========================================================
		// implements Model API
		//=========================================================
		public function addBall(x:Number, y:Number, result:Function=null, fault:Function=null):void {
			var ball:Ball=table.addBall(x, y);

			if (result !== null) {
				result(ball);
				saveBackup();
			}
		}

		public function removeBall(id:int, result:Function=null, fault:Function=null):void {
			if (table.removeBall(id)) {
				if (result !== null) {
					result(id);
					saveBackup();
				}
			} else {
				if (fault !== null) {
					fault(new Error("remove failed"));
				}
			}
		}

		public function upBall(id:int, result:Function=null, fault:Function=null):void {
			var ball:Ball=table.getBall(id);
			ball.r=ball.r + 1;
			updateBall(ball, result, fault);
		}

		public function downBall(id:int, result:Function=null, fault:Function=null):void {
			var ball:Ball=table.getBall(id);
			ball.r=ball.r - 1;
			updateBall(ball, result, fault);
		}

		private function updateBall(ball:Ball, result:Function=null, fault:Function=null):void {
			if (ball.r === 0) {
				ball.r=1;
			}

			if (table.updateBall(ball.id, ball.x, ball.y, ball.r)) {
				if (result !== null) {
					result(ball);
					saveBackup();
				}
			} else {
				if (fault !== null) {
					fault(new Error("update failed"));
				}
			}
		}

		public function getBallList(result:Function=null, fault:Function=null):void {
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
		}

		public function clearBallList(result:Function=null, fault:Function=null):void {
			if (table.removeAllBall()) {
				if (result !== null) {
					result();
					saveBackup();
				}
			} else {
				if (fault !== null) {
					fault(new Error("clear failed"));
				}
			}
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

	public function updateBall(id:int, x:Number, y:Number, r:int):Boolean {
		return _update(id, {x: x, y: y, r: r}) !== null;
	}

	public function getBall(id:int):Ball {
		var obj:Object=_read(id);

		var ball:Ball=new Ball;
		ball.id=id;
		ball.x=obj["x"];
		ball.y=obj["y"];
		ball.r=obj["r"];

		return ball;
	}

	public function getBallList():Vector.<Ball> {
		var balls:Vector.<Ball>=new Vector.<Ball>;
		var ball:Ball, obj:Object;

		var f:int=-1;
		var fmax:int=getTablelength();
		while (++f < fmax) {
			obj=_read(f);

			if (obj) {
				ball=new Ball;
				ball.id=f;
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

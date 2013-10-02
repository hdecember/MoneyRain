// forked from tktr90755's 流れ落ちる
package
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	[SWF(frameRate="60",background='0xffffff')]
	
	public class Dots extends MovieClip
	{
		private var imgURL:String = 'money2.jpg';
		//コンテナ
		private var container:MovieClip;
		//噴出位置とリミット位置
		private var xLimit:Number;
		private var yLimit:Number;
		private var xAxis:Number;
		private var yAxis:Number;
		//色
		private var colors:Array = new Array("0xE89A0A", "0xE910DE", "0x0EEB10", "0xE9C010", "0xE2160F", "0xD6EB0B", "0xEB117C", "0xE81167", "0x7E11E8");
		//クリックで切り替え
		private var clickFlug:Boolean = false;
		private var loader:Loader;
		private var bitmapData:BitmapData;
		private var matrix:Matrix;
		
		public function Dots()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
		}
		
		private function onAddedStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			//onAssetsLoadComplete();
			loader = new Loader();
			loader.load(new URLRequest(imgURL));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetsLoadComplete);
			matrix = new Matrix;
		}
		
		private function _onMouseDown(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			clickFlug = !clickFlug
		}
		
		private function _onMouseUp(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		private function _onMouseMove(e:Event):void
		{
			xAxis = stage.mouseX;
			yAxis = stage.mouseY;
		}
		
		private function _onEnterFrame(e:Event):void
		{
			if (container.numChildren < 50)
			{
				createClip(container, xAxis, yAxis);
			}
		}
		
		private function createClip(a:MovieClip, b:Number, c:Number):void
		{
			//ランダムな数値
			var value1:Number = Math.floor(Math.random() * 10);
			var value2:Number = Math.floor(Math.random() * 10);
			var value3:Number = Math.floor(Math.random() * 10);
			//速さ [X軸,Y軸,回転]
			var xSpeed:Number = value1 - value2;
			var ySpeed:Number = value3 - 10;
			var ratationSpeed:Number = 10;
			xSpeed = value1 - value2;
			ySpeed = value3 - 10;
			ratationSpeed = 10;
			//減速率 [X軸,Y軸,回転]
			var xDeceleration:Number = 0.98;
			var yDeceleration:Number = 0.98;
			var rotationDeceleration:Number = 0.98;
			//重力
			var gravity:Number = 0.35;
			var ms:Number = 0.98;
			var sc:Number = 0.25;
			var sa:Number = 0.05 * Math.random();
			//shape生成と
			var shape:Card = new Card();
			a.addChild(shape);
			var offsetX:int = 0;
			var offsetY:int = 0;
			matrix.tx = offsetX;
			matrix.ty = offsetY;
			//shape.name = offsetX + "|" + offsetY;
			shape.offsetX = offsetX;
			shape.offsetY = offsetY;
			shape.graphics.beginBitmapFill(bitmapData, matrix);
			shape.graphics.drawRoundRect(0, 0, 109, 167, 5, 5);
			shape.graphics.endFill();
			shape.x = b;
			shape.y = c;
			shape.rotation = 180;
			shape.alpha = 0;
			//流れ落ちる動き
			shape.addEventListener(Event.ENTER_FRAME, __onEnterFrame);
			
			var time:uint;
			
			function __onEnterFrame(e:Event):void
			{
				shape.alpha = 1;
				xSpeed = xSpeed * xDeceleration;
				ySpeed = ySpeed * yDeceleration + gravity;
				ratationSpeed = ratationSpeed * rotationDeceleration;
				e.target.x = e.target.x + xSpeed;
				e.target.y = e.target.y + ySpeed;
				e.target.rotation = e.target.rotation + ratationSpeed;
				sc = sc + sa;
				e.target.scaleX = 1 * Math.sin(3.141593 * sc);
				e.target.scaleY = 1 * Math.cos(3.141593 * sc);
				//trace("Dots::createClip",sc);
				if (Math.ceil(sc*2) % 2 == 0)
				{
					matrix.tx = 1;
					matrix.ty =  1;
					e.target.graphics.beginBitmapFill(bitmapData, matrix);
					e.target.graphics.drawRoundRect(0, 0, 277, 141, 0, 0);
					e.target.graphics.endFill();
				}
				else
				{
					matrix.tx = e.target.offsetX;
					matrix.ty = e.target.offsetY;
					e.target.graphics.beginBitmapFill(bitmapData, matrix);
					e.target.graphics.drawRoundRect(0, 0, 277, 141, 0,0);
					e.target.graphics.endFill();
				}
				if (e.target.x + 100 > xLimit || e.target.y + 100 > yLimit)
				{
					e.target.alpha = Math.round(yLimit - e.target.y);
					if (e.target.alpha <= 0)
					{
						shape.removeEventListener(Event.ENTER_FRAME, __onEnterFrame);
						removeMC();
					}
				}
			}
			function removeMC():void
			{
				a.removeChild(shape);
			}
		}
		
		private function randomInt(max:int, min:int):int
		{
			var value:int = min + Math.floor(Math.random() * (max - min));
			return value;
		}
		
		private function onAssetsLoadComplete(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			
			bitmapData = (loader.content as Bitmap).bitmapData;
			
			container = new MovieClip();
			addChild(container);
			
			xLimit = stage.stageWidth * 2;
			yLimit = stage.stageHeight * 2;
			xAxis = stage.mouseX;
			yAxis = stage.mouseY;
			
			var textField:TextField = new TextField();
			textField.text = "";
			addChild(textField);
		}
	}
}
class Card extends flash.display.Shape
{
	public var offsetX:int;
	public var offsetY:int;
}
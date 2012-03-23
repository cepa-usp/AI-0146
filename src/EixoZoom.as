package  
{
	import cepa.graph.rectangular.AxisX;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class EixoZoom extends Sprite 
	{
		private var axis:AxisX;
		private var xmin:Number;
		private var xmax:Number;
		public var widthAxis:Number;
		private var delta:Number;
		
		private var leftBracket:LeftBracket;
		private var rightBracket:RightBracket;
		private var bracketPoint:Ponto;
		
		private var brackets:Array = [];
		private var pontos:Array = [];
		
		private var missingLeftBracket:MissingBracketLeft;
		private var missingRightBracket:MissingBracketRight;
		
		private var zoomInBtn:ZoomPlusBtn;
		private var zoomOutBtn:ZoomMinusBtn;
		
		public function EixoZoom(xmin:Number, xmax:Number, widthAxis:Number) 
		{
			this.xmin = xmin;
			this.xmax = xmax;
			this.widthAxis = widthAxis;
			
			axis = new AxisX(xmin, xmax, widthAxis);
			addChild(axis);
			
			createZoom();
		}
		
		private function createZoom():void 
		{
			zoomOutBtn = new ZoomMinusBtn();
			zoomInBtn = new ZoomPlusBtn();
			
			zoomInBtn.x = zoomInBtn.width / 2;
			zoomInBtn.y = -40;
			
			zoomOutBtn.x = zoomInBtn.x + zoomOutBtn.width + 5;
			zoomOutBtn.y = zoomInBtn.y;
			
			zoomInBtn.buttonMode = true;
			zoomOutBtn.buttonMode = true;
			
			addChild(zoomInBtn);
			addChild(zoomOutBtn);
			
			zoomInBtn.addEventListener(MouseEvent.MOUSE_DOWN, initZoom);
			zoomOutBtn.addEventListener(MouseEvent.MOUSE_DOWN, initZoom);
		}
		
		private var timerToZoom:Timer = new Timer(200);
		private function initZoom(e:MouseEvent):void 
		{
			if (e.target == zoomInBtn) {
				timerToZoom.addEventListener(TimerEvent.TIMER, zoomIn);
				zoomIn(null);
			}else {
				timerToZoom.addEventListener(TimerEvent.TIMER, zoomOut);
				zoomOut(null);
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, stopZoom);
			timerToZoom.start();
		}
		
		private function zoomIn(e:TimerEvent):void 
		{
			var newHalfRange:Number = (xmax - xmin) / 2 - (xmax - xmin) / 10;
			var newXmin:Number = bracketPoint.eixoPt - newHalfRange;
			var newXmax:Number = bracketPoint.eixoPt + newHalfRange;
			
			setRange(newXmin, newXmax);
			dispatchEvent(new ModelEvent(ModelEvent.CHANGE_ZOOM, true));
		}
		
		private function zoomOut(e:TimerEvent):void 
		{
			var newHalfRange:Number = (xmax - xmin) / 2 + (xmax - xmin) / 10;
			var newXmin:Number = bracketPoint.eixoPt - newHalfRange;
			var newXmax:Number = bracketPoint.eixoPt + newHalfRange;
			
			setRange(newXmin, newXmax);
			dispatchEvent(new ModelEvent(ModelEvent.CHANGE_ZOOM, true));
		}
		
		private function stopZoom(e:MouseEvent):void 
		{
			timerToZoom.stop();
			timerToZoom.removeEventListener(TimerEvent.TIMER, zoomIn);
			timerToZoom.removeEventListener(TimerEvent.TIMER, zoomOut);
			timerToZoom.reset();
		}
		
		public function adicionaPonto(nome:String, posX:Number, lock:Boolean = false ):void
		{
			var pt:Ponto = new Ponto();
			pt.name = nome;
			pt.eixoPt = posX;
			pontos.push(pt);
			pt.x = axis.x2pixel(posX);
			addChild(pt);
			pt.addEventListener(MouseEvent.MOUSE_DOWN, initDragPoint);
			
			if (lock) {
				pt.mouseEnabled = false;
			}else {
				pt.buttonMode = true;
			}
		}
		
		private var draggingPt:Ponto;
		private function initDragPoint(e:MouseEvent):void 
		{
			draggingPt = Ponto(e.target);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, draggingPoint);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraggingPoint);
		}
		
		private function draggingPoint(e:MouseEvent):void 
		{
			draggingPt.x = Math.max(0, Math.min(widthAxis, this.mouseX));
			draggingPt.eixoPt = axis.pixel2x(draggingPt.x);
			
			if(draggingPt.name == Model.LAMBDA){
				var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_LAMBDA, true);
				evt.propValue = draggingPt.eixoPt;
				dispatchEvent(evt);
			}
		}
		
		private function stopDraggingPoint(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggingPoint);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraggingPoint);
			draggingPt = null;
		}
		
		public function createBrackets(nome:String, centralPt:Number, delta:Number, lockPt:Boolean = false, lockBrackets:Boolean = false):void 
		{
			this.delta = delta;
			
			bracketPoint = new Ponto();
			bracketPoint.name = nome;
			addChild(bracketPoint);
			bracketPoint.x = axis.x2pixel(centralPt);
			bracketPoint.eixoPt = centralPt;
			
			leftBracket = new LeftBracket();
			addChild(leftBracket);
			//leftBracket.x = axis.x2pixel(centralPt - delta);
			
			rightBracket = new RightBracket();
			addChild(rightBracket);
			//rightBracket.x = axis.x2pixel(centralPt + delta);
			
			bracketPoint.addEventListener(MouseEvent.MOUSE_DOWN, initDragBracketPoint);
			leftBracket.addEventListener(MouseEvent.MOUSE_DOWN, initDragBracket);
			rightBracket.addEventListener(MouseEvent.MOUSE_DOWN, initDragBracket);
			
			missingLeftBracket = new MissingBracketLeft();
			missingLeftBracket.visible = false;
			missingLeftBracket.x = 0;
			missingLeftBracket.y = missingLeftBracket.height / 2;
			addChild(missingLeftBracket);
			
			missingRightBracket = new MissingBracketRight();
			missingRightBracket.visible = false;
			missingRightBracket.x = widthAxis;
			missingRightBracket.y = missingRightBracket.height / 2;
			addChild(missingRightBracket);
			
			if (lockPt) {
				bracketPoint.mouseEnabled = false;
			}else {
				bracketPoint.buttonMode = true;
			}
			
			if(lockBrackets){
				leftBracket.mouseEnabled = false;
				rightBracket.mouseEnabled = false;
			}else{
				leftBracket.buttonMode = true;
				rightBracket.buttonMode = true;
			}
			
			posicionaBrackets();
		}
		
		private function initDragBracketPoint(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, draggingBracketPoint);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraggingBracketPoint);
		}
		
		private function draggingBracketPoint(e:MouseEvent):void 
		{
			bracketPoint.x = Math.max(0, Math.min(widthAxis, this.mouseX));
			bracketPoint.eixoPt = axis.pixel2x(bracketPoint.x);
			posicionaBrackets();
			
			var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_X0, true);
			evt.propValue = bracketPoint.eixoPt;
			dispatchEvent(evt);
		}
		
		private function stopDraggingBracketPoint(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggingBracketPoint);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraggingBracketPoint);
		}
		
		private function posicionaBrackets():void
		{
			leftBracket.x = axis.x2pixel(bracketPoint.eixoPt - delta);
			rightBracket.x = axis.x2pixel(bracketPoint.eixoPt + delta);
			
			if (leftBracket.x < 0) {
				leftBracket.visible = false;
				missingLeftBracket.visible = true;
			}else {
				leftBracket.visible = true;
				missingLeftBracket.visible = false;
			}
			
			if (rightBracket.x > widthAxis) {
				rightBracket.visible = false;
				missingRightBracket.visible = true;
			}else {
				rightBracket.visible = true;
				missingRightBracket.visible = false;
			}
			
		}
		
		private var diffXpos:Number;
		private var dMax:Number;
		private var dMin:Number;
		private function initDragBracket(e:MouseEvent):void 
		{
			diffXpos = MovieClip(e.target).mouseX;
			if (e.target == leftBracket) dMax = bracketPoint.eixoPt - axis.pixel2x(10);
			else dMax = xmax - bracketPoint.eixoPt - (Math.abs(Math.abs(axis.pixel2x(10)) - Math.abs(axis.pixel2x(0))));
			dMin = Math.abs(Math.abs(axis.pixel2x(bracketPoint.x + 1)) - Math.abs(axis.pixel2x(bracketPoint.x)));
			//dMin = 0;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, draggingBracket);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraggingBracket);
		}
		
		private function draggingBracket(e:MouseEvent):void 
		{
			var newDelta:Number = Math.max(Point.distance(new Point(bracketPoint.eixoPt, 0), new Point(axis.pixel2x(this.mouseX - diffXpos), 0)));
			
			delta = Math.min(dMax , Math.max(dMin, newDelta));
			posicionaBrackets();
			
			var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_DELTA, true);
			evt.propValue = delta;
			dispatchEvent(evt);
		}
		
		private function stopDraggingBracket(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggingBracket);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraggingBracket);
		}
		
		public function setRange(xmin:Number, xmax:Number):void
		{
			this.xmin = xmin;
			this.xmax = xmax;
			axis.setRange(xmin, xmax);
			axis.draw();
			redefineAll();
		}
		
		public function verificaPontosFora():void
		{
			for each (var item:Ponto in pontos) 
			{
				if (item.x < 0 || item.x > widthAxis) item.visible = false;
				else item.visible = true;
			}
		}
		
		private function redefineAll():void 
		{
			bracketPoint.x = axis.x2pixel(bracketPoint.eixoPt);
			posicionaBrackets();
			for each (var item:Ponto in pontos) 
			{
				item.x = axis.x2pixel(item.eixoPt);
			}
			verificaPontosFora();
		}
		
		public function setPontoPosition(prop:String, pt:Number):void
		{
			var mcProp:Ponto = Ponto(this.getChildByName(prop));
			mcProp.eixoPt = pt;
			
			redefineAll();
		}
		
		public function getBracketX():Number
		{
			return bracketPoint.x;
		}
		
		public function getPontoPosition(prop:String):Number
		{
			var mcProp:Ponto = Ponto(this.getChildByName(prop));
			return mcProp.x;
		}
	}

}
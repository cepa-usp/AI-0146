package  
{
	import cepa.graph.rectangular.AxisX;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
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
		
		public var leftBracket:LeftBracket;
		public var rightBracket:RightBracket;
		private var bracketPoint:Ponto;
		
		//private var brackets:Array = [];
		private var pontos:Array = [];
		
		private var zoomInBtn:ZoomPlusBtn;
		private var zoomOutBtn:ZoomMinusBtn;
		
		private var lockList:Dictionary = new Dictionary();
		private var dinamicLockList:Dictionary = new Dictionary();
		private var deltaLock:Dictionary = new Dictionary();
		private var invisiblesEver:Dictionary = new Dictionary();
		
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
		
		public function adicionaPonto(nome:String, posX:Number, lock:Boolean = false, lockInDelta:Boolean = false ):void
		{
			var pt:Ponto = new Ponto();
			pt.name = nome;
			pt.nomeBase = nome;
			pt.eixoPt = posX;
			pontos.push(pt);
			pt.x = axis.x2pixel(posX);
			
			addChild(pt);
			
			pt.addEventListener(MouseEvent.MOUSE_DOWN, initDragPoint);
			pt.addEventListener(MouseEvent.MOUSE_OVER, showPtNumber);
			pt.addEventListener(MouseEvent.MOUSE_OUT, hidePtNumber);
			
			if (lock) {
				pt.buttonMode = false;
			}else {
				pt.buttonMode = true;
			}
			
			lockList[pt] = lock;
			if (lockInDelta) {
				deltaLock[pt] = true;
				if (pt.eixoPt > bracketPoint.eixoPt + delta || pt.eixoPt < bracketPoint.eixoPt - delta) {
					var deltaPt:Number = Math.random() * delta;
					if (Math.random() > 0.5) deltaPt *= -1;
					pt.x = axis.x2pixel(bracketPoint.eixoPt + deltaPt);
					pt.eixoPt = bracketPoint.eixoPt + deltaPt;
				}
			}
			
			if (nome == Model.FXO) {
				invisiblesEver[pt] = true;
				pt.visible = false;
			}
		}
		
		private var showingName:Boolean = false;
		private function showPtNumber(e:MouseEvent):void 
		{
			var pt:Ponto = Ponto(e.target);
			pt.setLabel(pt.nomeBase + " = " + pt.eixoPt.toFixed(2));
			showingName = true;
		}
		
		private function hidePtNumber(e:MouseEvent):void 
		{
			showingName = false;
			var pt:Ponto = Ponto(e.target);
			pt.setLabel(pt.nomeBase);
		}
		
		private var draggingPt:Ponto;
		private function initDragPoint(e:MouseEvent):void 
		{
			draggingPt = Ponto(e.target);
			
			if (lockList[draggingPt]) {
				draggingPt = null;
				return;
			}
			
			if (deltaLock[draggingPt]) stage.addEventListener(MouseEvent.MOUSE_MOVE, draggingPointLockedDelta);
			else stage.addEventListener(MouseEvent.MOUSE_MOVE, draggingPoint);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraggingPoint);
		}
		
		private function draggingPointLockedDelta(e:MouseEvent):void
		{
			var dmin:Number = Math.max(0, axis.x2pixel(bracketPoint.eixoPt - delta));
			var dmax:Number = Math.min(widthAxis, axis.x2pixel(bracketPoint.eixoPt + delta));
			
			draggingPt.x = Math.max(dmin, Math.min(dmax, this.mouseX));
			draggingPt.eixoPt = axis.pixel2x(draggingPt.x);
			
			if (showingName) {
				draggingPt.setLabel(draggingPt.nomeBase + " = " + draggingPt.eixoPt.toFixed(2));
			}
			
			if(draggingPt.name == Model.LAMBDA){
				var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_LAMBDA, true);
				evt.propValue = draggingPt.eixoPt;
				dispatchEvent(evt);
			}
		}
		
		private function draggingPoint(e:MouseEvent):void 
		{
			draggingPt.x = Math.max(0, Math.min(widthAxis, this.mouseX));
			draggingPt.eixoPt = axis.pixel2x(draggingPt.x);
			
			if (showingName) {
				draggingPt.setLabel(draggingPt.nomeBase + " = " + draggingPt.eixoPt.toFixed(2));
			}
			
			if(draggingPt.name == Model.LAMBDA){
				var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_LAMBDA, true);
				evt.propValue = draggingPt.eixoPt;
				dispatchEvent(evt);
			}
		}
		
		private function stopDraggingPoint(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggingPoint);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggingPointLockedDelta);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraggingPoint);
			draggingPt = null;
		}
		
		public function createBrackets(nome:String, centralPt:Number, delta:Number, lockPt:Boolean = false, lockBrackets:Boolean = false):void 
		{
			this.delta = delta;
			
			bracketPoint = new Ponto();
			bracketPoint.nomeBase = nome;
			bracketPoint.name = nome;
			bracketPoint.x = axis.x2pixel(centralPt);
			bracketPoint.eixoPt = centralPt;
			bracketPoint.addEventListener(MouseEvent.MOUSE_OVER, showPtNumber);
			bracketPoint.addEventListener(MouseEvent.MOUSE_OUT, hidePtNumber);
			
			leftBracket = new LeftBracket();
			rightBracket = new RightBracket();
			
			bracketPoint.addEventListener(MouseEvent.MOUSE_DOWN, initDragBracketPoint);
			leftBracket.addEventListener(MouseEvent.MOUSE_DOWN, initDragBracket);
			rightBracket.addEventListener(MouseEvent.MOUSE_DOWN, initDragBracket);
			
			if (lockPt) {
				addChild(bracketPoint);
				addChild(leftBracket);
				addChild(rightBracket);
				
				bracketPoint.buttonMode = false;
			}else {
				addChild(leftBracket);
				addChild(rightBracket);
				addChild(bracketPoint);
				
				bracketPoint.buttonMode = true;
			}
			
			lockList[bracketPoint] = lockPt;
			
			if (lockBrackets) {
				leftBracket.buttonMode = false;
				rightBracket.buttonMode = false;
			}else{
				leftBracket.buttonMode = true;
				rightBracket.buttonMode = true;
			}
			
			lockList[leftBracket] = lockBrackets;
			lockList[rightBracket] = lockBrackets;
			
			posicionaBrackets();
		}
		
		private function initDragBracketPoint(e:MouseEvent):void 
		{
			if (lockList[bracketPoint]) return;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, draggingBracketPoint);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraggingBracketPoint);
		}
		
		private function draggingBracketPoint(e:MouseEvent):void 
		{
			bracketPoint.x = Math.max(0, Math.min(widthAxis, this.mouseX));
			bracketPoint.eixoPt = axis.pixel2x(bracketPoint.x);
			
			if (showingName) {
				bracketPoint.setLabel(bracketPoint.nomeBase + " = " + bracketPoint.eixoPt.toFixed(2));
			}
			
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
		
		private var offsetBracketsOffScreen:Number = 10;
		private function posicionaBrackets():void
		{
			var leftX:Number = axis.x2pixel(bracketPoint.eixoPt - delta);
			var rightX:Number = axis.x2pixel(bracketPoint.eixoPt + delta);
			
			if (leftX < 10) {
				leftBracket.x = -offsetBracketsOffScreen;
				leftBracket.alpha = 0.5;
				if(!lockList[leftBracket]){
					leftBracket.buttonMode = false;
					dinamicLockList[leftBracket] = true;
				}
			}else {
				leftBracket.x = leftX;
				leftBracket.alpha = 1;
				if(!lockList[leftBracket]){
					leftBracket.buttonMode = true;
					dinamicLockList[leftBracket] = false;
				}
			}
			
			if (rightX > widthAxis - 10) {
				rightBracket.x = widthAxis + offsetBracketsOffScreen;
				rightBracket.alpha = 0.5;
				if(!lockList[rightBracket]){
					rightBracket.buttonMode = false;
					dinamicLockList[rightBracket] = true;
				}
			}else {
				rightBracket.x = rightX;
				rightBracket.alpha = 1;
				if(!lockList[rightBracket]){
					rightBracket.buttonMode = true;
					dinamicLockList[rightBracket] = false;
				}
			}
			
			for each (var item:Ponto in pontos) 
			{
				if (deltaLock[item]) {
					var changes:Boolean = false;
					if (item.x < leftBracket.x) {
						item.x = leftBracket.x;
						item.eixoPt = axis.pixel2x(item.x);
						changes = true;
					}else if (item.x > rightBracket.x) {
						item.x = rightBracket.x;
						item.eixoPt = axis.pixel2x(item.x);
						changes = true;
					}
					if (changes) {
						if(item.name == Model.LAMBDA){
							var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_LAMBDA, true);
							evt.propValue = item.eixoPt;
							dispatchEvent(evt);
						}
					}
				}
			}
			
		}
		
		private var diffXpos:Number;
		private var dMax:Number;
		private var dMin:Number;
		private function initDragBracket(e:MouseEvent):void 
		{
			var bracketDrag:MovieClip = MovieClip(e.target);
			
			if (lockList[bracketDrag] || dinamicLockList[bracketDrag]) return;
			
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
				else {
					if(invisiblesEver[item] == null) item.visible = true;
				}
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
		
		public function getProperty(prop:String):Sprite
		{
			var mcProp:Ponto = Ponto(this.getChildByName(prop));
			
			return mcProp;
		}
	}

}
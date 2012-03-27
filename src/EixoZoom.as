package  
{
	import cepa.graph.rectangular.AxisX;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
		private var sprDelta:Sprite;
		private var deltaNome:String;
		public var deltaLabel:TextField;
		
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
			trace(e.target);
			if(e.target is Ponto){
				var pt:Ponto = Ponto(e.target);
				pt.setLabel(pt.nomeBase + " = " + pt.eixoPt.toFixed(2));
				showingName = true;
			}else {
				var txt:TextField = TextField(e.target);
				txt.width = 200;
				txt.text = deltaNome + " = " + delta.toFixed(2);
				txt.width = txt.textWidth + 5;
			}
		}
		
		private function hidePtNumber(e:MouseEvent):void 
		{
			if(e.target is Ponto){
				showingName = false;
				var pt:Ponto = Ponto(e.target);
				pt.setLabel(pt.nomeBase);
			}else {
				var txt:TextField = TextField(e.target);
				txt.width = 200;
				txt.text = deltaNome;
				txt.width = txt.textWidth + 5;
			}
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
		
		public function createBrackets(nome:String, centralPt:Number, delta:Number, deltaNome:String, lockPt:Boolean = false, lockBrackets:Boolean = false):void 
		{
			this.delta = delta;
			
			sprDelta = new Sprite();
			addChild(sprDelta);
			this.deltaNome = deltaNome;
			
			deltaLabel = new TextField();
			deltaLabel.defaultTextFormat = new TextFormat("Times New Roman", 15, 0x7B5A15);
			deltaLabel.multiline = false;
			deltaLabel.width = 200;
			deltaLabel.text = deltaNome;
			deltaLabel.width = deltaLabel.textWidth + 5;
			deltaLabel.height = deltaLabel.textHeight;
			deltaLabel.selectable = false;
			addChild(deltaLabel);
			deltaLabel.addEventListener(MouseEvent.MOUSE_OVER, showPtNumber);
			deltaLabel.addEventListener(MouseEvent.MOUSE_OUT, hidePtNumber);
			
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
		
		private var offsetBracketsOffScreen:Number = 20;
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
			
			drawDelta();
		}
		
		private var widthArrow:Number = 10;
		private var heightArrow:Number = 10;
			
		private function drawDelta():void
		{
			var yAdjust:Number = 30;
			var sprHalfWidth:Number;
			
			sprDelta.graphics.clear();
			sprDelta.graphics.lineStyle(1, 0x000080);
			sprDelta.graphics.moveTo(bracketPoint.x, bracketPoint.y - yAdjust);
			
			if (rightBracket.x < widthAxis) {
				drawleftArrow(bracketPoint.x, bracketPoint.y - yAdjust);
				sprDelta.graphics.lineTo(rightBracket.x, rightBracket.y - yAdjust);
				drawRightArrow(rightBracket.x, rightBracket.y - yAdjust);
				sprHalfWidth = sprDelta.width / 2;
			}else if (leftBracket.x > 0) {
				drawRightArrow(bracketPoint.x, bracketPoint.y - yAdjust);
				sprDelta.graphics.lineTo(leftBracket.x, leftBracket.y - yAdjust);
				drawleftArrow(leftBracket.x, leftBracket.y - yAdjust);
				sprHalfWidth = -sprDelta.width / 2;
			}else {
				drawleftArrow(bracketPoint.x, bracketPoint.y - yAdjust);
				sprDelta.graphics.lineTo(widthAxis, bracketPoint.y - yAdjust);
				dashTo(widthAxis, bracketPoint.y - yAdjust, rightBracket.x, bracketPoint.y - yAdjust, 2, 2, sprDelta);
				drawRightArrow(rightBracket.x, rightBracket.y - yAdjust);
				sprHalfWidth = sprDelta.width / 2;
			}
			
			deltaLabel.x = bracketPoint.x + sprHalfWidth - deltaLabel.width / 2;
			deltaLabel.y = bracketPoint.y - yAdjust - deltaLabel.height - 5;
		}
		
		private function drawleftArrow(ptX:Number, ptY:Number):void
		{
			sprDelta.graphics.curveTo(ptX + heightArrow / 2, ptY, ptX + heightArrow, ptY - widthArrow / 2);
			sprDelta.graphics.moveTo(ptX, ptY);
			sprDelta.graphics.curveTo(ptX + heightArrow / 2, ptY, ptX + heightArrow, ptY + widthArrow / 2);
			sprDelta.graphics.moveTo(ptX, ptY);
		}
		
		private function drawRightArrow(ptX:Number, ptY:Number):void
		{
			sprDelta.graphics.curveTo(ptX - heightArrow / 2, ptY, ptX - heightArrow, ptY - widthArrow / 2);
			sprDelta.graphics.moveTo(ptX, ptY);
			sprDelta.graphics.curveTo(ptX - heightArrow / 2, ptY, ptX - heightArrow, ptY + widthArrow / 2);
			sprDelta.graphics.moveTo(ptX, ptY);
		}
		
		/*
		 * A função dashTo desenha uma linha tracejada.
		 * 
		 * by Ric Ewing (ric@formequalsfunction.com) - version 1.2 - 5.3.2002
		 * 
		 * startx, starty = beginning of dashed line
		 * endx, endy = end of dashed line
		 * len = length of dash
		 * gap = length of gap between dashes
		 */
		private function dashTo (startx:Number, starty:Number, endx:Number, endy:Number, len:Number, gap:Number, spr:Sprite) : void {
			
			// init vars
			var seglength, delta, deltax, deltay, segs, cx, cy, radians;
			// calculate the legnth of a segment
			seglength = len + gap;
			// calculate the length of the dashed line
			deltax = endx - startx;
			deltay = endy - starty;
			delta = Math.sqrt((deltax * deltax) + (deltay * deltay));
			// calculate the number of segments needed
			segs = Math.floor(Math.abs(delta / seglength));
			// get the angle of the line in radians
			radians = Math.atan2(deltay,deltax);
			// start the line here
			cx = startx;
			cy = starty;
			// add these to cx, cy to get next seg start
			deltax = Math.cos(radians)*seglength;
			deltay = Math.sin(radians)*seglength;
			// loop through each seg
			for (var n = 0; n < segs; n++) {
				spr.graphics.moveTo(cx,cy);
				spr.graphics.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
				cx += deltax;
				cy += deltay;
			}
			// handle last segment as it is likely to be partial
			spr.graphics.moveTo(cx,cy);
			delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
			if(delta>len){
				// segment ends in the gap, so draw a full dash
				spr.graphics.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
			} else if(delta>0) {
				// segment is shorter than dash so only draw what is needed
				spr.graphics.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
			}
			// move the pen to the end position
			spr.graphics.moveTo(endx,endy);
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
					if (invisiblesEver[item] == null) item.visible = true;
					else item.visible = !invisiblesEver[item];
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
		
		public function setLock(prop:String, value:Boolean):void
		{
			var mcProp:Ponto = Ponto(this.getChildByName(prop));
			
			lockList[mcProp] = value;
			redefineAll();
		}
		
		public function setVisible(prop:String, value:Boolean):void
		{
			var mcProp:Ponto = Ponto(this.getChildByName(prop));
			
			invisiblesEver[mcProp] = value;
			redefineAll();
		}
	}

}
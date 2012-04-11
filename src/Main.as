package 
{
	import BaseAssets.BaseMain;
	import cepa.graph.rectangular.AxisX;
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends BaseMain 
	{
		/**
		 * Modelo da atividade, onde contém todos os parâmtros utilizados pelo view para definir as posições dos objetos.
		 */
		private var modelo:Model = new Model();
		private var axisX1:EixoZoom;
		private var axisX2:EixoZoom;
		
		private var lambdaFlambda:Sprite;
		private var x0Fx0:Sprite;
		
		private var indicadorLambda:IndicadorF;
		private var indicadorX0:IndicadorF;
		
		private var indicadorLambda2:IndicadorF2;
		private var indicadorX02:IndicadorF2;
		
		private var indicadorDownX0:IndicadorFDown;
		private var indicadorDownLambda:IndicadorFDown;
		
		private var indicadorUpX0:IndicadorFUp;
		private var indicadorUpLambda:IndicadorFUp;
		
		private var nomeFx0:NomeF;
		private var nomeFlambda:NomeF;
		
		private var textoExplicativo:TextoExplicativo;
		private var showAnswer:Boolean = false;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			initModelParams();
			addListerners();
			addListenersTextoExplicativo();
			setExternalInterface();
			
		}
		
		private function setExternalInterface():void 
		{
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("lockLambda", lockLambda);
				ExternalInterface.addCallback("lockX0", lockX0);
				ExternalInterface.addCallback("lockDelta", lockDelta);
				
				ExternalInterface.addCallback("lockL", lockL);
				ExternalInterface.addCallback("lockEpsilon", lockEpsilon);
				
				ExternalInterface.addCallback("setLambda", setLambda);
				ExternalInterface.addCallback("getLambda", getLambda);
				ExternalInterface.addCallback("setX0", setX0);
				ExternalInterface.addCallback("getX0", getX0);
				ExternalInterface.addCallback("setDelta", setDelta);
				ExternalInterface.addCallback("getDelta", getDelta);
				
				ExternalInterface.addCallback("setL", setL);
				ExternalInterface.addCallback("getL", getL);
				ExternalInterface.addCallback("setEpsilon", setEpsilon);
				ExternalInterface.addCallback("getEpsilon", getEpsilon);
				
				ExternalInterface.addCallback("doNothing", doNothing);
			}
		}
		
		public function doNothing():void
		{
			
		}
		
		private function setLambda(value:Number):void 
		{
			axisX1.setPontoPosition(Model.LAMBDA, value);
		}
		
		private function getLambda():Number
		{
			return Ponto(axisX1.getProperty(Model.LAMBDA)).eixoPt;
		}
		
		private function setX0(value:Number):void 
		{
			axisX1.setPontoPosition(Model.XO, value);
		}
		
		private function getX0():Number
		{
			return Ponto(axisX1.getProperty(Model.XO)).eixoPt;
		}
		
		private function setDelta(value:Number):void 
		{
			axisX1.setDelta(value);
		}
		
		private function getDelta():Number
		{
			return axisX1.getDelta();
		}
		
		private function setL(value:Number):void 
		{
			axisX2.setPontoPosition(Model.PT_L, value);
		}
		
		private function getL():Number
		{
			return Ponto(axisX2.getProperty(Model.PT_L)).eixoPt;
		}
		
		private function setEpsilon(value:Number):void 
		{
			axisX2.setDelta(value);
		}
		
		private function getEpsilon():Number 
		{
			return axisX2.getDelta();
		}
		
		private function lockLambda(value:Boolean):void
		{
			axisX1.setLock(Model.LAMBDA, value);
		}
		
		private function lockX0(value:Boolean):void
		{
			axisX1.setLock(Model.XO, value);
		}
		
		private function lockDelta(value:Boolean):void
		{
			axisX1.lockDelta(value);
		}
		
		private function lockL(value:Boolean):void
		{
			axisX2.setLock(Model.PT_L, value);
		}
		
		private function lockEpsilon(value:Boolean):void
		{
			axisX2.lockDelta(value);
		}
		
		private function initModelParams():void 
		{
			modelo.lambda = 3;
			modelo.x0 = 4;
			modelo.delta = 2;
			modelo.ptL = 5;
			modelo.epsilon = 1;
			
			axisX1 = new EixoZoom(0, 5, 500);
			axisX2 = new EixoZoom(0, 10, 500);
			
			//axisX1.rotation = -90;
			addChild(axisX1);
			axisX1.x = 100;
			axisX1.y = 200;
			addChild(axisX2);
			axisX2.x = 100;
			axisX2.y = 500;
			
			axisX1.createBrackets(Model.XO, modelo.x0, modelo.delta, Model.DELTA, true);
			axisX1.adicionaPonto(Model.LAMBDA, modelo.lambda, false, true);
			
			axisX2.createBrackets(Model.PT_L, modelo.ptL, modelo.epsilon, Model.EPSILON, false, true);
			axisX2.adicionaPonto(Model.FXO, modelo.fX0, true);
			axisX2.adicionaPonto(Model.FLAMBDA, modelo.fLambda, true);
			
			lambdaFlambda = new Sprite();
			addChild(lambdaFlambda);
			x0Fx0 = new Sprite();
			addChild(x0Fx0);
			x0Fx0.visible = showAnswer;
			
			indicadorLambda = new IndicadorF();
			addChild(indicadorLambda);
			indicadorLambda.visible = false;
			
			indicadorLambda2 = new IndicadorF2();
			addChild(indicadorLambda2);
			indicadorLambda2.visible = false;
			
			indicadorX0 = new IndicadorF();
			addChild(indicadorX0);
			indicadorX0.visible = showAnswer;
			
			indicadorX02 = new IndicadorF2();
			addChild(indicadorX02);
			indicadorX02.visible = showAnswer;
			
			indicadorUpX0 = new IndicadorFUp();
			addChild(indicadorUpX0);
			indicadorUpX0.visible = false;
			
			indicadorUpLambda = new IndicadorFUp();
			addChild(indicadorUpLambda);
			indicadorUpLambda.visible = showAnswer;
			
			indicadorDownX0 = new IndicadorFDown();
			addChild(indicadorDownX0);
			indicadorDownX0.visible = false;
			
			indicadorDownLambda = new IndicadorFDown();
			addChild(indicadorDownLambda);
			indicadorDownLambda.visible = showAnswer;
			
			nomeFx0 = new NomeF();
			addChild(nomeFx0);
			nomeFx0.visible = showAnswer;
			
			nomeFlambda = new NomeF();
			addChild(nomeFlambda);
			nomeFlambda.visible = false;
			
			redesenhaIndicadores();
			
			textoExplicativo = new TextoExplicativo();
			addChild(textoExplicativo);
			setChildIndex(textoExplicativo, 0);
			textoExplicativo.y = stage.stageHeight - textoExplicativo.height - 5;
			setMessage("");
		}
		
		private function addListerners():void 
		{
			modelo.evtDispatcher.addEventListener(ModelEvent.CHANGE_FUNCTION, changeFunction);
			
			modelo.evtDispatcher.addEventListener(ModelEvent.CHANGE_FX0, updateFx0);
			modelo.evtDispatcher.addEventListener(ModelEvent.CHANGE_FLAMBDA, updateFlambda);
			
			axisX1.addEventListener(ModelEvent.CHANGE_X0, changeModelX0);
			axisX2.addEventListener(ModelEvent.CHANGE_X0, changeModelL);
			axisX1.addEventListener(ModelEvent.CHANGE_LAMBDA, changeModelLambda);
			axisX1.addEventListener(ModelEvent.CHANGE_DELTA, changeModelDelta);
			axisX2.addEventListener(ModelEvent.CHANGE_DELTA, changeModelEpsilon);
			
			axisX1.addEventListener(ModelEvent.CHANGE_ZOOM, redesenhaIndicadores);
			axisX2.addEventListener(ModelEvent.CHANGE_ZOOM, redesenhaIndicadores);
		}
		
		private function addListenersTextoExplicativo():void 
		{
			axisX1.getProperty(Model.LAMBDA).addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("lambda é um ponto da vizinhança de x_0.") } );
			axisX1.getProperty(Model.XO).addEventListener(MouseEvent.MOUSE_OVER, function():void { setMessage("x_0 é valor do qual lambda se aproxima indefinidamente.") } );
			axisX1.deltaLabel.addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("delta é o tamanho da vizinhança de x_0.") } );
			axisX1.leftBracket.addEventListener(MouseEvent.MOUSE_OVER, function():void { 
				if (axisX1.leftBracket.x < 0) setMessage("limite inferior de x_0(não visível).");
				else setMessage("limite inferior de x_0.");
			} );
			axisX1.rightBracket.addEventListener(MouseEvent.MOUSE_OVER, function():void { 
				if (axisX1.rightBracket.x > axisX1.widthAxis) setMessage("limite superior de x_0(não visível).");
				else setMessage("limite superior de x_0.");
			} );
			
			axisX2.getProperty(Model.FLAMBDA).addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("f(lambda) é o valor de f, calculado em x = lambda.") } );
			axisX2.getProperty(Model.FXO).addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("f(x_0) é o valor de f, calculado em x = x_0.") } );
			axisX2.getProperty(Model.PT_L).addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("L é o limite procurado.") } );
			axisX2.deltaLabel.addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("epsilon é o tamanho da vizinhança de L.") } );
			axisX2.leftBracket.addEventListener(MouseEvent.MOUSE_OVER, function():void {
				if (axisX2.leftBracket.x < 0) setMessage("limite inferior de L(não visível).");
				else setMessage("limite inferior de L.");
			} );
			axisX2.rightBracket.addEventListener(MouseEvent.MOUSE_OVER, function():void {
				if (axisX2.rightBracket.x > axisX2.widthAxis) setMessage("limite superior de L(não visível).");
				else setMessage("limite superior de L.");
			} );
			
			stage.addEventListener(MouseEvent.MOUSE_OUT, setLabelOfState);
			
			botoes.tutorialBtn.addEventListener(MouseEvent.MOUSE_OVER, function():void { setMessage("Reinicia o tutorial (balões).")});
			botoes.orientacoesBtn.addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("Orientações e objetivos pedagógicos.")});
			botoes.resetButton.addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("Reinicia a atividade interativa (retoma a situação inicial).")});
			botoes.creditos.addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("Licença e créditos desta atividade interativa.")});
		}
		
		private function setLabelOfState(e:MouseEvent):void
		{
			setMessage("");
		}
		
		private function setMessage(msg:String):void
		{
			textoExplicativo.texto.text = msg;
		}
		
		private function desenhaIndicadorXfX():void 
		{
			var posX0:Point = new Point(axisX1.getBracketX() + axisX1.x, axisX1.y);
			var posFx0:Point = new Point(axisX2.getPontoPosition(Model.FXO) + axisX2.x, axisX2.y);
			var distToPoint:Number = 20;
			
			if (posX0.x < axisX1.x) {
				if (posFx0.x < axisX1.x || posFx0.x > axisX1.x + axisX1.widthAxis) {
					
				}else {
					indicadorX02.x = posFx0.x;
					indicadorX02.y = posFx0.y - distToPoint;
					indicadorX02.scaleX = 1;
					indicadorX02.nome.scaleX = 1;
					indicadorX02.visible = showAnswer;
				}
			}else if (posX0.x > axisX1.x + axisX1.widthAxis) {
				if (posFx0.x < axisX1.x || posFx0.x > axisX1.x + axisX1.widthAxis) {
					
				}else {
					indicadorX02.x = posFx0.x;
					indicadorX02.y = posFx0.y - distToPoint;
					indicadorX02.scaleX = -1;
					indicadorX02.nome.scaleX = -1;
					indicadorX02.visible = showAnswer;
				}
			}else {
				if (posFx0.x < axisX1.x) {
					indicadorX0.x = posX0.x;
					indicadorX0.y = posX0.y + distToPoint;
					indicadorX0.scaleX = 1;
					indicadorX0.nome.scaleX = 1;
					indicadorX0.visible = showAnswer;
				}else if (posFx0.x > axisX1.x + axisX1.widthAxis) {
					indicadorX0.x = posX0.x;
					indicadorX0.y = posX0.y + distToPoint;
					indicadorX0.scaleX = -1;
					indicadorX0.nome.scaleX = -1;
					indicadorX0.visible = showAnswer;
				}else {
					x0Fx0.visible = showAnswer;
					x0Fx0.graphics.clear();
					x0Fx0.graphics.beginFill(0x800000);
					x0Fx0.graphics.drawCircle(posX0.x, posX0.y + distToPoint, 3);
					x0Fx0.graphics.endFill();
					x0Fx0.graphics.lineStyle(2, 0x800000);
					x0Fx0.graphics.moveTo(posX0.x, posX0.y + distToPoint);
					x0Fx0.graphics.curveTo(posX0.x, (posFx0.y - posX0.y)/2 + posX0.y - distToPoint/2, (posFx0.x - posX0.x) / 2 + posX0.x, (posFx0.y - posX0.y)/2 + posX0.y - distToPoint / 2);
					x0Fx0.graphics.curveTo(posFx0.x, (posFx0.y - posX0.y)/2 + posX0.y - distToPoint/2, posFx0.x, posFx0.y - distToPoint);
					x0Fx0.graphics.lineTo(posFx0.x - 5, posFx0.y - distToPoint - 15);
					x0Fx0.graphics.lineTo(posFx0.x + 5, posFx0.y - distToPoint - 15);
					x0Fx0.graphics.lineTo(posFx0.x, posFx0.y - distToPoint);
					nomeFx0.x = (posFx0.x - posX0.x) / 2 + posX0.x;
					nomeFx0.y = (posFx0.y - posX0.y) / 2 + posX0.y - distToPoint / 2;
					nomeFx0.visible = showAnswer;
				}
			}
		}
		
		public function setShowAnswer(value:Boolean):void
		{
			showAnswer = value;
			axisX2.setVisible(Model.FXO, !showAnswer);
			redesenhaIndicadores();
		}
		
		private function desenhaIndicadorLambdafLambda():void 
		{
			var posLambda:Point = new Point(axisX1.getPontoPosition(Model.LAMBDA) + axisX1.x, axisX1.y);
			var posFlambda:Point = new Point(axisX2.getPontoPosition(Model.FLAMBDA) + axisX2.x, axisX2.y);
			var distToPoint:Number = 20;
			
			if (posLambda.x < axisX1.x) {
				if (posFlambda.x < axisX1.x || posFlambda.x > axisX1.x + axisX1.widthAxis) {
					
				}else {
					indicadorLambda2.x = posFlambda.x;
					indicadorLambda2.y = posFlambda.y - distToPoint;
					indicadorLambda2.scaleX = 1;
					indicadorLambda2.nome.scaleX = 1;
					indicadorLambda2.visible = true;
				}
			}else if (posLambda.x > axisX1.x + axisX1.widthAxis) {
				if (posFlambda.x < axisX1.x || posFlambda.x > axisX1.x + axisX1.widthAxis) {
					
				}else {
					indicadorLambda2.x = posFlambda.x;
					indicadorLambda2.y = posFlambda.y - distToPoint;
					indicadorLambda2.scaleX = -1;
					indicadorLambda2.nome.scaleX = -1;
					indicadorLambda2.visible = true;
				}
			}else {
				if (posFlambda.x < axisX1.x) {
					indicadorLambda.x = posLambda.x;
					indicadorLambda.y = posLambda.y + distToPoint;
					indicadorLambda.scaleX = 1;
					indicadorLambda.nome.scaleX = 1;
					indicadorLambda.visible = true;
				}else if (posFlambda.x > axisX1.x + axisX1.widthAxis) {
					indicadorLambda.x = posLambda.x;
					indicadorLambda.y = posLambda.y + distToPoint;
					indicadorLambda.scaleX = -1;
					indicadorLambda.nome.scaleX = -1;
					indicadorLambda.visible = true;
				}else {
					lambdaFlambda.graphics.clear();
					lambdaFlambda.graphics.beginFill(0x800000);
					lambdaFlambda.graphics.drawCircle(posLambda.x, posLambda.y + distToPoint, 3);
					lambdaFlambda.graphics.endFill();
					lambdaFlambda.graphics.lineStyle(2, 0x800000);
					lambdaFlambda.graphics.moveTo(posLambda.x, posLambda.y + distToPoint);
					lambdaFlambda.graphics.curveTo(posLambda.x, (posFlambda.y - posLambda.y)/2 + posLambda.y - distToPoint/2, (posFlambda.x - posLambda.x) / 2 + posLambda.x, (posFlambda.y - posLambda.y)/2 + posLambda.y - distToPoint / 2);
					lambdaFlambda.graphics.curveTo(posFlambda.x, (posFlambda.y - posLambda.y)/2 + posLambda.y - distToPoint/2, posFlambda.x, posFlambda.y - distToPoint);
					lambdaFlambda.graphics.lineTo(posFlambda.x - 5, posFlambda.y - distToPoint - 15);
					lambdaFlambda.graphics.lineTo(posFlambda.x + 5, posFlambda.y - distToPoint - 15);
					lambdaFlambda.graphics.lineTo(posFlambda.x, posFlambda.y - distToPoint);
					nomeFlambda.x = (posFlambda.x - posLambda.x) / 2 + posLambda.x;
					nomeFlambda.y = (posFlambda.y - posLambda.y) / 2 + posLambda.y - distToPoint / 2;
					nomeFlambda.visible = true;
				}
			}
		}
		
		private function redesenhaIndicadores(e:ModelEvent = null):void 
		{
			lambdaFlambda.graphics.clear();
			nomeFlambda.visible = false;
			indicadorLambda.visible = false;
			indicadorLambda2.visible = false;
			
			indicadorDownX0.visible = false;
			indicadorDownLambda.visible = showAnswer;
			indicadorUpX0.visible = false;
			indicadorUpLambda.visible = showAnswer;
			
			x0Fx0.graphics.clear();
			x0Fx0.visible = showAnswer;
			nomeFx0.visible = false;
			indicadorX0.visible = false;
			indicadorX02.visible = false;
			
			if(eixosParalelos){
				desenhaIndicadorXfX();
				desenhaIndicadorLambdafLambda();
			}else {
				desenhaIndicadorXfX2();
				desenhaIndicadorLambdafLambda2();
			}
			axisX1.verificaPontosFora();
			axisX2.verificaPontosFora();
		}
		
		private function desenhaIndicadorXfX2():void 
		{
			var posX0:Point = new Point(axisX1.getBracketX() + axisX1.x, axisX1.y);
			var posFx0:Point = new Point(axisX2.x, axisX2.y - axisX2.getPontoPosition(Model.FXO));
			var distToPoint:Number = 20;
			
			x0Fx0.visible = showAnswer;
			x0Fx0.graphics.clear();
			x0Fx0.graphics.lineStyle(2, 0x800000);
			
			
			if((posX0.x > axisX1.x) && (posX0.x < axisX1.x + axisX1.widthAxis)){
				if (posFx0.y < axisX2.y && posFx0.y > axisX2.y - axisX2.widthAxis) {//Ambos dentro da tela.
					x0Fx0.graphics.moveTo(posX0.x, posX0.y - distToPoint);
					x0Fx0.graphics.lineTo(posX0.x, posFx0.y);
					x0Fx0.graphics.beginFill(0x800000);
					x0Fx0.graphics.drawCircle(posX0.x, posFx0.y, 2);
					x0Fx0.graphics.endFill();
					x0Fx0.graphics.lineTo(posFx0.x + distToPoint, posFx0.y);
				}else {//f(x0) fora da tela.
					indicadorUpX0.x = posX0.x;
					indicadorUpX0.y = posX0.y - distToPoint;
					indicadorUpX0.visible = showAnswer;
				}
			}else {
				if (posFx0.y < axisX2.y && posFx0.y > axisX2.y - axisX2.widthAxis) {//Apenas f(x0) dentro da tela.
					indicadorDownX0.x = posFx0.x + distToPoint;
					indicadorDownX0.y = posFx0.y;
					indicadorDownX0.visible = showAnswer;
				}
			}
		}
		
		private function desenhaIndicadorLambdafLambda2():void 
		{
			var posLambda:Point = new Point(axisX1.getPontoPosition(Model.LAMBDA) + axisX1.x, axisX1.y);
			var posFlambda:Point = new Point(axisX2.x, axisX2.y - axisX2.getPontoPosition(Model.FLAMBDA));
			var distToPoint:Number = 20;
			
			lambdaFlambda.graphics.clear();
			lambdaFlambda.graphics.lineStyle(2, 0x800000);
			
			if((posLambda.x > axisX1.x) && (posLambda.x < axisX1.x + axisX1.widthAxis)){
				if (posFlambda.y < axisX2.y && posFlambda.y > axisX2.y - axisX2.widthAxis) {//Ambos dentro da tela.
					lambdaFlambda.graphics.moveTo(posLambda.x, posLambda.y - distToPoint);
					lambdaFlambda.graphics.lineTo(posLambda.x, posFlambda.y);
					lambdaFlambda.graphics.beginFill(0x800000);
					lambdaFlambda.graphics.drawCircle(posLambda.x, posFlambda.y, 2);
					lambdaFlambda.graphics.endFill();
					lambdaFlambda.graphics.lineTo(posFlambda.x + distToPoint, posFlambda.y);
				}else {//f(lambda) fora da tela.
					indicadorUpLambda.x = posLambda.x;
					indicadorUpLambda.y = posLambda.y - distToPoint;
					indicadorUpLambda.visible = true;
				}
			}else {
				if (posFlambda.y < axisX2.y && posFlambda.y > axisX2.y - axisX2.widthAxis) {//Apenas f(lambda) dentro da tela.
					indicadorDownLambda.x = posFlambda.x + distToPoint;
					indicadorDownLambda.y = posFlambda.y;
					indicadorDownLambda.visible = true;
				}
			}
		}
		
		private function changeModelL(e:ModelEvent):void 
		{
			modelo.ptL = e.propValue;
		}
		
		private function changeModelDelta(e:ModelEvent):void 
		{
			modelo.delta = e.propValue;
		}
		
		private function changeModelEpsilon(e:ModelEvent):void 
		{
			modelo.epsilon = e.propValue;
		}
		
		private function changeModelX0(e:ModelEvent):void 
		{
			modelo.x0 = e.propValue;
		}
		
		private function changeModelLambda(e:ModelEvent):void 
		{
			modelo.lambda = e.propValue;
		}
		
		private function updateFlambda(e:ModelEvent):void 
		{
			axisX2.setPontoPosition(Model.FLAMBDA, modelo.fLambda);
			redesenhaIndicadores();
		}
		
		private function updateFx0(e:ModelEvent):void 
		{
			axisX2.setPontoPosition(Model.FXO, modelo.fX0);
			redesenhaIndicadores();
		}
		
		private function changeFunction(e:ModelEvent):void 
		{
			updateFlambda(null);
			updateFx0(null);
		}
		
		
		/**
		 * Reset da atividade.
		 */
		override public function reset(e:MouseEvent = null):void
		{
			//setShowAnswer(!showAnswer);
			changeAxisVisualization();
		}
		
		private var eixosParalelos:Boolean = true;1
		private function changeAxisVisualization():void 
		{
			indicadorLambda.visible = false;
			indicadorLambda2.visible = false;
			lambdaFlambda.graphics.clear();
			nomeFlambda.visible = false;
			
			indicadorX0.visible = false;
			indicadorX02.visible = false;
			x0Fx0.graphics.clear();
			nomeFx0.visible = false;
			
			indicadorDownLambda.visible = false;
			indicadorDownX0.visible = false;
			indicadorUpLambda.visible = false;
			indicadorUpX0.visible = false;
			
			if (eixosParalelos) {
				eixosParalelos = !eixosParalelos;
				axisX1.yAdjust *= -1;
				axisX1.drawDelta();
				Actuate.tween(axisX1, 0.5, { x: 130, y: 600} ).ease(Linear.easeNone);
				Actuate.tween(axisX2, 0.5, { x: 80, y:550, rotation: -90 } ).ease(Linear.easeNone).onComplete(redesenhaIndicadores);
			}else {
				eixosParalelos = !eixosParalelos;
				axisX1.yAdjust *= -1;
				axisX1.drawDelta();
				Actuate.tween(axisX1, 0.5, { x: 100, y: 200} ).ease(Linear.easeNone);
				Actuate.tween(axisX2, 0.5, { x: 100, y:500, rotation: 0 } ).ease(Linear.easeNone).onComplete(redesenhaIndicadores);
			}
			
		}
		
	}
	
}
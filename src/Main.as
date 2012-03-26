package 
{
	import BaseAssets.BaseMain;
	import cepa.graph.rectangular.AxisX;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
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
		
		private var nomeFx0:NomeF;
		private var nomeFlambda:NomeF;
		
		private var textoExplicativo:TextoExplicativo;
		
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
		}
		
		private function initModelParams():void 
		{
			modelo.lambda = 3;
			modelo.x0 = 4;
			modelo.delta = 2;
			modelo.ptL = 5;
			modelo.epsilon = 1;
			
			axisX1 = new EixoZoom(0, 5, 600);
			axisX2 = new EixoZoom(0, 10, 600);
			
			addChild(axisX1);
			axisX1.x = (stage.stageWidth - axisX1.width) / 2;
			axisX1.y = 100;
			addChild(axisX2);
			axisX2.x = (stage.stageWidth - axisX2.width) / 2;
			axisX2.y = 300;
			
			axisX1.createBrackets(Model.XO, modelo.x0, modelo.delta, true);
			axisX1.adicionaPonto(Model.LAMBDA, modelo.lambda, false, true);
			
			axisX2.createBrackets(Model.PT_L, modelo.ptL, modelo.epsilon, false, true);
			axisX2.adicionaPonto(Model.FXO, modelo.fX0, true);
			axisX2.adicionaPonto(Model.FLAMBDA, modelo.fLambda, true);
			
			lambdaFlambda = new Sprite();
			addChild(lambdaFlambda);
			x0Fx0 = new Sprite();
			//addChild(x0Fx0);
			
			indicadorLambda = new IndicadorF();
			addChild(indicadorLambda);
			indicadorLambda.visible = false;
			
			indicadorLambda2 = new IndicadorF2();
			addChild(indicadorLambda2);
			indicadorLambda2.visible = false;
			
			indicadorX0 = new IndicadorF();
			//addChild(indicadorX0);
			indicadorX0.visible = false;
			
			indicadorX02 = new IndicadorF2();
			//addChild(indicadorX02);
			indicadorX02.visible = false;
			
			nomeFx0 = new NomeF();
			//addChild(nomeFx0);
			nomeFx0.visible = false;
			
			nomeFlambda = new NomeF();
			addChild(nomeFlambda);
			nomeFlambda.visible = false;
			
			desenhaIndicadorXfX();
			desenhaIndicadorLambdafLambda();
			
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
			//axisX1.getProperty(Model.DELTA).addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("delta é o tamanho da vizinhança de x_0.") } );
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
			//axisX2.getProperty(Model.EPSILON).addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("epsilon é o tamanho da vizinhança de L.") } );
			axisX2.leftBracket.addEventListener(MouseEvent.MOUSE_OVER, function():void {
				if (axisX2.leftBracket.x < 0) setMessage("limite inferior de L(não visível).");
				else setMessage("limite inferior de L.");
			} );
			axisX2.rightBracket.addEventListener(MouseEvent.MOUSE_OVER, function():void {
				if (axisX2.rightBracket.x > axisX2.widthAxis) setMessage("limite superior de L(não visível).");
				else setMessage("limite superior de L.");
			} );
			
			stage.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { setMessage("") } );
			
			botoes.tutorialBtn.addEventListener(MouseEvent.MOUSE_OVER, function():void { setMessage("Reinicia o tutorial (balões).")});
			botoes.orientacoesBtn.addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("Orientações e objetivos pedagógicos.")});
			botoes.resetButton.addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("Reinicia a atividade interativa (retoma a situação inicial).")});
			botoes.creditos.addEventListener(MouseEvent.MOUSE_OVER, function():void {setMessage("Licença e créditos desta atividade interativa.")});
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
					x0Fx0.graphics.clear();
					nomeFx0.visible = false;
					indicadorX0.visible = false;
					indicadorX02.visible = false;
				}else {
					x0Fx0.graphics.clear();
					nomeFx0.visible = false;
					indicadorX0.visible = false;
					indicadorX02.x = posFx0.x;
					indicadorX02.y = posFx0.y - distToPoint;
					indicadorX02.scaleX = 1;
					indicadorX02.nome.scaleX = 1;
					indicadorX02.visible = true;
				}
			}else if (posX0.x > axisX1.x + axisX1.widthAxis) {
				if (posFx0.x < axisX1.x || posFx0.x > axisX1.x + axisX1.widthAxis) {
					x0Fx0.graphics.clear();
					nomeFx0.visible = false;
					indicadorX0.visible = false;
					indicadorX02.visible = false;
				}else {
					x0Fx0.graphics.clear();
					nomeFx0.visible = false;
					indicadorX0.visible = false;
					indicadorX02.x = posFx0.x;
					indicadorX02.y = posFx0.y - distToPoint;
					indicadorX02.scaleX = -1;
					indicadorX02.nome.scaleX = -1;
					indicadorX02.visible = true;
				}
			}else {
				if (posFx0.x < axisX1.x) {
					x0Fx0.graphics.clear();
					nomeFx0.visible = false;
					indicadorX02.visible = false;
					indicadorX0.x = posX0.x;
					indicadorX0.y = posX0.y + distToPoint;
					indicadorX0.scaleX = 1;
					indicadorX0.nome.scaleX = 1;
					indicadorX0.visible = true;
				}else if (posFx0.x > axisX1.x + axisX1.widthAxis) {
					x0Fx0.graphics.clear();
					nomeFx0.visible = false;
					indicadorX02.visible = false;
					indicadorX0.x = posX0.x;
					indicadorX0.y = posX0.y + distToPoint;
					indicadorX0.scaleX = -1;
					indicadorX0.nome.scaleX = -1;
					indicadorX0.visible = true;
				}else {
					indicadorX0.visible = false;
					indicadorX02.visible = false;
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
					nomeFx0.x = posFx0.x;
					nomeFx0.y = (posFx0.y - posX0.y) / 2 + posX0.y;
					nomeFx0.visible = true;
				}
			}
		}
		
		private function desenhaIndicadorLambdafLambda():void 
		{
			var posLambda:Point = new Point(axisX1.getPontoPosition(Model.LAMBDA) + axisX1.x, axisX1.y);
			var posFlambda:Point = new Point(axisX2.getPontoPosition(Model.FLAMBDA) + axisX2.x, axisX2.y);
			var distToPoint:Number = 20;
			
			if (posLambda.x < axisX1.x) {
				if (posFlambda.x < axisX1.x || posFlambda.x > axisX1.x + axisX1.widthAxis) {
					lambdaFlambda.graphics.clear();
					nomeFlambda.visible = false;
					indicadorLambda.visible = false;
					indicadorLambda2.visible = false;
				}else {
					lambdaFlambda.graphics.clear();
					nomeFlambda.visible = false;
					indicadorLambda.visible = false;
					indicadorLambda2.x = posFlambda.x;
					indicadorLambda2.y = posFlambda.y - distToPoint;
					indicadorLambda2.scaleX = 1;
					indicadorLambda2.nome.scaleX = 1;
					indicadorLambda2.visible = true;
				}
			}else if (posLambda.x > axisX1.x + axisX1.widthAxis) {
				if (posFlambda.x < axisX1.x || posFlambda.x > axisX1.x + axisX1.widthAxis) {
					lambdaFlambda.graphics.clear();
					nomeFlambda.visible = false;
					indicadorLambda.visible = false;
					indicadorX02.visible = false;
				}else {
					lambdaFlambda.graphics.clear();
					nomeFlambda.visible = false;
					indicadorLambda.visible = false;
					indicadorLambda2.x = posFlambda.x;
					indicadorLambda2.y = posFlambda.y - distToPoint;
					indicadorLambda2.scaleX = -1;
					indicadorLambda2.nome.scaleX = -1;
					indicadorLambda2.visible = true;
				}
			}else {
				if (posFlambda.x < axisX1.x) {
					lambdaFlambda.graphics.clear();
					nomeFlambda.visible = false;
					indicadorLambda2.visible = false;
					indicadorLambda.x = posLambda.x;
					indicadorLambda.y = posLambda.y + distToPoint;
					indicadorLambda.scaleX = 1;
					indicadorLambda.nome.scaleX = 1;
					indicadorLambda.visible = true;
				}else if (posFlambda.x > axisX1.x + axisX1.widthAxis) {
					lambdaFlambda.graphics.clear();
					nomeFlambda.visible = false;
					indicadorLambda2.visible = false;
					indicadorLambda.x = posLambda.x;
					indicadorLambda.y = posLambda.y + distToPoint;
					indicadorLambda.scaleX = -1;
					indicadorLambda.nome.scaleX = -1;
					indicadorLambda.visible = true;
				}else {
					indicadorLambda.visible = false;
					indicadorLambda2.visible = false;
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
					nomeFlambda.x = posFlambda.x;
					nomeFlambda.y = (posFlambda.y - posLambda.y) / 2 + posLambda.y;
					nomeFlambda.visible = true;
				}
			}
		}
		
		private function redesenhaIndicadores(e:ModelEvent):void 
		{
			desenhaIndicadorXfX();
			desenhaIndicadorLambdafLambda();
			axisX1.verificaPontosFora();
			axisX2.verificaPontosFora();
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
			desenhaIndicadorLambdafLambda();
			axisX2.verificaPontosFora();
		}
		
		private function updateFx0(e:ModelEvent):void 
		{
			axisX2.setPontoPosition(Model.FXO, modelo.fX0);
			desenhaIndicadorXfX();
			axisX2.verificaPontosFora();
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
			
		}
		
	}
	
}
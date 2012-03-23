package 
{
	import BaseAssets.BaseMain;
	import cepa.graph.rectangular.AxisX;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
			makeConections();
			addListerners();
		}
		
		private function initModelParams():void 
		{
			modelo.lambda = 10;
			modelo.x0 = 10;
			modelo.delta = 10;
			modelo.ptL = 10;
			modelo.epsilon = 10;
			
			axisX1 = new EixoZoom(0, 100, 500);
			axisX2 = new EixoZoom(-100, 100, 500);
			
			addChild(axisX1);
			axisX1.x = (stage.stageWidth - axisX1.width) / 2;
			axisX1.y = 100;
			addChild(axisX2);
			axisX2.x = (stage.stageWidth - axisX2.width) / 2;
			axisX2.y = 200;
			
			axisX1.createBrackets("x0", 50, 5);
			axisX2.createBrackets("fx0", 10, 5, true);
			
			axisX1.adicionaPonto("ponto1", 20);
		}
		
		private function makeConections():void 
		{
			
		}
		
		private function addListerners():void 
		{
			modelo.evtDispatcher.addEventListener(Event.CHANGE, changeView);
		}
		
		private function changeView(e:Event):void 
		{
			
		}
		
		
		
		/**
		 * Reset da atividade.
		 */
		override public function reset(e:MouseEvent = null):void
		{
			
		}
		
	}
	
}
package  
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import interfaces.IModel;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Model
	{
		public static const LAMBDA:String = "λ";//λ
		public static const XO:String = "x<sub>0</sub>";
		public static const DELTA:String = "δ";//∂ ∂ ∆ δ 
		
		public static const PT_L:String = "L";
		public static const EPSILON:String = "ε";//ε Ε
		public static const FXO:String = "ƒ(x<sub>0</sub>)"; //ƒ
		public static const FLAMBDA:String = "ƒ(λ)";
		
		private var _lambda:Number;
		private var _x0:Number;
		private var _delta:Number;
		
		private var _ptL:Number;
		private var _epsilon:Number;
		
		public var evtDispatcher:EventDispatcher = new EventDispatcher();
		//private var evtChange:Event = new Event(Event.CHANGE, true);
		
		private var currentFunction:Function;
		private var currentFunctionType:String = "";
		private var currentSortN:int;
		private var funcoesContinuas:Vector.<Function> = new Vector.<Function>;
		private var funcoesDescontinuas:Vector.<Function> = new Vector.<Function>;
		
		public function Model() 
		{
			createFunctions();
			sortCurrentFunction();
		}
		
		private function createFunctions():void 
		{
			//----------------- Funções continuas ------------------------//
			funcoesContinuas.push(function(x:Number):Number {
										return x * x;
									});
			funcoesContinuas.push(function(x:Number):Number {
										return x * 2;
									});
			funcoesContinuas.push(function(x:Number):Number {
										return x * 3;
									});
			funcoesContinuas.push(function(x:Number):Number {
										return x * 4;
									});
			funcoesContinuas.push(function(x:Number):Number {
										return x * 5;
									});
			funcoesContinuas.push(function(x:Number):Number {
										return x * 6;
									});
			
			//----------------- Funções descontinuas ----------------------
			
			funcoesDescontinuas.push(function(x:Number):Number {
										return x * x;
									});
			funcoesDescontinuas.push(function(x:Number):Number {
										return x * x;
									});
			funcoesDescontinuas.push(function(x:Number):Number {
										return x * x;
									});
			funcoesDescontinuas.push(function(x:Number):Number {
										return x * x;
									});
			funcoesDescontinuas.push(function(x:Number):Number {
										return x * x;
									});
			funcoesDescontinuas.push(function(x:Number):Number {
										return x * x;
									});
		}
		
		public function sortCurrentFunction():void 
		{
			var sortN:int;
			if (Math.random() > 0.5) {//Função contínua
				if (currentFunctionType == "continua") {
					sortN = Math.floor(Math.random() * funcoesContinuas.length);
					while (sortN == currentSortN) {
						sortN = Math.floor(Math.random() * funcoesContinuas.length);
					}
					currentSortN = sortN;
				}else {
					currentFunctionType = "continua";
					currentSortN = Math.floor(Math.random() * funcoesContinuas.length);
				}
				currentFunction = funcoesContinuas[currentSortN];
			}else {//Função descontinua
				if (currentFunctionType == "descontinua") {
					sortN = Math.floor(Math.random() * funcoesDescontinuas.length);
					while (sortN == currentSortN) {
						sortN = Math.floor(Math.random() * funcoesDescontinuas.length);
					}
					currentSortN = sortN;
				}else {
					currentFunctionType = "descontinua";
					currentSortN = Math.floor(Math.random() * funcoesDescontinuas.length);
				}
				currentFunction = funcoesDescontinuas[currentSortN];
			}
			
			var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_FUNCTION, true);
			evtDispatcher.dispatchEvent(evt);
		}
		
		public function get lambda():Number 
		{
			return _lambda;
		}
		
		public function set lambda(value:Number):void 
		{
			_lambda = value;
			
			var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_FLAMBDA, true);
			evtDispatcher.dispatchEvent(evt);
		}
		
		public function get x0():Number 
		{
			return _x0;
		}
		
		public function set x0(value:Number):void 
		{
			_x0 = value;
			
			var evt:ModelEvent = new ModelEvent(ModelEvent.CHANGE_FX0, true);
			evtDispatcher.dispatchEvent(evt);
		}
		
		public function get delta():Number 
		{
			return _delta;
		}
		
		public function set delta(value:Number):void 
		{
			_delta = value;
			//dispatchChangeEvent();
		}
		
		public function get ptL():Number 
		{
			return _ptL;
		}
		
		public function set ptL(value:Number):void 
		{
			_ptL = value;
			//dispatchChangeEvent();
		}
		
		public function get epsilon():Number 
		{
			return _epsilon;
		}
		
		public function set epsilon(value:Number):void 
		{
			_epsilon = value;
			//dispatchChangeEvent();
		}
		
		public function get fLambda():Number 
		{
			if (currentFunction != null) {
				var n:Number = currentFunction(_lambda);
				return n;
			}else {
				return NaN;
			}
		}
		
		public function get fX0():Number 
		{
			if (currentFunction != null) {
				var n:Number = currentFunction(_x0);
				return n;
			}else {
				return NaN;
			}
			
		}
		
	}

}
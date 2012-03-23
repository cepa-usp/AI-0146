package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class ModelEvent extends Event 
	{
		public static const CHANGE_FUNCTION:String = "change_func";
		public static const CHANGE_X0:String = "change_x0";
		public static const CHANGE_LAMBDA:String = "change_lambda";
		public static const CHANGE_FX0:String = "change_fx0";
		public static const CHANGE_FLAMBDA:String = "change_flambda";
		public static const CHANGE_DELTA:String = "change_delta";
		public static const CHANGE_ZOOM:String = "change_zoom";
		
		public var propName:String;
		public var propValue:Number;
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}
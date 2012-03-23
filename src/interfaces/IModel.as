package interfaces 
{
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public interface IModel 
	{
		function setValue(prop:String, value:Number):void;
		function getValue(prop:String):Number;
		function lock(prop:String):void;
	}
	
}
package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Ponto extends Sprite 
	{
		private var pt:LineL = new LineL();
		public var eixoPt:Number;
		
		public function Ponto() 
		{
			this.mouseChildren = false;
			addChild(pt);
		}
		
	}

}
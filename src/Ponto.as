package  
{
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Ponto extends Sprite 
	{
		private var pt:LineL = new LineL();
		public var eixoPt:Number;
		public var nomeBase:String;
		
		public function Ponto() 
		{
			this.pt.label.mouseEnabled = false;
			//this.pt.label.autoSize = TextFieldAutoSize.LEFT;
			//this.pt.label.multiline = false;
			this.mouseChildren = false;
			addChild(pt);
		}
		
		override public function set name(value:String):void
		{
			pt.label.width = 200;
			pt.label.text = value;
			pt.label.width = pt.label.textWidth + 5;
			super.name = value;
		}
		
		public function setLabel(value:String):void
		{
			pt.label.width = 200;
			pt.label.text = value;
			pt.label.width = pt.label.textWidth + 5;
		}
		
	}

}
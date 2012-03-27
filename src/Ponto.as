package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Ponto extends Sprite 
	{
		private var pt:LineL = new LineL();
		public var eixoPt:Number;
		public var nomeBase:String;
		private var label:TextField;
		
		public function Ponto() 
		{
			this.mouseChildren = false;
			addChild(pt);
			
			label = new TextField();
			label.defaultTextFormat = new TextFormat("Times New Roman", 15, 0x7B5A15);
			label.multiline = false;
			label.width = 5;
			label.height = 20;
			label.selectable = false;
			label.x = 7;
			label.y = -26;
			addChild(label);
		}
		
		override public function set name(value:String):void
		{
			label.width = 200;
			//label.text = value;
			label.htmlText = value;
			label.width = label.textWidth + 5;
			super.name = value;
		}
		
		public function setLabel(value:String):void
		{
			label.width = 200;
			//label.text = value;
			label.htmlText = value;
			label.width = label.textWidth + 5;
		}
		
	}

}
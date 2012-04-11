package  
{
	import fl.text.TLFTextField;
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
		//private var label:TextField;
		private var label:TLFTextField;
		private var labelSub:TLFTextField;
		
		public function Ponto() 
		{
			this.mouseChildren = false;
			addChild(pt);
			
			//label = new TextField();
			//label.defaultTextFormat = new TextFormat("Verdana", 15, 0x7B5A15);
			//label.embedFonts = true;
			//label.multiline = false;
			//label.width = 5;
			//label.height = 20;
			//label.selectable = false;
			//label.x = 7;
			//label.y = -26;
			//addChild(label);
			
			label = new TLFTextField();
			label.name = "tlfText";
			label.defaultTextFormat = new TextFormat("Verdana", 12, 0x000000);
			label.multiline = false;
			label.selectable = false;
			label.width = 5;
			label.height = 20;
			label.x = 7;
			label.y = -26;
			addChild(label);
		}
		
		override public function set name(value:String):void
		{
			if (value == Model.XO) {
				label.width = 200;
				//label.text = value;
				label.htmlText = "x";
				label.width = label.textWidth + 5;
				super.name = value;
				
				labelSub = new TLFTextField();
				labelSub.name = "tlfTextSub";
				labelSub.defaultTextFormat = new TextFormat("Verdana", 8, 0x000000);
				labelSub.multiline = false;
				labelSub.selectable = false;
				labelSub.height = 20;
				labelSub.width = 200;
				labelSub.htmlText = "0";
				labelSub.width = labelSub.textWidth + 5;
				labelSub.x = 7 + label.textWidth;
				labelSub.y = -20;
				addChild(labelSub);
				
			}else{
				label.width = 200;
				//label.text = value;
				label.htmlText = value;
				label.width = label.textWidth + 5;
				super.name = value;
			}
		}
		
		public function setLabel(value:String):void
		{
			if (super.name == Model.XO) {
				label.width = 200;
				//label.text = value;
				var arr:Array = value.split("=");
				if (arr.length > 1) label.htmlText = "x  =" + value.split("=")[1];
				else label.htmlText = "x";
				label.width = label.textWidth + 5;
			}else{
				label.width = 200;
				//label.text = value;
				label.htmlText = value;
				label.width = label.textWidth + 5;
			}
		}
		
	}

}
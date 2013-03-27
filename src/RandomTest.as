package
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.utils.Color;
	
	import utils.ResourceManager;
	
	public class RandomTest extends Sprite 
	{
		
		public function RandomTest()
		{
			
			var object:Object = new Object();
			
			object.asd = "asd";
			
			var array:Array = new Array();
			
			array.push(object);
			
			var dic:Dictionary = new Dictionary();
			dic["obj"] = object;
			
			array[0].asd = "qwe";
			
			trace(dic["obj"].asd);
			trace(array[0].asd);
			
			
		}
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
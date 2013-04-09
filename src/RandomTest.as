package
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.FragmentFilter;
	import starling.textures.RenderTexture;
	import starling.utils.Color;
	
	import utils.ResourceManager;
	
	public class RandomTest extends Sprite 
	{
		
		public function RandomTest()
		{
			var quad1:Quad = new Quad(200, 200, 0xff0000);
			
			var quad2:Quad = new Quad(200, 200, 0x00ff00);
			
			addChild(quad1);
			
			quad2.x = 100;
			quad2.y = 100;
			addChild(quad2);
			
			var quad:DisplayObject = this.getChildAt(0);
			
			
			
			
			
			
			
			
		}
			
		
		 
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
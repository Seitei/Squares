package
{
	import flash.utils.getTimer;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import utils.Polygon;
	import utils.ResourceManager;
	
	public class PerformanceTest extends Sprite
	{
		private var _texturesArray:Array = new Array();
		
		public function PerformanceTest()
		{
			
			
			var image1:Image = new Image(ResourceManager.getInstance().getTexture("balanced_square_up")); 
			var image2:Image = new Image(ResourceManager.getInstance().getTexture("balanced_square_down"));
			
			
			var rt1:RenderTexture = new RenderTexture(18, 18);
			var rt2:RenderTexture = new RenderTexture(18, 18);
			
			rt1.draw(image1);
			rt2.draw(image2);
			
			_texturesArray.push(rt1);
			_texturesArray.push(rt2);
			
			var image:Image = new Image(rt1);
			addChild(image);
			
			var a:int = getTimer();
			
			var count:int = 0;
			
			for(var i:int = 0; i < 500; i++){
				
				image.texture = _texturesArray[count]; 
				
				count ++;
				if(count == 2)
					count = 0;
				
				image.texture = _texturesArray[count];
			}
			
			trace(getTimer() - a); 
			
			
		}
	
	}
}
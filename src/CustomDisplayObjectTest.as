package
{
	import starling.display.Quad;
	import starling.display.Sprite;
	
	import utils.Polygon;

	public class CustomDisplayObjectTest extends Sprite
	{
		public function CustomDisplayObjectTest()
		{
			
			var polygon:Polygon = new Polygon(50, 6, 0xFFFFFF, 0xFF0000);
			polygon.x = 350;
			polygon.y = 350;
			addChild(polygon);
			
			
			
			/*var quad:Quad = new Quad(1, 250, 0x00FF00);
			quad.x = 350;
			quad.y = 350;
			addChild(quad);
			quad.useHandCursor = true;
			quad.rotation = Math.PI / 4;*/
			
			
			
		}
	}
}
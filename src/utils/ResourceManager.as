package utils
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class ResourceManager
	{
		private static var _instance:ResourceManager;
		
		[Embed(source = "../assets/background.png")]
		private static const Background:Class;
		
		[Embed(source = "../assets/entity_builder_background.png")]
		private static const EntityBuilderBackground:Class;
		
		//////
		
		[Embed(source = "../assets/balanced_square_up.png")]
		private static const BalancedSquareUp:Class;
		
		[Embed(source = "../assets/balanced_square_down.png")]
		private static const BalancedSquareDown:Class;
		
		[Embed(source = "../assets/balanced_square_hover.png")]
		private static const BalancedSquareHover:Class;
		
		/////
		
		[Embed(source = "../assets/lightweight_square_up.png")]
		private static const LightweightSquareUp:Class;
		
		[Embed(source = "../assets/lightweight_square_hover.png")]
		private static const LightweightSquareHover:Class;
		
		[Embed(source = "../assets/lightweight_square_down.png")]
		private static const LightweightSquareDown:Class;
		
		//////
		
		[Embed(source = "../assets/armored_square_up.png")]
		private static const ArmoredSquareUp:Class;
		
		[Embed(source = "../assets/armored_square_down.png")]
		private static const ArmoredSquareDown:Class;
		
		[Embed(source = "../assets/armored_square_hover.png")]
		private static const ArmoredSquareHover:Class;
		
		//////
		
		[Embed(source = "../assets/glasscannon_square_up.png")]
		private static const GlasscannonSquareUp:Class;
		
		[Embed(source = "../assets/glasscannon_square_down.png")]
		private static const GlasscannonSquareDown:Class;
		
		[Embed(source = "../assets/glasscannon_square_hover.png")]
		private static const GlasscannonSquareHover:Class;
		
		
		//////////////////
		
		[Embed(source = "../assets/formation_1_up.png")]
		private static const Formation1Up:Class;
		
		[Embed(source = "../assets/formation_1_hover.png")]
		private static const Formation1Hover:Class;
		
		[Embed(source = "../assets/formation_1_down.png")]
		private static const Formation1Down:Class;
		
		//////
		
		[Embed(source = "../assets/formation_2_up.png")]
		private static const Formation2Up:Class;
		
		[Embed(source = "../assets/formation_2_hover.png")]
		private static const Formation2Hover:Class;
		
		[Embed(source = "../assets/formation_2_down.png")]
		private static const Formation2Down:Class;
		
		//////
		
		[Embed(source = "../assets/formation_3_up.png")]
		private static const Formation3Up:Class;
		
		[Embed(source = "../assets/formation_3_hover.png")]
		private static const Formation3Hover:Class;
		
		[Embed(source = "../assets/formation_3_down.png")]
		private static const Formation3Down:Class;
		
		//////
		
		[Embed(source = "../assets/formation_4_up.png")]
		private static const Formation4Up:Class;
		
		[Embed(source = "../assets/formation_4_hover.png")]
		private static const Formation4Hover:Class;
		
		[Embed(source = "../assets/formation_4_down.png")]
		private static const Formation4Down:Class;
		
		//////
		
		[Embed(source = "../assets/formation_5_up.png")]
		private static const Formation5Up:Class;
		
		[Embed(source = "../assets/formation_5_hover.png")]
		private static const Formation5Hover:Class;
		
		[Embed(source = "../assets/formation_5_down.png")]
		private static const Formation5Down:Class;
		
		//////
		
		[Embed(source = "../assets/accept_entity_up.png")]
		private static const AcceptEntityUp:Class;
		
		[Embed(source = "../assets/accept_entity_hover.png")]
		private static const AcceptEntityHover:Class;
		
		[Embed(source = "../assets/accept_entity_down.png")]
		private static const AcceptEntityDown:Class;
		
		//////
		
		[Embed(source = "../assets/cancel_entity_up.png")]
		private static const CancelEntityUp:Class;
		
		[Embed(source = "../assets/cancel_entity_hover.png")]
		private static const CancelEntityHover:Class;
		
		[Embed(source = "../assets/cancel_entity_down.png")]
		private static const CancelEntityDown:Class;
		
		//////
		
		[Embed(source = "../assets/square_type_normal_up.png")]
		private static const SquareTypeNormalUp:Class;
		
		[Embed(source = "../assets/square_type_normal_hover.png")]
		private static const SquareTypeNormalHover:Class;
		
		[Embed(source = "../assets/square_type_normal_down.png")]
		private static const SquareTypeNormalDown:Class;
		
		//////
		
		[Embed(source = "../assets/square_type_tower_up.png")]
		private static const SquareTypeTowerUp:Class;
		
		[Embed(source = "../assets/square_type_tower_hover.png")]
		private static const SquareTypeTowerHover:Class;
		
		[Embed(source = "../assets/square_type_tower_down.png")]
		private static const SquareTypeTowerDown:Class;
		
		//////
		
		[Embed(source = "../assets/square_centered_up.png")]
		private static const SquareCenteredUp:Class;
		
		[Embed(source = "../assets/square_centered_hover.png")]
		private static const SquareCenteredHover:Class;
		
		[Embed(source = "../assets/square_centered_down.png")]
		private static const SquareCenteredDown:Class;
		
		//////
		
		[Embed(source = "../assets/vertex_centered_up.png")]
		private static const VertexCenteredUp:Class;
		
		[Embed(source = "../assets/vertex_centered_down.png")]
		private static const VertexCenteredDown:Class;
		
		[Embed(source = "../assets/vertex_centered_hover.png")]
		private static const VertexCenteredHover:Class;
		
		//////
		
		[Embed(source = "../assets/square_up.png")]
		private static const SquareUp:Class;
		
		[Embed(source = "../assets/square_down.png")]
		private static const SquareDown:Class;
		
		[Embed(source = "../assets/square_hover.png")]
		private static const SquareHover:Class;
		
		// XML //
		
		
		////////////////////////////////////////////////////////////////////////////////////
		
		private var TextureAssets:Dictionary = new Dictionary();
		private var XMLAssets:Dictionary = new Dictionary();
		private var _textures:Dictionary = new Dictionary();
		private var _xmls:Dictionary = new Dictionary();
		
		public function ResourceManager()
		{
			TextureAssets["background"] = Background;
			TextureAssets["entity_builder_background"] = EntityBuilderBackground;
			
			//////
			
			TextureAssets["balanced_square_up"] = BalancedSquareUp;
			TextureAssets["balanced_square_down"] = BalancedSquareDown;
			TextureAssets["balanced_square_hover"] = BalancedSquareHover;
			
			TextureAssets["lightweight_square_up"] = LightweightSquareUp;
			TextureAssets["lightweight_square_down"] = LightweightSquareDown;
			TextureAssets["lightweight_square_hover"] = LightweightSquareHover;
			
			TextureAssets["armored_square_up"] = ArmoredSquareUp;
			TextureAssets["armored_square_down"] = ArmoredSquareDown;
			TextureAssets["armored_square_hover"] = ArmoredSquareHover;
			
			TextureAssets["glasscannon_square_up"] = GlasscannonSquareUp;
			TextureAssets["glasscannon_square_down"] = GlasscannonSquareDown;
			TextureAssets["glasscannon_square_hover"] = GlasscannonSquareHover;
			
			//////
			
			TextureAssets["formation_1_up"] = Formation1Up;
			TextureAssets["formation_1_hover"] = Formation1Hover;
			TextureAssets["formation_1_down"] = Formation1Down;
			
			TextureAssets["formation_2_up"] = Formation2Up;
			TextureAssets["formation_2_hover"] = Formation2Hover;
			TextureAssets["formation_2_down"] = Formation2Down;
			
			TextureAssets["formation_3_up"] = Formation3Up;
			TextureAssets["formation_3_hover"] = Formation3Hover;
			TextureAssets["formation_3_down"] = Formation3Down;
			
			TextureAssets["formation_4_up"] = Formation4Up;
			TextureAssets["formation_4_hover"] = Formation4Hover;
			TextureAssets["formation_4_down"] = Formation4Down;
			
			TextureAssets["formation_5_up"] = Formation5Up;
			TextureAssets["formation_5_hover"] = Formation5Hover;
			TextureAssets["formation_5_down"] = Formation5Down;
			
			///////
			
			TextureAssets["accept_entity_up"] = AcceptEntityUp;
			TextureAssets["accept_entity_hover"] = AcceptEntityHover;
			TextureAssets["accept_entity_down"] = AcceptEntityDown;
			
			TextureAssets["cancel_entity_up"] = CancelEntityUp;
			TextureAssets["cancel_entity_hover"] = CancelEntityHover;
			TextureAssets["cancel_entity_down"] = CancelEntityDown;
			
			//////
			
			TextureAssets["square_type_normal_up"] = SquareTypeNormalUp;
			TextureAssets["square_type_normal_hover"] = SquareTypeNormalHover;
			TextureAssets["square_type_normal_down"] = SquareTypeNormalDown;
			
			TextureAssets["square_type_tower_up"] = SquareTypeTowerUp;
			TextureAssets["square_type_tower_hover"] = SquareTypeTowerHover;
			TextureAssets["square_type_tower_down"] = SquareTypeTowerDown;
			
			//////
			
			TextureAssets["vertex_centered_up"] = VertexCenteredUp;
			TextureAssets["vertex_centered_down"] = VertexCenteredDown;
			TextureAssets["vertex_centered_hover"] = VertexCenteredHover;
			
			TextureAssets["square_centered_up"] = SquareCenteredUp;
			TextureAssets["square_centered_down"] = SquareCenteredDown;
			TextureAssets["square_centered_hover"] = SquareCenteredHover;
			
			//////
			
			TextureAssets["square_up"] = SquareUp;
			TextureAssets["square_down"] = SquareDown;
			TextureAssets["square_hover"] = SquareHover;
			
			
			// XMLS
			
			
		}
		
		public function getTextures(name:String, prefix:String = "", animate:Boolean = true):Vector.<Texture> {
			
			if (TextureAssets[name] != undefined)
			{
				if (_textures[name + "." + prefix] == undefined)
				{
					var bitmap:Bitmap = new TextureAssets[name];
					var texture:Texture = _textures[name] = Texture.fromBitmap(bitmap);
					var frames:Vector.<Texture> = new Vector.<Texture>();
					
					var xml:XML = XML(new XMLAssets[name]);
					var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
					frames = textureAtlas.getTextures(prefix);
					_textures[name + "." + prefix] = frames;
					
				}
			}
			else
				throw new Error("Resource not defined!");
			
			return _textures[name + "." + prefix];
		}
		
		public function getTexture(name:String, prefix:String = ""):Texture
		{
			if (TextureAssets[name] != undefined)
			{
				if(prefix == ""){
					if (_textures[name] == undefined)
					{
						var bitmap:Bitmap = new TextureAssets[name]();
						_textures[name] = Texture.fromBitmap(bitmap);
					}
					return _textures[name];
				} 
				else {
					if (_textures[name + "." + prefix] == undefined)
					{
						var bitmap2:Bitmap = new TextureAssets[name];
						var texture:Texture = _textures[name] = Texture.fromBitmap(bitmap2);
						var frames:Vector.<Texture> = new Vector.<Texture>();
						
						var xml:XML = XML(new XMLAssets[name]);
						var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
						frames = textureAtlas.getTextures(prefix);
						_textures[name + "." + prefix] = frames[0];
					}
					return _textures[name + "." + prefix];
				}
				
				return _textures[name];
			} 
			else throw new Error("Resource not defined.");
		}
		
		public static function getInstance():ResourceManager {
			if (!_instance)
				_instance = new ResourceManager();
			return _instance
		}
	}
	
	
	
	
	
	
	
	
	
	
}
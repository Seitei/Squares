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
		
		[Embed(source = "../assets/action_bar_bg.png")]
		private static const ActionBarBg:Class;
		
		[Embed(source = "../assets/entity_builder_background.png")]
		private static const EntityBuilderBackground:Class;
		
		//////
		
		[Embed(source = "../assets/balanced_square_btn.png")]
		private static const BalancedSquareBtn:Class;
		
		[Embed(source = "../assets/lightweight_square_btn.png")]
		private static const LightweightSquareBtn:Class;
		
		[Embed(source = "../assets/armored_square_btn.png")]
		private static const ArmoredSquareBtn:Class;
		
		[Embed(source = "../assets/glasscannon_square_btn.png")]
		private static const GlasscannonSquareBtn:Class;
		
		//////
		
		[Embed(source = "../assets/formation_1_btn.png")]
		private static const Formation1Btn:Class;
		
		[Embed(source = "../assets/formation_2_btn.png")]
		private static const Formation2Btn:Class;
		
		[Embed(source = "../assets/formation_3_btn.png")]
		private static const Formation3Btn:Class;
		
		[Embed(source = "../assets/formation_4_btn.png")]
		private static const Formation4Btn:Class;
		
		[Embed(source = "../assets/formation_5_btn.png")]
		private static const Formation5Btn:Class;
		
		//////
		
		[Embed(source = "../assets/accept_entity_btn.png")]
		private static const AcceptEntityBtn:Class;
		
		[Embed(source = "../assets/cancel_entity_btn.png")]
		private static const CancelEntityBtn:Class;
		
		//////
		
		[Embed(source = "../assets/square_type_normal_btn.png")]
		private static const SquareTypeNormalBtn:Class;
		
		[Embed(source = "../assets/square_type_tower_btn.png")]
		private static const SquareTypeTowerBtn:Class;
		
		[Embed(source = "../assets/square_centered_btn.png")]
		private static const SquareCenteredBtn:Class;
		
		[Embed(source = "../assets/vertex_centered_btn.png")]
		private static const VertexCenteredBtn:Class;
		
		[Embed(source = "../assets/square_btn.png")]
		private static const SquareBtn:Class;
		
		//////
	
		[Embed(source = "../assets/ready_btn.png")]
		private static const ReadyBtn:Class;
		
		// XML //
		
		private var TextureAssets:Dictionary = new Dictionary();
		private var XMLAssets:Dictionary = new Dictionary();
		private var _textures:Dictionary = new Dictionary();
		private var _xmls:Dictionary = new Dictionary();
		
		public function ResourceManager()
		{
			TextureAssets["background"] = Background;
			TextureAssets["entity_builder_background"] = EntityBuilderBackground;
			
			
			//////
			
			TextureAssets["ready_btn"] = ReadyBtn;
			
			
			//////
			
			TextureAssets["balanced_square_btn"] = BalancedSquareBtn;
			TextureAssets["lightweight_square_btn"] = LightweightSquareBtn;
			TextureAssets["armored_square_btn"] = ArmoredSquareBtn;
			TextureAssets["glasscannon_square_btn"] = GlasscannonSquareBtn;
			
			//////
			
			TextureAssets["formation_1_btn"] = Formation1Btn;
			TextureAssets["formation_2_btn"] = Formation2Btn;
			TextureAssets["formation_3_btn"] = Formation3Btn;
			TextureAssets["formation_4_btn"] = Formation4Btn;
			TextureAssets["formation_5_btn"] = Formation5Btn;
			
			///////
			
			TextureAssets["accept_entity_btn"] = AcceptEntityBtn;
			TextureAssets["cancel_entity_btn"] = CancelEntityBtn;
			
			//////
			
			TextureAssets["square_type_normal_btn"] = SquareTypeNormalBtn;
			TextureAssets["square_type_tower_btn"] = SquareTypeTowerBtn;
			
			//////
			
			TextureAssets["vertex_centered_btn"] = VertexCenteredBtn;
			TextureAssets["square_centered_btn"] = SquareCenteredBtn;
			
			//////
			
			TextureAssets["square_btn"] = SquareBtn;
			TextureAssets["action_bar_bg"] = ActionBarBg;
			
			
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
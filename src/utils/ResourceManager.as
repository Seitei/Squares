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
		[Embed(source="../assets/balanced_square_btn.xml", mimeType="application/octet-stream")]
		public static const BalancedSquareBtnXML:Class;
		
		[Embed(source = "../assets/lightweight_square_btn.png")]
		private static const LightweightSquareBtn:Class;
		[Embed(source="../assets/lightweight_square_btn.xml", mimeType="application/octet-stream")]
		public static const LightweightSquareBtnXML:Class;
		
		[Embed(source = "../assets/armored_square_btn.png")]
		private static const ArmoredSquareBtn:Class;
		[Embed(source="../assets/armored_square_btn.xml", mimeType="application/octet-stream")]
		public static const ArmoredSquareBtnXML:Class;
		
		[Embed(source = "../assets/glasscannon_square_btn.png")]
		private static const GlasscannonSquareBtn:Class;
		[Embed(source="../assets/glasscannon_square_btn.xml", mimeType="application/octet-stream")]
		public static const GlasscannonSquareBtnXML:Class;
		
		//////
		
		[Embed(source = "../assets/formation_1_btn.png")]
		private static const Formation1Btn:Class;
		[Embed(source="../assets/formation_1_btn.xml", mimeType="application/octet-stream")]
		public static const Formation1BtnXML:Class;
		
		[Embed(source = "../assets/formation_2_btn.png")]
		private static const Formation2Btn:Class;
		[Embed(source="../assets/formation_2_btn.xml", mimeType="application/octet-stream")]
		public static const Formation2BtnXML:Class;
		
		[Embed(source = "../assets/formation_3_btn.png")]
		private static const Formation3Btn:Class;
		[Embed(source="../assets/formation_3_btn.xml", mimeType="application/octet-stream")]
		public static const Formation3BtnXML:Class;
		
		[Embed(source = "../assets/formation_4_btn.png")]
		private static const Formation4Btn:Class;
		[Embed(source="../assets/formation_4_btn.xml", mimeType="application/octet-stream")]
		public static const Formation4BtnXML:Class;
		
		[Embed(source = "../assets/formation_5_btn.png")]
		private static const Formation5Btn:Class;
		[Embed(source="../assets/formation_5_btn.xml", mimeType="application/octet-stream")]
		public static const Formation5BtnXML:Class;
		
		//////
		
		[Embed(source = "../assets/accept_entity_btn.png")]
		private static const AcceptEntityBtn:Class;
		[Embed(source="../assets/accept_entity_btn.xml", mimeType="application/octet-stream")]
		public static const AcceptEntityBtnXML:Class;
		
		[Embed(source = "../assets/cancel_entity_btn.png")]
		private static const CancelEntityBtn:Class;
		[Embed(source="../assets/cancel_entity_btn.xml", mimeType="application/octet-stream")]
		public static const CancelEntityBtnXML:Class;
		
		//////
		
		[Embed(source = "../assets/square_type_normal_btn.png")]
		private static const SquareTypeNormalBtn:Class;
		[Embed(source="../assets/square_type_normal_btn.xml", mimeType="application/octet-stream")]
		public static const SquareTypeNormalBtnXML:Class;
		
		[Embed(source = "../assets/square_type_tower_btn.png")]
		private static const SquareTypeTowerBtn:Class;
		[Embed(source="../assets/square_type_tower_btn.xml", mimeType="application/octet-stream")]
		public static const SquareTypeTowerBtnXML:Class;
		
		[Embed(source = "../assets/square_centered_btn.png")]
		private static const SquareCenteredBtn:Class;
		[Embed(source="../assets/square_centered_btn.xml", mimeType="application/octet-stream")]
		public static const SquareCenteredBtnXML:Class;
		
		[Embed(source = "../assets/vertex_centered_btn.png")]
		private static const VertexCenteredBtn:Class;
		[Embed(source="../assets/vertex_centered_btn.xml", mimeType="application/octet-stream")]
		public static const VertexCenteredBtnXML:Class;
		
		[Embed(source = "../assets/square_btn.png")]
		private static const SquareBtn:Class;
		[Embed(source="../assets/square_btn.xml", mimeType="application/octet-stream")]
		public static const SquareBtnXML:Class;
		
		//////
	
		[Embed(source = "../assets/ready_btn.png")]
		private static const ReadyBtn:Class;
		[Embed(source="../assets/ready_btn.xml", mimeType="application/octet-stream")]
		public static const ReadyBtnXML:Class;
		
		////////////
		
		private var TextureAssets:Dictionary = new Dictionary();
		private var XMLAssets:Dictionary = new Dictionary();
		private var _textures:Dictionary = new Dictionary();
		private var _xmls:Dictionary = new Dictionary();
		
		public function ResourceManager()
		{
			TextureAssets["background"] = Background;
			TextureAssets["entity_builder_background"] = EntityBuilderBackground;
			TextureAssets["action_bar_bg"] = ActionBarBg;
			
			//////
			
			TextureAssets["ready_btn"] = ReadyBtn;
			XMLAssets["ready_btn"] = ReadyBtnXML;
			
			//////
			
			TextureAssets["balanced_square_btn"] = BalancedSquareBtn;
			XMLAssets["balanced_square_btn"] = BalancedSquareBtnXML;
			
			TextureAssets["lightweight_square_btn"] = LightweightSquareBtn;
			XMLAssets["lightweight_square_btn"] = LightweightSquareBtnXML;
			
			TextureAssets["armored_square_btn"] = ArmoredSquareBtn;
			XMLAssets["armored_square_btn"] = ArmoredSquareBtnXML;
			
			TextureAssets["glasscannon_square_btn"] = GlasscannonSquareBtn;
			XMLAssets["glasscannon_square_btn"] = GlasscannonSquareBtnXML;
			
			//////
			
			TextureAssets["formation_1_btn"] = Formation1Btn;
			XMLAssets["formation_1_btn"] = Formation1BtnXML;
			
			TextureAssets["formation_2_btn"] = Formation2Btn;
			XMLAssets["formation_2_btn"] = Formation2BtnXML;
			
			TextureAssets["formation_3_btn"] = Formation3Btn;
			XMLAssets["formation_3_btn"] = Formation3BtnXML;
			
			TextureAssets["formation_4_btn"] = Formation4Btn;
			XMLAssets["formation_4_btn"] = Formation4BtnXML;
			
			TextureAssets["formation_5_btn"] = Formation5Btn;
			XMLAssets["formation_5_btn"] = Formation5BtnXML;
			
			///////
			
			TextureAssets["accept_entity_btn"] = AcceptEntityBtn;
			XMLAssets["accept_entity_btn"] = AcceptEntityBtnXML;
			
			TextureAssets["cancel_entity_btn"] = CancelEntityBtn;
			XMLAssets["cancel_entity_btn"] = CancelEntityBtnXML;
			
			//////
			
			TextureAssets["square_type_normal_btn"] = SquareTypeNormalBtn;
			XMLAssets["square_type_normal_btn"] = SquareTypeNormalBtnXML;
			
			TextureAssets["square_type_tower_btn"] = SquareTypeTowerBtn;
			XMLAssets["square_type_tower_btn"] = SquareTypeTowerBtnXML;
			
			//////
			
			TextureAssets["vertex_centered_btn"] = VertexCenteredBtn;
			XMLAssets["vertex_centered_btn"] = VertexCenteredBtnXML;
			
			TextureAssets["square_centered_btn"] = SquareCenteredBtn;
			XMLAssets["square_centered_btn"] = SquareCenteredBtnXML;
			
			//////
			
			TextureAssets["square_btn"] = SquareBtn;
			XMLAssets["square_btn"] = SquareBtnXML;
		
			
			
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
package {
	import com.adobe.utils.AGALMiniAssembler;
	import PerspectiveMatrix3D;
	
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/**
	 * In this practice we simply draw a simple triangle using only
	 * Stage3D API and nothing more.
	 * You should be able to write this class on your own before
	 * going any further.
	 * 
	 * Find the associate tutorial at my blog on http://blog.norbz.net/
	 * @see http://blog.norbz.net/2012/01/stage3d-agal-from-scratch-part-iii-hello-triangle
	 * 
	 * 
	 * @author Nicolas CHESNE
	 * 			http://blog.norbz.net
	 * 			http://www.norbz.fr
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="640", height="480")]
	public class HelloTriangle extends Sprite {
		
		// simple width and height quick accessors
		private var W:int;
		private var H:int;
		
		// Stage3D related members
		private var _context:Context3D;
		private var _program:Program3D;
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _matrix:Matrix3D;
		private var _vertexShader:ByteArray;
		private var _fragmentShader:ByteArray;
		
		/**
		 * CLASS CONSTRUCTOR
		 */
		public function HelloTriangle() {
			// Init the practive when the stage is available
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Initialise the practice by requesting a Context3D to the first Stage3D
		 * Remember than when working with Stage3D you are actually working with Context3D
		 */
		private function init(event:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			W = stage.stageWidth;
			H = stage.stageHeight;
			
			// wait for Stage3D to provide us a Context3D
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onCreate);
			stage.stage3Ds[0].requestContext3D();
		}
		
		/**
		 * Called when the context3D has been created
		 * 
		 * Put the whole scene in place for the GPU.
		 * As you can see, I chose to first deal with the whole Allocation thing
		 * before dealin with the upload things, but I could have first create buffers and upload them
		 * before doing the same for the program.
		 */
		private function onCreate(event:Event):void {
			// // // CREATE CONTEXT // //
			_context = stage.stage3Ds[0].context3D;
			
			// By enabling the Error reporting, you can get some valuable information about errors in your shaders
			// But it also dramatically slows down your program.
			// context.enableErrorChecking=true;
			
			// Configure the back buffer, in width and height. You can also specify the antialiasing
			// The backbuffer is the memory space where your final image is rendered.
			_context.configureBackBuffer(W, H, 4, true);
			
			
			// Allocation - program compilation
			createBuffers();
			createAndCompileProgram();
			// Upload program and buffers data
			uploadProgram();
			uploadBuffers();
			
			// Split chunk of data and set active program
			splitAndMakeChunkOfDataAvailableToProgram();
			setActiveProgram();
			
			// start the rendering loop
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		/**
		 * Create the vertex and index buffers
		 */
		private function createBuffers():void {
			// // // CREATE BUFFERS // //
			_vertexBuffer = _context.createVertexBuffer(3, 6);
			_indexBuffer = _context.createIndexBuffer(3);
		}
		
		/**
		 * Upload some data to the vertex and index buffers
		 */
		private function uploadBuffers():void {
			var vertexData:Vector.<Number> = Vector.<Number>([
				-0.3, -0.3, 0, 255, 0, 0, 	// - 1st vertex x,y,z,r,g,b      RED
				   0,  0.3, 0, 0, 255, 0, 		// - 2nd vertex x,y,z,r,g,b  GREEN
				 0.3, -0.3, 0, 0, 0, 255		// - 3rd vertex x,y,z,r,g,b      BLUE
			]);
			
			_vertexBuffer.uploadFromVector(vertexData, 0, 3);
			_indexBuffer.uploadFromVector(Vector.<uint>([0, 1, 2]), 0, 3);
		}
		
		/**
		 * Define how each Chunck of Data should be split and upload to fast access register for our AGAL program
		 * 
		 * @see __createAndCompileProgram
		 */
		private function splitAndMakeChunkOfDataAvailableToProgram():void {
			// So here, basically, you're telling your GPU that for each Vertex with a vertex being x,y,y,r,g,b
			// you will copy in register "0", from the buffer "vertexBuffer, starting from the postion "0" the FLOAT_3 next number
			_context.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // register "0" now contains x,y,z
			
			// Here, you will copy in register "1" from "vertexBuffer", starting from index "3", the next FLOAT_3 numbers
			_context.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3); // register 1 now contains r,g,b
		}
		
		/**
		 * Create the program that will run in your GPU.
		 */
		private function createAndCompileProgram() : void {
			// // // CREATE SHADER PROGRAM // //
			// When you call the createProgram method you are actually allocating some V-Ram space
			// for your shader program.
			_program = _context.createProgram();
			
			// Create an AGALMiniAssembler.
			// The MiniAssembler is an Adobe tool that uses a simple
			// Assembly-like language to write and compile your shader into bytecode
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			
			// VERTEX SHADER
			var code:String = "";
			code += "m44 op, va0, vc0 \n"; // Perform a 4x4 matrix operation on each vertices
			code += "div v0, va1 1 \n";
			code += "mov v0, va1 \n"; // Move the Vertex Attribute 1 (va1), which is our Vertex Color, to the variable register v0
			// Variable register are memory space shared between your Vertex Shader and your Fragment Shader
			
			// Compile our AGAL Code into ByteCode using the MiniAssembler 
			_vertexShader = assembler.assemble(Context3DProgramType.VERTEX, code);
			
			code = "mov oc, v0 \n"; // Move the Variable register 0 (v0) where we copied our Vertex Color, to the output color
			
			// Compile our AGAL Code into Bytecode using the MiniAssembler
			_fragmentShader = assembler.assemble(Context3DProgramType.FRAGMENT, code);
		}
		
		/**
		 * Upload our two compiled shaders into the graphic card.
		 */
		private function uploadProgram():void {
			// UPLOAD TO GPU PROGRAM
			_program.upload(_vertexShader, _fragmentShader); // Upload the combined program to the video Ram
		}
		
		/**
		 * Define the active program to run on our GPU
		 */
		private function setActiveProgram():void {
			// Set our program as the current active one
			_context.setProgram(_program);
		}
		
		/**
		 * Called each frame
		 * Render the scene
		 */
		private function render(event:Event):void {
			_context.clear(1, 1, 1, 1); // Clear the backbuffer by filling it with the given color
			
			var projection:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			projection.perspectiveFieldOfViewLH(45*Math.PI/180, 4/3, 0.1, 1000);
			
			_matrix = new Matrix3D();
			_matrix.appendRotation(getTimer()/30, Vector3D.Y_AXIS);
			_matrix.appendRotation(getTimer()/10, Vector3D.X_AXIS);
			_matrix.appendTranslation(0, 0, 2);
			_matrix.append(projection);
			
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _matrix, true); // 0 means that we will retrieve the matrix under vc0
			
			_context.drawTriangles(_indexBuffer); // Draw the triangle according to the indexBuffer instructions into the backbuffer
			_context.present(); // render the backbuffer on screen.
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

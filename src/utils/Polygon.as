package utils
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.*;
	import flash.geom.*;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.errors.MissingContextError;
	import starling.events.Event;
	import starling.utils.VertexData;
	
	/** This custom display objects renders a regular, n-sided polygon. */
	public class Polygon extends DisplayObject
	{
		private static var PROGRAM_NAME:String = "polygon";
		
		// custom members
		private var _radius:Number;
		private var _numEdges:int;
		private var _color1:uint;
		private var _color2:uint;
		
		// vertex data 
		private var _vertexData:VertexData;
		private var _vertexBuffer:VertexBuffer3D;
		
		// index data
		private var _indexData:Vector.<uint>;
		private var _indexBuffer:IndexBuffer3D;
		
		// helper objects (to avoid temporary objects)
		private static var _helperMatrix:Matrix = new Matrix();
		private static var _renderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
		
		/** Creates a regular polygon with the specified redius, number of edges, and color. */
		public function Polygon(radius:Number, numEdges:int=6, color1:uint=0xffffff, color2:uint=0xffffff)
		{
			if (numEdges < 3) throw new ArgumentError("Invalid number of edges");
			
			_radius = radius;
			_numEdges = numEdges;
			_color1 = color1;
			_color2 = color2;
			
			// setup vertex data and prepare shaders
			setupVertices();
			createBuffers();
			registerPrograms();
			
			// handle lost context
			Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		/** Disposes all resources of the display object. */
		public override function dispose():void
		{
			Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			if (_vertexBuffer) _vertexBuffer.dispose();
			if (_indexBuffer)  _indexBuffer.dispose();
			
			super.dispose();
		}
		
		private function onContextCreated(event:Event):void
		{
			// the old context was lost, so we create new buffers and shaders.
			createBuffers();
			registerPrograms();
		}
		
		/** Returns a rectangle that completely encloses the object as it appears in another 
		 * coordinate system. */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if (resultRect == null) resultRect = new Rectangle();
			
			var transformationMatrix:Matrix = targetSpace == this ? 
				null : getTransformationMatrix(targetSpace, _helperMatrix);
			
			return _vertexData.getBounds(transformationMatrix, 0, -1, resultRect);
		}
		
		/** Creates the required vertex- and index data and uploads it to the GPU. */ 
		private function setupVertices():void
		{
			var i:int;
			
			// create vertices
			
			_vertexData = new VertexData(_numEdges+1);
			//_vertexData.setUniformColor(_color);
			
			for (i=0; i<_numEdges; ++i)
			{
				var edge:Point = Point.polar(_radius, i*2*Math.PI / _numEdges);
				_vertexData.setPosition(i, edge.x, edge.y);
				if(i%2)
					_vertexData.setColor(i, _color1);
				else
					_vertexData.setColor(i, _color2);
			}
			
			_vertexData.setPosition(_numEdges, 0.0, 0.0); // center vertex
			_vertexData.setColor(_numEdges, _color1);
			
			// create indices that span up the triangles
			
			_indexData = new <uint>[];
			
			for (i=0; i<_numEdges; ++i){
				_indexData.push(_numEdges, i, (i+1)%_numEdges);
			}
			
		}
		
		/** Creates new vertex- and index-buffers and uploads our vertex- and index-data to those
		 *  buffers. */ 
		private function createBuffers():void
		{
			var context:Context3D = Starling.context;
			if (context == null) throw new MissingContextError();
			
			if (_vertexBuffer) _vertexBuffer.dispose();
			if (_indexBuffer)  _indexBuffer.dispose();
			
			_vertexBuffer = context.createVertexBuffer(_vertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);
			_vertexBuffer.uploadFromVector(_vertexData.rawData, 0, _vertexData.numVertices);
			
			_indexBuffer = context.createIndexBuffer(_indexData.length);
			_indexBuffer.uploadFromVector(_indexData, 0, _indexData.length);
		}
		
		/** Renders the object with the help of a 'support' object and with the accumulated alpha
		 * of its parent object. */
		public override function render(support:RenderSupport, alpha:Number):void
		{
			// always call this method when you write custom rendering code!
			// it causes all previously batched quads/images to render.
			support.finishQuadBatch();
			
			// make this call to keep the statistics display in sync.
			support.raiseDrawCount();
			
			_renderAlpha[0] = _renderAlpha[1] = _renderAlpha[2] = 1.0;
			_renderAlpha[3] = alpha * this.alpha;
			
			var context:Context3D = Starling.context;
			if (context == null) throw new MissingContextError();
			
			// apply the current blendmode
			support.applyBlendMode(false);
			
			// activate program (shader) and set the required buffers / constants 
			context.setProgram(Starling.current.getProgram(PROGRAM_NAME));
			context.setVertexBufferAt(0, _vertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); 
			context.setVertexBufferAt(1, _vertexBuffer, VertexData.COLOR_OFFSET,    Context3DVertexBufferFormat.FLOAT_4);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);            
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, _renderAlpha, 1);
			
			// finally: draw the object!
			context.drawTriangles(_indexBuffer, 0, _numEdges);
			
			// reset buffers
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
		}
		
		/** Creates vertex and fragment programs from assembly. */
		private static function registerPrograms():void
		{
			var target:Starling = Starling.current;
			if (target.hasProgram(PROGRAM_NAME)) return; // already registered
			
			// va0 -> position
			// va1 -> color
			// vc0 -> mvpMatrix (4 vectors, vc0 - vc3)
			// vc4 -> alpha
			
			var vertexProgramCode:String =
				"m44 op, va0, vc0 \n" + // 4x4 matrix transform to output space
				"mul v0, va1, vc4 \n";  // multiply color with alpha and pass it to fragment shader
			
			var fragmentProgramCode:String =
				"mov oc, v0";           // just forward incoming color
			
			var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
			
			var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode);
			
			target.registerProgram(PROGRAM_NAME, vertexProgramAssembler.agalcode,
				fragmentProgramAssembler.agalcode);
		}
		
		/** The radius of the polygon in points. */
		public function get radius():Number { return _radius; }
		public function set radius(value:Number):void { _radius = value; setupVertices(); }
		
		/** The number of edges of the regular polygon. */
		public function get numEdges():int { return _numEdges; }
		public function set numEdges(value:int):void { _numEdges = value; setupVertices(); }
		
	}
	
	
	
	
	
	
	
	
}
package webgl.textures;

import Html5Dom;
import js.Dom;
import js.Lib;


/**
 * ...
 * @author MikeCann
 */
class Texture2D 
{

	// Publics
	public var onCompleteCallback(default, default) : Texture2D -> Void;
	public var image(default, null) : Image;
	public var texture(default, null) : WebGLTexture;
	public var isLoaded(default, null) : Bool;
	public var url(null, null) : String;	
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var format(default, null) : GLenum;
	public var type(default, null) : GLenum;
	public var yFlip : Bool;
	
	// Privates
	inline private var gl(default, null) : WebGLRenderingContext;
	
	public function new(gl:WebGLRenderingContext) 
	{
		this.gl = gl;
		this.isLoaded = false;	
		texture = gl.createTexture();
	}
	
	public function use(textureSlot:Int) : Void
	{
		gl.activeTexture(gl.TEXTURE0 + textureSlot);
        gl.bindTexture(gl.TEXTURE_2D, texture);
	}
	
	public function unuse(textureSlot:Int) : Void
	{
		gl.activeTexture(gl.TEXTURE0 + textureSlot);
        gl.bindTexture(gl.TEXTURE_2D, texture);
	}
	
	public function load(url:String, ?onComplete : Texture2D -> Void) : Texture2D
	{
		this.onCompleteCallback = onComplete;
		this.url = url;				
		
		image = cast js.Lib.document.createElement("img");	
		image.onload = onTextureImageLoaded;
		image.src = url;
		
		return this;
	}
	
	private function onTextureImageLoaded(e) :  Void
	{
		trace("Texture Loaded -> "+this.url);
		isLoaded = true;
		width = image.width;
		height = image.height;
		gl.bindTexture(gl.TEXTURE_2D, texture);
		gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, yFlip?1:0);
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);
        
		//gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        //gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);			
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);    
		
		gl.bindTexture(gl.TEXTURE_2D, null);
		if (onCompleteCallback != null) { onCompleteCallback(this); } 
	}
	
	public function initFromBytes(width:Int, height:Int, data:Array<Int>)  : Void
	{
		this.width = width;
		this.height = height;
		this.format = gl.RGBA;
		isLoaded = true;
		type = gl.UNSIGNED_BYTE;
		gl.bindTexture(gl.TEXTURE_2D, texture);
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, type, new Uint8Array(data));
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		gl.bindTexture(gl.TEXTURE_2D, null);
	}
	
	public function initFromFloats(width:Int, height:Int, data:Array<Float>)  : Void
	{
		this.width = width;
		this.height = height;
		this.format = gl.RGBA;
		isLoaded = true;
		type = gl.FLOAT;
		gl.bindTexture(gl.TEXTURE_2D, texture);
		gl.pixelStorei(gl.UNPACK_ALIGNMENT, 1);
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGB, width, height, 0, gl.RGB, gl.FLOAT, new Float32Array(data));
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
		gl.bindTexture(gl.TEXTURE_2D, null);
	}
	
	
}
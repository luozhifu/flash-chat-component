package com.gaara.chat 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;
	
	import mx.utils.StringUtil;
	
	/**
	 *  @author:Gaara
	 *  2012-7-11
	 *
	 **/
	public class ChatTextAreaUtil
	{
		/** 表情的过滤模式 */
		private static var iconReg:RegExp = /\[f\d{1,2}\]/;
		
		/** 表情数量 */
		private static const FACE_NUM:int = 2;
		
		private static var fontDescription:FontDescription = new FontDescription("宋体");
		
		/** 表情数组 **/
		public static var faceVec:Vector.<Loader> = new Vector.<Loader>;
		
		/**
		 *  功能:创建一个样式对象
		 *  参数:
		 **/
		public static function createFormat(color:int=0xd8e5c6):ElementFormat
		{
			var format:ElementFormat = new ElementFormat();
			format.fontSize = 12;
			format.color = color;
			format.fontDescription = fontDescription;
			return format;
		}
		
		
		/**
		 *  功能:返回内容
		 *  参数:
		 **/
		public static function getContentArr(content:String,groupVector:Vector.<ContentElement>):void
		{
			var splitArr:Array = content.split(/(\[[f,i,vip][^\[]+?\])/);
			
			for(var i:int=0; i < splitArr.length; i++){
				var item:String = splitArr[i];
				if (iconReg.test(item)){
					var iconId:int = int(item.slice(2, item.length - 1));
					if( iconId > FACE_NUM){
						continue;
					}
					
					var url:String = StringUtil.substitute("com/gaara/faces/f{0}.swf",iconId);
					var iconSprite:Loader = new Loader;
					iconSprite.y = 6;
					iconSprite.load(new URLRequest(url));
					faceVec.push(iconSprite);
					
					var format:ElementFormat = new ElementFormat();
					format.fontSize = 12;
					
					var face:GraphicElement = new GraphicElement(iconSprite,25,25,format);
					groupVector.push(face);
					
				}else{
					if(item == ""){
						continue;
					}
					
					var contentTE:TextElement = new TextElement(item,ChatTextAreaUtil.createFormat());
					groupVector.push(contentTE);
				}
			}
		}
		
		
		/**
		 *  功能:分割字符串
		 *  参数:
		 **/
		private  static function splitString(str:String,len:int):Array
		{
			var arr:Array = new Array;
			var index:int;
			var temp:String;
			while(index < str.length){
				if((index + len) >= str.length){
					len = str.length - index;
				}
				temp = str.substr(index,len)
				arr.push(temp);
				index += 2;
			}
			return arr;
		}
		
		/**
		 *  功能:清理表情
		 *  参数:
		 **/
		public static function stopAndClearFaces():void
		{
			var iconSprite:Loader;
			while(faceVec.length >0){
				iconSprite = faceVec.pop();
				stopMC(iconSprite.content as MovieClip);
			}
		}
		
		/**
		 *完全停止一个MC,不管它里边有多少子MC全部停止 
		 * @param mc
		 * 
		 */		
		public static function stopMC(mc:DisplayObjectContainer):void{
			if(!mc)
				return;
			if(mc is MovieClip)
				MovieClip(mc).stop();
			for(var i:int=0;i<mc.numChildren;i++){
				var disp:DisplayObject = mc.getChildAt(i);
				if(disp is DisplayObjectContainer){
					stopMC(disp as DisplayObjectContainer);
				}
			}
		}
	}
}
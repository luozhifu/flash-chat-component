package com.gaara.chat
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	/**
	 *  @author:Gaara
	 *  2012-10-30
	 *  表情加载器
	 **/
	public class FaceLoader extends Sprite
	{
		public function FaceLoader(width:int,height:int)
		{
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
		
		/**
		 *  功能:加载
		 *  参数:
		 **/
		public function load(url:String):void
		{
			var iconSprite:Loader = new Loader;
			iconSprite.y = -5;
			iconSprite.load(new URLRequest(url));
			addChild(iconSprite);
		}
	}
}
package com.gaara.chat
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextElement;
	
	import mx.utils.StringUtil;

	/**
	 *  @author:Gaara
	 *  2012-10-10
	 *  富文本转换工具
	 **/
	public class RichTextAreaUtil
	{
		/** 图片标签 **/
		private static const IMG:String = "img";
		
		/** 文本标签 **/
		private static const FONT:String = "font";
		
		/** 表情数组 **/
		public static var faceVec:Vector.<FaceLoader> = new Vector.<FaceLoader>;
		
		/**
		 *  功能:html转换成xml
		 *  参数:
		 **/
		private static function htmlToXml(content:String,txtColor:String,size:int):XML
		{
			var fontTxt:String = "<font color='{0}' size='{1}'>{2}</font>"
			var splitArr:Array = content.split(/(<.*?\/.*?>)/);
			var xml:XML = <body/>;
			for each (var str:String  in splitArr) 
			{
				if(str == ""){
					continue;
				}
				
				if(str.indexOf("<") != -1){
					xml.appendChild(new XML(str));
				}
				else {
					xml.appendChild(new XML(StringUtil.substitute(fontTxt,txtColor,size,str)));
				}
			}
			
			return xml;
		}
		
		/**
		 *  功能:把一串HTML变成一个个的HTML
		 *  参数:
		 **/
		public static function htmlToArray(conten:String,color:String="#ffffff",size:int=12):Array
		{
			var xml:XML = htmlToXml(conten,color,size);
			var newXml:XML;
			var itemStr:String;
			var arr:Array = [];
			var attr:XMLList;
			for each(var item:XML in xml.children()){
				itemStr = item.text();
				if(item.name() == "font"){
					for(var i:int = 0;i < itemStr.length;i++){
						newXml = new XML(item);
						newXml.setChildren(itemStr.charAt(i));
						newXml.@bold = "true";
						arr.push(newXml.toXMLString());
					}
				}
				else if(item.name() == "img"){
					arr.push(item.toXMLString());
				}
			}
			return arr;
		}
		
		/**
		 *  功能:返回内容
		 *  参数:
		 **/
		public static function getContentArr(content:String,txtColor:String="#d8e5c6",size:int=12):GroupElement
		{
			var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
			
			//将内容转成xml
			var toXml:XML = htmlToXml(content,txtColor,size);
			var tagName:String;
			
			for each (var xml:XML in toXml.children()) 
			{
				tagName = xml.name();
				if(tagName == IMG){
					//表情
					var iconSprite:FaceLoader = new FaceLoader(24,12);
					iconSprite.load(xml.@src);
					faceVec.push(iconSprite);
					var format:ElementFormat = new ElementFormat();
					format.dominantBaseline = TextBaseline.ASCENT;
					var face:GraphicElement = new GraphicElement(iconSprite,24,0,format);
					groupVector.push(face);
				}
				else if(tagName == FONT){
					//文本
					var color:int;
					var bold:Boolean;
					if(xml.attribute("color").length() > 0){
						color =  HtmlUtil.colorStrToInt(xml.@color)
					}
					else {
						color =  HtmlUtil.colorStrToInt(txtColor);
					}
					
					if(xml.attribute("bold").length() > 0){
						bold =  Boolean(xml.@bold);
					}
					var fmt:ElementFormat = ChatTextAreaUtil.createFormat(color,size,bold);
					var contentTE2:TextElement = new TextElement(xml.toString(),fmt);
					groupVector.push(contentTE2);
				}
				else if(tagName == "br"){
					
				}
			}
			
	/*		var splitArr:Array = content.split(/(\[[f,i,vip,c][^\[]+?\])/);
			
			for(var i:int=0; i < splitArr.length; i++){
				var item:String = splitArr[i];
				if (iconReg.test(item)){
					var iconId:int = int(item.slice(2, item.length - 1));
					if( iconId > FacePanel.FACE_NUM){
						continue;
					}
					var url:String = UrlManager.getUrl(StringUtil.substitute("resource/face/f{0}.swf",iconId));
					var format:ElementFormat = new ElementFormat();
					format.fontSize = size;
					
					var iconSprite:ChatFaceIcon = new ChatFaceIcon;
					iconSprite.y = 6;
					iconSprite.url = url;
					faceVec.push(iconSprite);
					var face:GraphicElement = new GraphicElement(iconSprite,25,24,format);
					groupVector.push(face);
				}
				else if(itemReg.test(item)){
					var textArr:Array = item.split("|");
					var color:int =  HtmlUtil.colorStrToInt(textArr[1]);
					var text:String =  textArr[2];
					
					var contentTE2:TextElement = new TextElement(text.substr(0,text.length-1),ChatTextAreaUtil.createFormat(color,size));
					groupVector.push(contentTE2);
				}else{
					if(item == ""){
						continue;
					}
					
					var contentTE:TextElement = new TextElement(item,ChatTextAreaUtil.createFormat(0xd8e5c6,size));
					groupVector.push(contentTE);
				}
			}*/
			
			return new GroupElement(groupVector);
		}
	}
}
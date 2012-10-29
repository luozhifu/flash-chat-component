package com.gaara.chat
{
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineCreationResult;
	import flash.text.engine.TextLineMirrorRegion;
	
	/**
	 *  @author:Gaara
	 *  2012-7-11
	 *  图文混排
	 *   
	 * 
	 **/
	public class RichTextArea extends Sprite
	{
		/** 记录初始位置 **/
		public var offsetY:int = 0;
		
		/** 行距 **/
		public var space:int = 8;
		
		/** 行高 **/
		public var rowHeight:int = 0;
		
		/** 保存上个显示内容的引用**/
		private var preTextLine:TextLine;
		private var fontSize:int = 12;
		
		public function RichTextArea()
		{
			this.mouseEnabled = false;
		}
		
		/**
		 *  功能:添加内容组
		 *  参数:
		 **/
		public function appendGroupE(groupE:GroupElement,newLine:Boolean=false):void
		{
			var textBlock:TextBlock = new TextBlock;
			textBlock.baselineZero =  TextBaseline.ASCENT;
			textBlock.content = groupE;
			
			//第一次创建减去前辍宽度
			var textLine:TextLine;
			var preRight:int;
			
			var levPixel:int = width;
			if(!newLine){
				if(preTextLine){
					//前面有内容
					preRight = preTextLine.x + preTextLine.width;
					levPixel	-= preRight;
				}
			}
			else 	if(preTextLine){
				offsetY += rowHeight?rowHeight:preTextLine.height+space;
			}
			
			textLine = textBlock.createTextLine (null,levPixel);
			if(!textLine && isNewLine(textBlock)){
				//指定的宽度无法创建
				preRight = 0;
				offsetY += rowHeight?rowHeight:preTextLine.height+space;
				textLine = textBlock.createTextLine(null, width);
			}
			while (textLine)
			{
				textLine.filters = [ new GlowFilter(0,1,2,2,16)];
				for each (var tlm:TextLineMirrorRegion in textLine.mirrorRegions) 
				{
					//用此变量来作为下划线标志
					if(tlm.element.userData){
						var shape:Shape = new Shape();
						var g:Graphics = shape.graphics;
						g.lineStyle(1,0xd8e5c6);
						g.moveTo(tlm.bounds.left+4, tlm.bounds.bottom+1);
						g.lineTo(tlm.bounds.left+tlm.bounds.width-4, tlm.bounds.bottom+1);
						textLine.addChild(shape);
					}
				}
				
				textLine.x = preRight;
				
				addChild(textLine);
				preTextLine = textLine;
				textLine.y = offsetY;
				
//				height = textLine.y + textLine.height  +rowHeight;
				
				preRight = preTextLine.x + preTextLine.width;
				
				textLine = textBlock.createTextLine(preTextLine, width - preRight);
				if(!textLine && isNewLine(textBlock)){
					//指定的宽度无法创建
					preRight = 0;
					offsetY += rowHeight?rowHeight:preTextLine.height+space;
					textLine = textBlock.createTextLine(preTextLine, width);
				}
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 *  功能:是否需要换行
		 *  参数:
		 **/
		public function isNewLine(textBlock:TextBlock):Boolean
		{
			return textBlock.textLineCreationResult == TextLineCreationResult.EMERGENCY || 
				textBlock.textLineCreationResult == TextLineCreationResult.INSUFFICIENT_WIDTH;
		}
		
		/**
		 *  功能:清除内容
		 *  参数:
		 **/
		public function clear():void
		{
			while(numChildren > 0){
				var tl:TextLine = removeChildAt(0) as TextLine;
			}
			offsetY = 0;
			preTextLine = null;
			ChatTextAreaUtil.stopAndClearFaces();
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
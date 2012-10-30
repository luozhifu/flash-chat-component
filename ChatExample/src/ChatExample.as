package
{
	import com.gaara.chat.ChatTextAreaUtil;
	import com.gaara.chat.RichTextArea;
	import com.gaara.chat.RichTextAreaUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.engine.ContentElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineMirrorRegion;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 *  @author:Gaara
	 *  2012-9-28
	 *  聊天组件测试
	 **/
	[SWF(width="200", height="100" ,frameRate="30", backgroundColor="#FFFFFF")]
	public class ChatExample extends Sprite
	{   
		/** 性别 **/
		private static const SEXARR:Array = ["♀","♂"];
		
		/** 图文混排组件 **/
		private var textArea:RichTextArea;
		
		public function ChatExample()
		{
			//创建图文混排面板
			textArea = new RichTextArea;
			//添加背景
			var back:Sprite = new Sprite;
			back.graphics.beginFill(0,0.5);
			back.graphics.drawRect(0,0,200,100);
			back.graphics.endFill();
			textArea.addChild(back);
			addChild(textArea);
			
			//添加聊天内容 
			var str:String = "adfadsfasdfaaa[f1]aaa"
			appendRichText(str);
			
			str = "Gaara";
			appendRichText(str);
		
			var htmlTxt:String = '<img src="f0.swf"/>';
			
			textArea.appendGroupE(RichTextAreaUtil.getContentArr(htmlTxt),true);
		}
		
		/**
		 *  功能:添加聊天内容
		 *  参数:
		 **/
		public function appendRichText(content:String):void
		{
			var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
			
			//频道
			var temp:String = "[世界]"
			
			var eventDP:EventDispatcher = new EventDispatcher;
			eventDP.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler,false,0,true);
			eventDP.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler,false,0,true);
			eventDP.addEventListener(MouseEvent.CLICK,onChannelClk,false,0,true);
			
			
			var channelColor:uint =  0xff0000;
			var channelTE:TextElement = new TextElement(temp,ChatTextAreaUtil.createFormat(channelColor));
			channelTE.eventMirror = eventDP;
			groupVector.push(channelTE);
			
			//性别
			temp = SEXARR[0] +"[";
			var sexTE:TextElement = new TextElement(temp,ChatTextAreaUtil.createFormat());
			groupVector.push(sexTE);
			
			//性名
			temp = "没名字";
			
			eventDP = new EventDispatcher;
			eventDP.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler,false,0,true);
			eventDP.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler,false,0,true);
			eventDP.addEventListener(MouseEvent.CLICK,onNameClk,false,0,true);
			
			var nameTE:TextElement = new TextElement(temp,ChatTextAreaUtil.createFormat());
			nameTE.eventMirror = eventDP;
			groupVector.push(nameTE);
			
			//用此变量来作为下划线标志
			nameTE.userData = true;
			
			temp = "]:";
			var flagTE:TextElement = new TextElement(temp,ChatTextAreaUtil.createFormat());
			groupVector.push(flagTE);
			
			ChatTextAreaUtil.getContentArr(content,groupVector);
			
			textArea.appendGroupE(new GroupElement(groupVector),true);
		}
		
		
		
		/**
		 *  功能:光标
		 *  参数:
		 **/
		private function onMouseOverHandler(event:Event):void
		{
			if(!(event.target is TextLine) || (event.target as TextLine).mirrorRegions.length == 0){
				return;
			}
			
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		/**
		 *  功能:光标
		 *  参数:
		 **/
		private function onMouseOutHandler(event:Event):void
		{
			if(!(event.target is TextLine) || (event.target as TextLine).mirrorRegions.length == 0){
				return;
			}
			
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		/**
		 *  功能:点击频道
		 *  参数:
		 **/
		private function onChannelClk(event:Event):void
		{
			event.stopImmediatePropagation();
			
			//找出事件分发者，取出附带信息
			var selTlm:TextLineMirrorRegion;
			var textLine:TextLine = event.target as TextLine;
			for each (var tlm:TextLineMirrorRegion in textLine.mirrorRegions) 
			{
				if(tlm.bounds.contains(textLine.mouseX,textLine.mouseY)){
					selTlm = tlm;
					break;
				}
			}
			
			var eventDP:EventDispatcher = selTlm.mirror as EventDispatcher;
		}
		
		/** 点击名称 **/
		protected function onNameClk(event:Event):void
		{
			//处理相应的事件
		}
	}
}
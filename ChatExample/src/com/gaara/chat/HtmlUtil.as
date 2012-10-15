package  com.gaara.chat
{
	
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	/** Html相关生成工个 */
	public class HtmlUtil
	{
		/** 为字符串添加颜色 */
		public static function color(str:Object, color:String,underLine:Boolean=false):String
		{
			if (color == null)
				color = "#ffffff";
			if(underLine){
				return "<u><FONT COLOR='" + color + "'>" + str.toString() + "</FONT></u>";
			}
			return "<FONT COLOR='" + color + "'>" + str.toString() + "</FONT>";
		}
		
		/** 为字符串添加颜色 */
		public static function colorInt(str:Object, color:int,size:int=12,underLine:Boolean=false):String
		{
			var colorStr:String = "#" + color.toString(16);
			if(underLine){
				return "<u><FONT COLOR='" + color + "'>" + str.toString() + "</FONT></u>";
			}
			return "<FONT SIZE='" + size + "' COLOR='" + colorStr + "'>" + str.toString() + "</FONT>";
		}
		
		/** 为字符串添加颜色 */
		public static function colorIntNoSize(str:Object, color:uint):String
		{
			var colorStr:String = "#" + color.toString(16);
			return "<FONT  COLOR='" + colorStr + "'>" + str.toString() + "</FONT>";
		}
		
		public static function setStringSize(str:Object,size:int=12):String
		{
			return "<FONT SIZE='" + size + "'>" + str.toString() + "</FONT>";
		}
		
		/** 添加字体颜色 */
		public static function sizeColor(str:String, color:String, size:int):String
		{
			return "<FONT SIZE='" + size + "' COLOR='" + (color == null ? "#FFFFFF" : color) + "'>" + str + "</FONT>";
		}
		
		/** 添加链接 */
		public static function link(str:String,linkEvt:String="myevent",color:uint=0xffff00):String
		{
			var colorStr:String = "#" + color.toString(16);
			return "<a href='event:"+linkEvt+"'><u><font color='" + colorStr + "'>"+str+"</font></u></a>";
		}
		
		public static function linkUnLine(str:String,linkEvt:String,color:String):String{
			return "<a href='event:"+linkEvt+"'><font color='" + color + "'>"+str+"</font></a>";
		}
		
		/**
		 *拼接整句的颜色，适用于一个完整的句子拼接。 
		 * @param content句子内容，包含标识位，标识位为^
		 * @param arrColor颜色数组，元素为string，长度与句子按照标识位断开后的长度保持一致；颜色为默认则string置为""。
		 * @return 一个包含html脚本的句子字符串
		 * 
		 */		
		public static function setSentenceColor(content:String,arrColor:Array):String
		{
			var str:String = "";
			var arrSentence:Array= content.split("^");
			var sentenceLen:int = arrSentence.length;
			var colorStr:String;
			
			for(var j:int=0;j<sentenceLen;j++)
			{
				colorStr = arrColor[j] as String;
				if(colorStr==null||colorStr=="")
				{
					str+=arrSentence[j];
				}
				else
				{
					str += HtmlUtil.color(arrSentence[j]as String,arrColor[j]as String);
				}
			}
			return str;
		}
		
		/**
		 * 获取带下划列的html文本 
		 * @param str
		 * @param fontSize
		 * @param linkEvt
		 * @return 
		 * 
		 */		
		static public function getLinkHtml(str: String, fontSize: int = 12, linkEvt: String = "open"): String
		{
			return "<A HREF='event:" + linkEvt + "' TARGET=\"_blank\"><u><font size='" + fontSize + "'>" + str + "</font></u></A>";
		}
		
		/** 去除字符串中的html代码 **/
		public static var re1:RegExp = /<[^>]*>|\s/g;
		public static function delHtmlCodeWithWhite(str:String):String{
			return str.replace(re1,"");
		}
		
		/** 去除字符串中的html代码 **/
		public static var re2:RegExp = /<[^>]*>/g;
		public static function delHtmlCode(str:String):String{
			return str.replace(re2,"");
		}
		
		/**
		 *  功能:返回自己输入的html内容
		 *  参数:
		 **/
		public static function getMyHtmlText(str:String):String
		{
			var pre:String
			if(str.indexOf('<FONT FACE="SimSun"') != -1){
				pre = 'KERNING="0">';
				str = str.substr(0,str.lastIndexOf("</FONT>"));
				str = str.substr(str.indexOf(pre) + pre.length);
			}
			else {
				pre = '<P ALIGN="LEFT">';
				str = str.substr(0,str.lastIndexOf("</P>"));
				str = str.substr(str.indexOf(pre) + pre.length);
			}

			return str;
		}
		
		/**
		 * 加粗字体 
		 * @param str
		 * @return 
		 * 
		 */		
		static public function boldStr(str: String): String
		{
			return "<B>" + str + "</B>";
		}
		
		
		/** 文本对齐，不足补空格 返回字符带空格**/
		public static function htmlAlign(str:String,num:int):String{
			var ba:ByteArray = new ByteArray();
			ba.writeMultiByte(str, "");
			while(ba.length<num){
				str += " ";
				ba.clear();
				ba.writeMultiByte(str,"");
			}
			return str;
		}
		
		/** 文本对齐，不足补空格  只返回补足的空格**/
		public static function htmlAlignNew(str:String,num:int):String{
			var newStr:String = "";
			var ba:ByteArray = new ByteArray();
			ba.writeMultiByte(str, "");
			while(ba.length<num){
				newStr += " ";
				ba.clear();
				ba.writeMultiByte(str+newStr,"");
			}
			return newStr;
		}		
		
		
		/**
		 * 颜色转换，字符符转整型
		 * 
		 */		
		public static function colorStrToInt(str:String):uint{
			if(str.charAt(0)=='#'){
				str=str.substring(1,str.length);
			}			
			return parseInt(str,16);
		}
		
		//把颜色从数字型转成字符型,即#000000;
		public static function getColorStr(color:uint):String
		{
			var result:String = "#";
			var i:int
			result += color.toString(16);
			
			return result;
		}
	}
}
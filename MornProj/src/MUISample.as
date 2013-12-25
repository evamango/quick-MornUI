package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import game.ui.UISampleView;
	
	import morn.core.handlers.Handler;
	
	[SWF(width = "1024", height = "768", frameRate = "24", backgroundColor = "#ffffff")]
	public class MUISample extends Sprite
	{
		public function MUISample()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			Config.uiPath = "ui.swf";
			App.init(this);
			
			//加载资源
			App.loader.loadAssets(["assets/share.swf"],new Handler(onLoadComplete),new Handler(loadProgress));
		}
		
		private function loadProgress(value:Number):void {
			//加载进度
			//trace("loaded", value);
		}
		
		private function onLoadComplete():void {
			//实例化场景
			addChild(new UISampleView());
		}
	}
}
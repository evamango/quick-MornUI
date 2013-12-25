package game.ui
{
	import com.wills.common.utils.EasyBuilder;
	
	import flash.events.MouseEvent;

	public class UISampleView extends UISampleUI
	{
		public function UISampleView()
		{
			super();
			
			btnClose.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(evt:MouseEvent):void
		{
			btnClose.right = 20;
		}
	}
}
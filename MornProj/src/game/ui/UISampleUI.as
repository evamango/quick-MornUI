/**Created by the Morn,do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class UISampleUI extends View {
		public function UISampleUI(){}
		override protected function createChildren():void {
			loadUI("UISample.xml");
		}
	}
}
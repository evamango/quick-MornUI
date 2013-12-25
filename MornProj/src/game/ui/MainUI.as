/**Created by the Morn,do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class MainUI extends View {
		public function MainUI(){}
		override protected function createChildren():void {
			loadUI("Main.xml");
		}
	}
}
package evans.components
{
	import morn.core.components.Box;
	/**
	 *组件按钮 
	 * @author evans
	 * 
	 */	
	public class CombineButton extends Box
	{
		
		protected var _type:String;
		
		public function CombineButton()
		{
			super();
		}
		
		public function set type(v:String):void
		{
			_type = v
		}
	}
}
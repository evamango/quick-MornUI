package evans.components
{
	
	import morn.core.components.Image;
	
	/**
	 *带外框的图片 
	 * @author evans
	 * 
	 */
	public class ImageWithBorder extends Image
	{
		
		/**
		 *边框 
		 */
		protected var _border:Image;
		
//		protected var _urlImage:String;
		
		protected var _urlBorder:String;
		
		
		public function ImageWithBorder(urlBorder:String=null)
		{
			super(null);
			this.urlBorder = urlBorder;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(_border = new Image());
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_border.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			_border.height = value;
		}
		
		/**
		 *边框9宫格 
		 * @param value
		 * 
		 */
		public function set sizeGridBorder(value:String):void
		{
			_border.sizeGrid = value;
		}
		
		/**
		 *边框图片路径 
		 * @param value
		 * 
		 */
		public function set urlBorder(value:String):void
		{
			if (_urlBorder != value) {
				_urlBorder = value;
				
				_border.url = _urlBorder;
			}
		}
	}
}
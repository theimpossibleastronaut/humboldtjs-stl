package com.theimpossibleastronaut.humboldtjs.stl.view.htmltemplate
{
	import asjs.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.INotifier;
	
	/**
	 * Empty HtmlTemplateView which will be constructed if an inheriting view isn't set
	 * in the HtmlTemplateViewMediator. You will need to add the view to your stage yourself.
	 * 
	 * @see com.theimpossibleastronaut.humboldtjs.stl.view.htmltemplate.HtmlTemplateViewMediator
	 */
	public class HtmlTemplateView extends DisplayObject
	{
		protected var mMediator:INotifier;
		public function setNotifier(value:INotifier):void { mMediator = value; }
		
		public function HtmlTemplateView()
		{
			super();
		}
	}
}
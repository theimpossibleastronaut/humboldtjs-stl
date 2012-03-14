package com.theimpossibleastronaut.humboldtjs.stl.view.htmltemplate
{
	import asjs.display.DisplayObject;
	import asjs.events.ASJSEvent;
	import asjs.net.PrefixLoader;
	import asjs.net.URLRequest;
	
	import com.theimpossibleastronaut.humboldtjs.stl.model.ObjectStoreProxy;
	import com.theimpossibleastronaut.humboldtjs.stl.notes.ObjectStoreNotes;
	
	import dom.eventFunction;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * Base class for mediating the template loading and the template view for html based
	 * templates. Inherit your mediator and views from this if you want to change behaviour.
	 * If you want to show unprocessed html, just instantiate a new HtmlTemplateViewMediator
	 * and add it's viewcomponent to your stage.
	 * 
	 * This mediator uses the ObjectStoreProxy to cache the loaded template files.
	 * We expect files in the htmlp format. You can create this file using the xmlpconverter
	 * with the -n flag (for no processing).
	 * 
	 * @example
	 * loadTemplate("path/to/template.htmlp");
	 * 
	 * @see com.theimpossibleastronaut.humboldtjs.stl.model.ObjectStoreProxy
	 */
	public class HtmlTemplateViewMediator extends Mediator
	{
		public static const NAME:String = "htmltemplateviewviewmediator";
		
		protected var mObjectStore:ObjectStoreProxy;
		protected var mObjectStoreIdentifier:String;
		
		public function HtmlTemplateViewMediator(aName:String = "", aView:DisplayObject = null)
		{
			
			var theView:DisplayObject = aView;
			
			if (theView == null)
				theView = new HtmlTemplateView();
						
			super(aName == null || aName == "" ? NAME : aName, theView);			
		}
		
		override public function onRegister():void
		{
			mObjectStore = facade.retrieveProxy(ObjectStoreNotes.HTML_TEMPLATE_OBJECT_STORE_PROXY_NAME) as ObjectStoreProxy;
		}
		
		/**
		 * Load a template and tell the world we completed afterwards.
		 * If we have a cached version call onLoadComplete, otherwise start loading it
		 * and hook up onTemplateInnerLoadComplete.
		 * 
		 * @param aTemplatePath String Path at which the template is located. Ideally should be a .htmlp file.
		 */
		protected function loadTemplate(aTemplatePath:String):void
		{
			mObjectStoreIdentifier = aTemplatePath;
			
			if (mObjectStore.contains(mObjectStoreIdentifier))
				return onLoadComplete();
			
			var theLoader:PrefixLoader = new PrefixLoader();
			theLoader.addEventListener(ASJSEvent.COMPLETE, eventFunction(this, onTemplateInnerLoadComplete));
			theLoader.load(new URLRequest(aTemplatePath));
		}
		
		/**
		 * Gets called whenever the PrefixLoader has completed, we now cache the loaded contents
		 * and call the onLoadComplete function.
		 */
		protected function onTemplateInnerLoadComplete(aEvent:ASJSEvent):void
		{
			var thePrefixLoader:PrefixLoader = aEvent.getCurrentTarget() as PrefixLoader;
			mObjectStore.store(mObjectStoreIdentifier, thePrefixLoader.getContent() as String);
			
			onLoadComplete();
		}
		
		/**
		 * Set the element contents to whatever we can grab from the ObjectStoreProxy.
		 * Always overwrites the full innerHTML of the associated viewComponent.
		 */		
		protected function onLoadComplete():void
		{
			(viewComponent as DisplayObject).getHtmlElement().innerHTML = mObjectStore.retrieve(mObjectStoreIdentifier) as String;
		}
	}
}
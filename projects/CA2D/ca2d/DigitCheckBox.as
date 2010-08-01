package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * This class handles 10 checkboxes named 'c0' ... 'c9' and keeps
	 * an array of Boolean, 'activeDigits' updated to reflect
	 * which of the checkboxes are active
	 * @author Pietro Berkes
	 */
	public class DigitCheckBox extends MovieClip
	{
		// Event ID, dispatched when rule changes
		public static const RULE_CHANGED = "ruleChanged";
		
		// store references to the children 'c0', ..., 'c9'
		public var digitCheckboxes:Array = new Array(10);
		// array of Booleans, shows which checkboxes are active
		public var activeDigits:Array = new Array(10);
		
		public function DigitCheckBox()
		{
			var format:TextFormat = new TextFormat('Calibri', 12);
			for (var i:int = 0; i < 10; i++) {
				digitCheckboxes[i] = getChildByName("c" + String(i));
				// add listener to checkboxes 0..9
				digitCheckboxes[i].addEventListener(MouseEvent.CLICK, clickListener);
				// change font
				digitCheckboxes[i].setStyle('textFormat', format);
			}
		}
		
		/*
		 * whichActive: array with list of active elements, all others are assumed unactive
		 */
		public function setActive(whichActive:Array) {
			// turn everything off
			for (var i:int = 0; i < 10; i++) {
				activeDigits[i] = false;
				digitCheckboxes[i].selected = false;
			}
			// activate elements in the array
			for each (var a in whichActive) {
				activeDigits[a] = true;
				digitCheckboxes[a].selected = true;
			}
			// announce change to listeners
			dispatchEvent(new Event(RULE_CHANGED));
		}
		
		override public function toString():String {
			var txt:String = "";
			for (var i:int = 0; i < 10; i++) {
				if (activeDigits[i]) { txt += String(i); }
			}
			return txt;
		}
		
		public function clickListener(e:MouseEvent) {
			var idx:int = digitCheckboxes.indexOf(e.target)
			activeDigits[idx] = !activeDigits[idx];
			// announce change to listeners
			dispatchEvent(new Event(RULE_CHANGED));
		}
	}
	
}
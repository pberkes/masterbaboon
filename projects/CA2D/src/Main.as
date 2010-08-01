package 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * Document Class for CA2DInterface, an application to experiment
	 * with 2-dimensional Cellular Automata
	 * @author Pietro Berkes, masterbaboon.com
	 */
	public class Main extends MovieClip 
	{
		// the Cellular Automata object
		private var ca:BinaryCA;
		// update CA every updateEvery frames; if 0, never update
		private var updateEvery:int = 0;
		// frames counter used to decide if it's time to update
		private var frameCounter:int = 0;
		
		// INTERFACE COMPONENTS
		/*
		 * already on stage:
		 * playButton:PlayButton;
		 * stopButton:StopButton;
		 * ffButton:FForwardButton;
		 * survivalCheckBoxes:DigitCheckBox;
		 * birthCheckBoxes:birthCheckBoxes;
		 * clearButton:Button;
		 * randomButton:Button;
		 * ruleText: TextField;
		*/
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// set actors on stage
			// buttons
			stopButton.addEventListener(MouseEvent.CLICK, stopButtonListener);
			playButton.addEventListener(MouseEvent.CLICK, playButtonListener);
			ffButton.addEventListener(MouseEvent.CLICK, fforwardButtonListener);
			
			var format:TextFormat = new TextFormat('Calibri', 14);
			clearButton.addEventListener(MouseEvent.CLICK, clearButtonListener);
			clearButton.setStyle('textFormat', format);
			randomButton.addEventListener(MouseEvent.CLICK, randomButtonListener);
			randomButton.setStyle('textFormat', format);
			
			// digit checkboxes
			// initialize at Life CA rules
			survivalCheckBoxes.setActive([2, 3]);
			birthCheckBoxes.setActive([3]);
			// monitor for changes in the rules
			survivalCheckBoxes.addEventListener(DigitCheckBox.RULE_CHANGED, survivalRuleChangeListener);
			birthCheckBoxes.addEventListener(DigitCheckBox.RULE_CHANGED, birthRuleChangeListener);
			// set rule text field
			updateRuleText();
			
			// add CA to interface
			ca = new BinaryCA(35, 10, 0);
			ca.randomFill();
			ca.setRules(survivalCheckBoxes.activeDigits, birthCheckBoxes.activeDigits);
			ca.x = 50;
			ca.y = 28;
			addChild(ca);
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameListener);		
		}
		
		public function updateRuleText():void {
			ruleText.text = "Rule: " + survivalCheckBoxes.toString() + " / " + birthCheckBoxes.toString();
		}

		// LISTENERS
		public function enterFrameListener(e:Event):void {
			frameCounter++;
			if (updateEvery > 0 && frameCounter % updateEvery == 0) {
				ca.update();
			}
		}
		
		// speed buttons
		public function stopButtonListener(e:MouseEvent):void { updateEvery = 0; }
		
		public function playButtonListener(e:MouseEvent):void { updateEvery = 5; }
		
		public function fforwardButtonListener(e:MouseEvent):void { updateEvery = 1; }
		
		public function clearButtonListener(e:MouseEvent):void { ca.clear(); }
		
		public function randomButtonListener(e:MouseEvent):void { ca.randomFill(); }
		
		public function survivalRuleChangeListener(e:Event):void {
			ca.setRules(e.target.activeDigits, null);
			updateRuleText();
		}
		public function birthRuleChangeListener(e:Event):void {
			ca.setRules(null, e.target.activeDigits);
			updateRuleText();
		}
	}
}
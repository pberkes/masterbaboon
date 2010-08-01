package 
{
	import fl.controls.Button;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Simulated evolution.
	 * 
	 * Adapted from
	 * Dewdney, A. K.
	 * Computer recreations, simulated evolution: wherein bugs learn to hunt bacteria
	 * In Scientific american, pp. 104-107, 1989 May
	 * 
	 * @author Pietro Berkes, masterbaboon.com
	 */
	public class Main extends Sprite 
	{
		// CONSTANTS
		// =========
		
		public static const GRID_RESOLUTION:int = 10;
		public static const SIM_POS_X:int = 30;
		public static const SIM_POS_Y:int = 10;
		public static const SIM_WIDTH:int = 510;
		public static const SIM_HEIGHT:int = 355;
		public static const EDEN_POS_X:int = 30;
		public static const EDEN_POS_Y:int = 245;
		public static const EDEN_WIDTH:int = 75;
		public static const EDEN_HEIGHT:int = 75;
		public static const ADD_BACTERIUM_EVERY:int = 2;
		
		public static function randomInt(max:int):int {
			return Math.floor(Math.random() * max);
		}
		
		// VARIABLES
		// =========
		
		// spatial database to store bacteria
		public var bacteriaSD:SpatialDatabase;
		// set of alive bugs
		public var bugs:Array = new Array();
		// iteration counter
		public var iteration:uint = 0;
		
		// bacteria are on the background
		public var background:Sprite = new Sprite();
		// bugs are on the foreground
		public var foreground:Sprite = new Sprite();
		
		// if true, simulation is running
		public var playing:Boolean = false;
		// if true, Garden of Eden is active
		
		// INTERFACE COMPONENTS
		// ====================
		
		public var playButton:PlayButton;
		public var stopButton:StopButton;
		public var restartButton:Button;
		public var edenButton:Button;
		public var generationTextField:TextField;
		
		// METHODS
		// =======
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// set up simulation elements
			// ==========================
			
			background.x = SIM_POS_X;
			background.y = SIM_POS_Y;
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(0, 0, SIM_WIDTH, SIM_HEIGHT);
			addChild(background);
			foreground.x = SIM_POS_X;
			foreground.y = SIM_POS_Y;
			addChild(foreground);
			
			// spatial database to manage collision with bacteria
			bacteriaSD = new SpatialDatabase(stage.stageWidth, stage.stageWidth, GRID_RESOLUTION);
			// populate simulation with bacteria and bugs
			populate();
			
			stage.addEventListener(Event.ENTER_FRAME, updateStage);
			
			// set interface components on stage, add listeners
			// ================================================
			
			// buttons
			var format:TextFormat = new TextFormat('Calibri', 12);
			stopButton.addEventListener(MouseEvent.CLICK, stopButtonListener);
			playButton.addEventListener(MouseEvent.CLICK, playButtonListener);
			restartButton.addEventListener(MouseEvent.CLICK, restartButtonListener);
			restartButton.setStyle('textFormat', format);
			//edenButton.addEventListener(MouseEvent.CLICK, edenButtonListener);
			edenButton.setStyle('textFormat', format);
		}
		
		public function updateStage(e:Event):void {
			var maxGeneration:int = 0;
			
			if (!playing) return;
			
			iteration++;
			
			// add bacteria
			if (iteration % ADD_BACTERIUM_EVERY == 0) {
				addRandomBacterium();
				if (edenButton.selected) {
					// add bacterium in Eden area
					addRandomBacterium(EDEN_POS_X, EDEN_POS_Y, EDEN_WIDTH, EDEN_HEIGHT);
				}
			}
			
			// manage bugs
			var neighbors:Array;
			var bug:Bug;
			var children:Array;
			
			for (var i:int = 0; i < bugs.length; i++) {
				bug = bugs[i];
				if (bug.getGeneration() > maxGeneration) maxGeneration = bug.getGeneration();
				
				// update bug position
				bug.updatePos();
				
				// check for collisions with bacteria
				neighbors = bacteriaSD.getAllNeighbors(bug.x, bug.y, 1);
				for each (var b:Bacterium in neighbors) {
					// check collision
					if (checkCollision(bug, b)) {
						bug.eat();
						removeBacterium(b);
					}
				}
				
				// check energy, remove if dead
				if (bug.getEnergy() == 0) {
					// decrease index as this bug is removed from array
					removeBug(i--);
					continue;
				}
				
				// check for reproduction
				if (bug.getAge() > 800 && bug.getEnergy() > 1000) {
					// array of 2 children
					children = bug.reproduce();
					// remove parent
					removeBug(i--);
					// add children
					addBug(children[0]);
					addBug(children[1]);
				}
			}
			
			// update generation text
			generationTextField.text = "Generation: " + maxGeneration;
			
			// if no bug is left, repopulate
			if (bugs.length == 0) {
				for (i = 0; i < 5; i++ ) addRandomBug();
			}
		}
		
		public function checkCollision(bug:Bug, bacterium:Bacterium):Boolean {
			var dx:Number = bug.x - bacterium.x;
			var dy:Number = bug.y - bacterium.y;
			var r:Number = Bug.RADIUS + Bacterium.RADIUS;
			return Boolean(dx * dx + dy * dy < r * r);
		}
		
		public function populate():void {
			// add some bacteria ad random positions
			var i:int;
			for (i = 0; i < 1000; i++) addRandomBacterium();
			for (i = 0; i < 10; i++) addRandomBug();
		}
		
		public function addRandomBug():void {
			var dna:Array = new Array(6);
			for (var i:int = 0; i < 6; i++) dna[i] = 5 + randomInt(3) - 1;
			var bug:Bug = new Bug(randomInt(SIM_WIDTH - Bug.RADIUS * 2) + Bug.RADIUS,
				                  randomInt(SIM_HEIGHT - Bug.RADIUS * 2) + Bug.RADIUS, dna);
			addBug(bug);
		}
		
		public function addBug(bug:Bug):void {
			bugs.push(bug);
			// add to stage
			foreground.addChild(bug);
		}
		
		public function removeBug(idx:int):void {
			foreground.removeChild(bugs[idx]);
			bugs.splice(idx, 1);
		}
		
		public function addRandomBacterium(x:int = 0, y:int=0, w:int = SIM_WIDTH, h:int = SIM_HEIGHT):void {
			addBacterium(randomInt(w - Bacterium.RADIUS * 2) + Bacterium.RADIUS + x,
						 randomInt(h - Bacterium.RADIUS * 2) + Bacterium.RADIUS + y);
		}
		
		public function addBacterium(x:int, y:int):void {
			var bacterium:Bacterium = new Bacterium(x, y);
			// register in spatial database
			bacteriaSD.register(bacterium);
			// add to stage
			background.addChild(bacterium);
		}
		
		public function removeBacterium(bacterium:Bacterium):void {
			// remove from spatial database
			bacteriaSD.remove(bacterium);
			// remove from stage
			background.removeChild(bacterium);
		}

		// LISTENERS
		// =========
		
		public function stopButtonListener(e:MouseEvent):void { playing = false; }
		public function playButtonListener(e:MouseEvent):void { playing = true; }
		
		public function restartButtonListener(e:MouseEvent):void {
			// remove all bacteria, bugs
			while (background.numChildren > 0) removeBacterium(Bacterium(background.getChildAt(0)));
			while (bugs.length > 0) removeBug(0);
			// repopulate
			populate();
		}


	}
	
}
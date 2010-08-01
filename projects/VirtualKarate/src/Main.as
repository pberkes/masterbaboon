package {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * Karate AI game.
	 * @author Pietro Berkes
	 */
	public class Main extends MovieClip {
		
		// Variables
		// =========
		
		// player and AI scores
		public var playerScore:int = 0;
		public var aiScore:int = 0;
		
		// model of player's response
		public var playerModel:PlayerModel;
		
		// Stage variables
		// ===============
		
		// button to start game
		public var startButton:Sprite;
		
		// player and AI score fields
		public var playerScoreField:TextField;
		public var aiScoreField:TextField;
		
		// player and AI score messages
		public var playerMsg:TextField;
		public var aiMsg:TextField;
		
		// graphics with wait positions and combat buttons
		public var waitGraphics:Sprite;
		
		// StartScreen methods
		// ===================
		
		public function initStartScreen():void {
			startButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) { gotoAndStop("combatScreen"); } );
		}
		
		// CombatScreen methods
		// ====================
		
		public function initCombatScreen():void {
			playerModel = new PlayerModel(SCORE_TABLE);
			
			updateScoreFields();
			removeChild(waitGraphics);
			removeChild(playerMsg);
			removeChild(aiMsg);
			
			// init combat positions
			for (var i:int = 0; i < 4; i++) {
				P1_COMBAT_GRAPHICS[i].x = P1_POS_X[i];
				P1_COMBAT_GRAPHICS[i].y = P1_POS_Y[i];
				P2_COMBAT_GRAPHICS[i].x = P2_POS_X[i];
				P2_COMBAT_GRAPHICS[i].y = P2_POS_Y[i];
			}
			
			// add listeners to combat buttons
			waitGraphics.getChildByName("buttonPunch").addEventListener(MouseEvent.CLICK, punchListener);
			waitGraphics.getChildByName("buttonKick").addEventListener(MouseEvent.CLICK, kickListener);
			waitGraphics.getChildByName("buttonParryPunch").addEventListener(MouseEvent.CLICK, parryPunchListener);
			waitGraphics.getChildByName("buttonParryKick").addEventListener(MouseEvent.CLICK, parryKickListener);
			
			waitPhase();
		}
		
		// show buttons, wait for player's action
		public function waitPhase():void {
			// show wait graphics
			addChild(waitGraphics);
		}
		
		// execute player's action
		// action codes: 0=punch, 1=kick, 2=parry punch, 3=parry kick
		public function actionPhase(action:int) {
			// logic part
			// ----------
			
			// choose response
			var response:int = playerModel.chooseMove();
			// update player's model
			playerModel.update(action);

			// update score
			playerScore += SCORE_TABLE[action][response];
			aiScore += SCORE_TABLE[response][action];
			
			// graphical part
			// --------------
			
			// remove wait graphics
			removeChild(waitGraphics);

			// show combat graphics and update scores
			updateScoreFields();
			addChild(P1_COMBAT_GRAPHICS[action]);
			addChild(P2_COMBAT_GRAPHICS[response]);
			
			// show message and score
			playerMsg.text = score2msg(SCORE_TABLE[action][response]);
			addChild(playerMsg);
			aiMsg.text = score2msg(SCORE_TABLE[response][action]);
			addChild(aiMsg);
			
			// wait for some time, then return at wait phase
			var displayTimer:Timer = new Timer(COMBAT_DELAY_MS, 1);
			displayTimer.addEventListener(TimerEvent.TIMER, callWhenOver);
			displayTimer.start();
			
			function callWhenOver(e:TimerEvent) {
				// clean up
				removeChild(P1_COMBAT_GRAPHICS[action]);
				removeChild(P2_COMBAT_GRAPHICS[response]);
				removeChild(playerMsg);
				removeChild(aiMsg);
				// restart
				waitPhase();
			} 
		}
		
		private function score2msg(score:int):String {
			if (score == 0) {
				return "Miss +0";
			} else if (score == 5) {
				return "Parry +5";
			} else {
				return "Hit! +10"
			}
		}
		
		private function updateScoreFields():void {
			playerScoreField.text = String(playerScore);
			aiScoreField.text = String(aiScore);
		}
		
		// Combat buttons
		// ==============
		
		public function punchListener(e:MouseEvent):void { actionPhase(0); }
		public function kickListener(e:MouseEvent):void { actionPhase(1); }
		public function parryPunchListener(e:MouseEvent):void { actionPhase(2); }
		public function parryKickListener(e:MouseEvent):void { actionPhase(3); }
		
		// Constants
		// =========

		// SCORE_TABLE[i][j] is score of playing action 'i' when opponent chooses action 'j'
		public const SCORE_TABLE:Array = [[10, 0, 0, 10], [10, 10, 10, 0], [5, 0, 0, 0], [0, 5, 0, 0]];
		
		public const COMBAT_DELAY_MS:int = 1000;
		
		public const P1_COMBAT_GRAPHICS:Array = [new Bitmap(new P1PunchBitmapData(127, 173)),
												 new Bitmap(new P1KickBitmapData(158, 107)),
												 new Bitmap(new P1ParryPunchBitmapData(110, 188)),
												 new Bitmap(new P1ParryKickBitmapData(74, 184))];
		public const P1_POS_X:Array = [192, 189, 199, 180];
		public const P1_POS_Y:Array = [148, 217, 136, 135];
		
		public const P2_COMBAT_GRAPHICS:Array = [new Bitmap(new P2PunchBitmapData(118, 174)),
												 new Bitmap(new P2KickBitmapData(168, 109)),
												 new Bitmap(new P2ParryPunchBitmapData(116, 183)),
												 new Bitmap(new P2ParryKickBitmapData(75, 183))];
		public const P2_POS_X:Array = [247, 221, 288, 318];
		public const P2_POS_Y:Array = [150, 217, 142, 138];
	}
	
}
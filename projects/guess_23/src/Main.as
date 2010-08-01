package {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.*;
	import flash.net.*;
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	
	/**
	 * "Guess 2/3 of the average" game.
	 * @author Pietro Berkes, www.masterbaboon.com
	 */
	public class Main extends MovieClip {
		
		// CONSTANTS
		// =========
		
		// number of top scores to display after submission
		public static const NTOP:int = 20;
		// messages displayed after the player's rank
		public static const MESSAGES:Array = ["You rock!", "Not bad!", "How lame!"];
		
		// VARIABLES
		// =========
		
		// the data returned by the server after submission
		private var data:XML;
		// store player name
		private var playerName:String = "Guesser";
		
		// INTERFACE COMPONENTS
		// ====================
		
		public var submitButton:SubmitButton;
		public var errorField:TextField;
		public var nameField:TextField;
		public var guessField:TextField;
		
		public var tryAgainButton:TryAgainButton;
		public var scoresDataGrid:DataGrid;
		public var playerScoreField:TextField;
		public var playerRankField:TextField;
		
		// submitFrame METHODS
		// ===================
		
		/**
		 * This function is called by the .fla file when the frame is entered.
		 */
		private function initSubmitFrame():void {
			// stop the movie when the program starts
			stop();

			guessField.restrict = '0-9';
			guessField.text = '0';
			nameField.text = playerName;
			
			// clean error field
			printError("");

			// submitFrame listeners
			submitButton.addEventListener(MouseEvent.CLICK, submitButtonClickListener);
		}
		
		public function submitButtonClickListener(e:Event):void {
			// Check that the entries are valid
			// check name
			if (nameField.text.length == 0) {
				printError("Please enter your name");
				return;
			}
			
			// check guess
			if (guessField.text.length == 0) {
				printError("Please enter your guess");
				return;
			}
		
			var name:String = nameField.text;
			playerName = name;
			var guess:uint = uint(guessField.text);
			
			// Submit data to server
			printError("Submitting...");
			submitGuess(name, guess, NTOP);
		}
		
		/**
		 * Report an error on stage.
		 * @param	txt		Error text
		 */
		public function printError(txt:String):void {
			errorField.text = txt;
		}
		
		public function submitGuess(name:String, guess:uint, ntop:int):void {
			var request:URLRequest = new URLRequest("http://www.masterbaboon.com/php/guess23/guess23submit.php");
			var httpHeader : URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			request.requestHeaders.push(httpHeader);

			// request variables: name of player, guess, number of top scores to return
			var vars:URLVariables = new URLVariables();
			vars.name = name;
			vars.guess = guess;
			vars.ntop = ntop;
			// this is to trick AS3 into not caching the URL request
			vars.nocache = Number(new Date().getTime());

			request.method = URLRequestMethod.GET;
			request.data = vars;
			
			// send to server and call loadingComplete when complete
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadingComplete);
			try {
				loader.load(request);
			} catch (e:Error) {
				trace("An error has occurred while communicating with the server.");
				trace(e);
			}
		}
		
		public function loadingComplete(e:Event):void {
			data = XML(e.target.data);
			// switch frame
			gotoAndStop("highScoreFrame");
		}
		
		// highScoreFrame METHODS
		// ======================
		
		/**
		 * This function is called by the .fla file when the frame is entered.
		 */
		public function initHighScoresFrame():void {
			// display player's score
			var rank:int = data.current.@rank;
			var msg:String;
			if (rank <= 5) { msg = MESSAGES[0]; }
			else if (rank <= 20) { msg = MESSAGES[1]; }
			else { msg = MESSAGES[2]; }
			playerRankField.text = "You are in rank " + rank +"! " + msg;
			
			var score:Number = data.current.score;
			playerScoreField.text = data.current.name + ", your score is " + formatNumber(score);
			
			// update top scores table
			scoresDataGrid.addColumn("Rank");
			scoresDataGrid.addColumn("Name");
			scoresDataGrid.addColumn("Score");
			
			var dp:DataProvider = new DataProvider();
			for each (var entry in data.entry) {
				dp.addItem( { Rank:int(entry.@rank), 
					Name:entry.name,
					Score:formatNumber(entry.score) } );
			}

			scoresDataGrid.dataProvider = dp;
			
			// button listener
			tryAgainButton.addEventListener(MouseEvent.CLICK, tryAgainButtonClickListener);
		}
		
		public function tryAgainButtonClickListener(e:Event):void {
			gotoAndStop("submitFrame");
		}
		
		private function formatNumber(n:Number, prec:int = 2):String {
			var factor:Number = Math.pow(10, prec);
			return String(int(Math.floor(n * factor)) / factor);
		}
	}
	
}
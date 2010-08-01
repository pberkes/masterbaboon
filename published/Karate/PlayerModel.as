package  {
	
	/**
	 * Builds a model of the player's responses and predicts next move.
	 * Here the model is a 2nd order Markov model.
	 * @author Pietro Berkes
	 */
	public class PlayerModel {

		// VARIABLES
		// =========
		
		// last 3 moves
		public var history:Array = [3, 3, 3];
		// transition table: transitions[i,j,k] stores the number
		// of time the player pressed 'i' followed by 'j' followed by 'k'
		public var transitions:Array;
		
		// gain table: gainTable[i][j] is the number of point gained over the player
		// if he chooses action 'i' and opponent chooses 'j'
		public var gainTable:Array;
		
		// INIT FUNCTIONS
		// ==============

		public function PlayerModel(scoreTable:Array) {
			initTransitionTable();
			initGainTable(scoreTable);
		}
		
		/*
		 * Init all entries of the transition table to 1.
		 * (You can think of it as a uniform prior over transitions.)
		 */
		protected function initTransitionTable():void {
			transitions = new Array(4);
			for (var i:int = 0; i < 4; i++) {
				transitions[i] = new Array(4);
				for (var j:int = 0; j < 4; j++) {
					transitions[i][j] = [1, 1, 1, 1];
				}
			}
		}
		
		/*
		 * Init gain table with the difference of opponent to player score.
		 */
		protected function initGainTable(scoreTable:Array):void {
			gainTable = new Array(4);
			for (var i:int = 0; i < 4; i++) {
				gainTable[i] = new Array(4);
				for (var j:int = 0; j < 4; j++) {
					gainTable[i][j] = scoreTable[j][i] - scoreTable[i][j];
				}
			}
		}
		
		// PUBLIC FUNCTIONS
		// ================
		
		/*
		 * Update history and transition tables with player's move.
		 */
		public function update(move:int):void {
			history = [history[1], history[2], move];
			transitions[history[0]][history[1]][history[2]] += 1;
		}
		
		/*
		 * Return probability distribution for next move.
		 */
		public function predict():Array {
			// probability distribution over next move
			var prob:Array = new Array(4);
			
			// look up previous transitions from moves at time t-2, t-1
			var tr:Array = transitions[history[1]][history[2]];
			
			// normalizing constant
			var sum:Number = 0;
			for (var k:int = 0; k < 4; k++) {
				sum += tr[k];
			}
			
			for (k = 0; k < 4; k++) {
				prob[k] = tr[k] / sum;
			}
			
			return prob;			
		}
		
		/*
		 * Choose move that maximizes expected score
		 */
		public function chooseMove():int {
			// predict player's move
			var prob:Array = predict();
			
			// expected score table
			var score:Array = new Array(4);
			for (var i:int = 0; i < 4; i++) {
				for (var j:int = 0; j < 4; j++) {
					if (i == 0) score[j] = 0;
					score[j] += prob[i] * gainTable[i][j];
				}
			}
			
			// find move with maximal expected score
			var bestScore:Number = -Number.MIN_VALUE;
			var bestMove:int = 0;
			for (i = 0; i < 4; i++) {
				if (score[i] > bestScore) {
					bestScore = score[i];
					bestMove = i;
				}
			}
			
			//trace(gainTable);
			//trace('p', prob);
			//trace('s', score, bestMove);
			return bestMove;
		}
	}
	
}
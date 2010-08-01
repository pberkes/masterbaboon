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
		public var history:Array = [1, 3, 2];
		// transition table: transitions[i,j,k] stores the number
		// of time the player pressed 'i' followed by 'j' followed by 'k'
		public var transitions:Array;
		
		// INIT FUNCTIONS
		// ==============

		public function PlayerModel() {
			initTransitionTable();
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
		
	}
	
}
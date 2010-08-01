package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.flashapi.swing.color.Color;
	
	/**
	 * Predict the keys pressed by the player.
	 * @author Pietro Berkes
	 */
	public class Main extends Sprite {
		
		// player's model to predict next move
		public var model:PlayerModel = new PlayerModel();
		// predicted move
		public var prediction:int = 0;
		
		// total number of moves
		public var total:int = 0;
		// number of correct guesses
		public var correct:int = 0;
		
		// text fields
		public var moveText:TextField;
		public var predictText:TextField;
		public var percentText:TextField;
		public const MOVE_SIZE:int = 120;
		public const MOVE_YPOS:int = 140;
		public const MOVE_XPOS:int = 80;
		public const PERCENT_SIZE:int = 36;
		public const PERCENT_YPOS:int = 300;
		public const PREDICT_XPOS:int = 360;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// setup screen
			
			// title
			var text:TextField = createText("MY A.I. READS YOUR MIND", 42, 0, true, 225, 5);
			stage.addChild(text);
			text = createText("Choose 1,2,3, or 4", 32, 0, false, 225, 50);
			stage.addChild(text);
			
			// move/prediction text
			text = createText("Your choice", 26, 0, false, MOVE_XPOS, MOVE_YPOS - 20);
			stage.addChild(text);
			text = createText("Predicted", 26, 0, false, PREDICT_XPOS, MOVE_YPOS - 20);
			stage.addChild(text);
			
			moveText = createText('?', MOVE_SIZE, 0, true, MOVE_XPOS, MOVE_YPOS);
			stage.addChild(moveText);
			predictText = createText('?', MOVE_SIZE, 0, true, PREDICT_XPOS, MOVE_YPOS);
			stage.addChild(predictText);			
			percentText = createText('Percent correct: 0% < 25%', PERCENT_SIZE, 0, false, 225, PERCENT_YPOS);
			stage.addChild(percentText);	
			text = createText("25% is chance level", 24, 0, false, 225, PERCENT_YPOS + 40);
			stage.addChild(text);
			
			// border
			graphics.lineStyle(2, 0xDDDDDD);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				
			// capture key presses
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		}
		
		private function keyDownListener(e:KeyboardEvent):void {
			// respond to keys 1,2,3,4
			if (e.keyCode >= 49 && e.keyCode <= 52) {
				var move:int = e.keyCode - 49;
				
				total++;
				model.update(move);
				
				// check prediction
				var color:Number = 0xFF0000;
				if (move == prediction) {
					correct += 1;
					color = 0x00FF00;
				}

				// remove previous text
				stage.removeChild(moveText);
				stage.removeChild(predictText);
				stage.removeChild(percentText);
				// show move and prediction
				moveText = createText(String(move + 1), MOVE_SIZE, 0, true, MOVE_XPOS, MOVE_YPOS);
				stage.addChild(moveText);
				predictText = createText(String(prediction + 1), MOVE_SIZE, color, true, PREDICT_XPOS, MOVE_YPOS);
				stage.addChild(predictText);
				
				var percentCorrect:int = int(correct / total * 100);
				var bl:String = '<';
				color = 0xFF0000;
				if (percentCorrect >= 25) {
					bl = '>';
					color = 0x00FF00;
				}
				percentText = createText('Percent correct: ' + percentCorrect + '% ' + bl + ' 25%', PERCENT_SIZE, 0, false, 225, PERCENT_YPOS);
				var colorFormat:TextFormat = new TextFormat()
				colorFormat.color = color;
				percentText.setTextFormat(colorFormat, 17, 17+String(percentCorrect).length+1)
				stage.addChild(percentText);	
				
				// get most probable next move
				prediction = argmax(model.predict());				
			}
		}
		
		private function createText(text:String, size:int, color:Object, bold:Boolean, x:int, y:int):TextField {
			var textFormat:TextFormat = new TextFormat('Trebuchet MS', size, color, bold);
			var textField:TextField = new TextField();
			textField.text = text;
			textField.x = x;
			textField.y = y;
			textField.setTextFormat(textFormat);
			textField.autoSize = "center";
			return textField;
		}
		
		private function argmax(x:Array):int {
			var argmax:int = 0;
			var max:Number = Number.MIN_VALUE;
			for (var k:int = 0; k < x.length; k++) {
				if (x[k] > max) {
					max = x[k];
					argmax = k;
				}
			}
			return argmax;
		}
		
	}
	
}
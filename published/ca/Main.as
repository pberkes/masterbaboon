/**
 *	@author  >> Justin Windle
 *	@link	 >> soulwire.co.uk
 *	@version >> 0.1
 */

package  
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.controls.TextInput;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class Main extends Sprite
	{
		
		/*
		========================================================
		| Private Variables                         | Data Type  
		========================================================
		*/
		
		private var _timer:							Timer;
		private var _grid:							CAGrid;
		
		/*
		========================================================
		| Constructor
		========================================================
		*/
		
		public function Main() 
		{
			_grid = new CAGrid( 380, 40, 1 );
			_grid.x = 30;
			_grid.y = 20;
			addChild( _grid );
			
			setStyles();
			loadPresets();
			configureListeners();
		}
		
		/*
		========================================================
		| Private Methods
		========================================================
		*/
		
		/**
		 * make the components look cool
		 */
		
		private function setStyles():void
		{
			var tf:TextFormat = new TextFormat( 'Tahoma', 10, 0xFFFFFF, true );
			
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = getChildAt(i);
				if ( child is Button ) Button(child).setStyle( 'textFormat', tf );
			}
			
			List( presets.dropdown ).setRendererStyle( 'textFormat', tf );
			TextInput( presets.textField ).setStyle( 'textFormat', tf );
		}
		
		/**
		 * Add the presets to the comboBox
		 */
		
		private function loadPresets():void
		{
			presets.prompt = "Presets";
            presets.addItem( { label: "Soulwire", data:Presets.SOULWIRE } );
			presets.addItem( { label: "Corners", data:Presets.CORNERS } );
			presets.addItem( { label: "Gliders", data:Presets.GLIDERS } );
			presets.addItem( { label: "Spaceships", data:Presets.SPACESHIPS } );
			presets.addItem( { label: "Explosion", data:Presets.EXPLOSION } );
            presets.addEventListener( Event.CHANGE, loadPreset );            
			
			_grid.load( Presets.SOULWIRE );
		}
		
		/**
		 * add listeners for the buttons
		 */
		
		private function configureListeners():void
		{
			_timer = new Timer( 100 );
			_timer.addEventListener( TimerEvent.TIMER, onTick );
			
			startBtn.addEventListener( MouseEvent.CLICK, start );
			stopBtn.addEventListener( MouseEvent.CLICK, stop );
			randomBtn.addEventListener( MouseEvent.CLICK, randomise );
			resetBtn.addEventListener( MouseEvent.CLICK, reset );
			saveBtn.addEventListener( MouseEvent.CLICK, save );
		}
		
		/*
		========================================================
		| Event Handlers
		========================================================
		*/
		
		private function onTick( e:Event ):void
		{
			_grid.update();
			genTxt.text = 'Generation: ' + _grid.generation.toString();
		}
		
		private function start( e:MouseEvent ):void
		{
			_timer.start();
		}
		
		private function stop( e:MouseEvent ):void
		{
			_timer.stop();
		}
		
		private function randomise( e:MouseEvent ):void
		{
			genTxt.text = 'Generation: 0';
			_grid.randomise();
		}
		
		private function reset( e:MouseEvent ):void
		{
			genTxt.text = 'Generation: 0';
			_timer.stop();
			_grid.reset();
		}
		
		private function save( e:MouseEvent ):void
		{
			_grid.save();
		}
		
		private function loadPreset( e:Event ):void
		{
			genTxt.text = 'Generation: 0';
			_timer.stop();
			_grid.load( ComboBox(e.target).selectedItem.data );
		}
	}
	
}

package funkin;

import flixel.math.FlxMath;
import states.PlayState;
import base.Conductor;
import base.ForeverDependencies.OffsettedSprite;
import base.ScriptHandler;
import funkin.Strumline.ReceptorData;
import haxe.Json;

class Note extends OffsettedSprite
{
	public var noteData:Int;
	public var beatTime:Float;
	public var wasGoodHit:Bool = false;

	public var swagWidth:Float;

	public var isHold:Bool;
	public var prevNote:Note;

	public var offsetX:Float = 0;
	public var offsetY:Float = 0;

	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;

	public static var scriptCache:Map<String, ForeverModule> = [];
	public static var dataCache:Map<String, ReceptorData> = [];

	public var receptorData:ReceptorData;
	public var noteModule:ForeverModule;

	public var endHoldOffset:Float = Math.NEGATIVE_INFINITY;

	public function new(beatTime:Float, index:Int, noteType:String, ?prevNote:Note, isHold:Bool = false)
	{
		if (prevNote == null)
			prevNote = this;

		noteData = index;
		this.beatTime = beatTime;
		this.isHold = isHold;
		this.prevNote = prevNote;

		super();

		loadNote(noteType);
	}

	public function loadNote(noteType:String)
	{
		receptorData = returnNoteData(noteType);
		noteModule = returnNoteScript(noteType);

		noteModule.interp.variables.set('note', this);
		// truncated loading functions by a ton
		noteModule.interp.variables.set('getNoteDirection', getNoteDirection);
		noteModule.interp.variables.set('getNoteColor', getNoteColor);

		if (noteModule.exists('generateNote'))
			noteModule.get('generateNote')();

		// set note data stuffs
		setGraphicSize(Std.int(width * receptorData.size));
		updateHitbox();
		antialiasing = receptorData.antialiasing;

		if (isHold && prevNote != null && prevNote.isHold)
		{
			prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5;
			if (PlayState.song != null)
				prevNote.scale.y *= FlxMath.roundDecimal(PlayState.song.speed, 2);
			prevNote.updateHitbox();
		}
	}

	public static function returnNoteData(noteType:String):ReceptorData
	{
		// load up the note data
		if (!dataCache.exists(noteType))
		{
			trace('setting note data $noteType');
			var leType:ReceptorData = cast Json.parse(AssetManager.getAsset(noteType, JSON, 'notetypes/$noteType'));

			// check for null values
			if (leType.separation == null)
				leType.separation = 160;
			if (leType.size == null)
				leType.size = 0.7;
			if (leType.antialiasing == null)
				leType.antialiasing = true;

			dataCache.set(noteType, leType);
		}
		return dataCache.get(noteType);
	}

	public static function returnNoteScript(noteType:String):ForeverModule
	{
		// load up the note script
		if (!scriptCache.exists(noteType))
		{
			trace('setting note script $noteType');
			scriptCache.set(noteType, ScriptHandler.loadModule(noteType, 'notetypes/$noteType'));
		}
		return scriptCache.get(noteType);
	}

	function getNoteDirection()
		return receptorData.actions[noteData];

	function getNoteColor()
		return receptorData.colors[noteData];

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		canBeHit = beatTime * Conductor.stepCrochet > Conductor.songPosition - Conductor.safeZoneOffset
			&& beatTime * Conductor.stepCrochet < Conductor.songPosition + Conductor.safeZoneOffset;
	}
}

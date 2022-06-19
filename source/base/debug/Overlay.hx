package base.debug;

import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	Overlay that displays FPS and memory usage.

	Based on this tutorial:
	https://keyreal-code.github.io/haxecoder-tutorials/17_displaying_fps_and_memory_usage_using_openfl.html
**/
class Overlay extends TextField
{
	var times:Array<Float> = [];
	var memPeak:Float = 0;

	public function new(x:Float, y:Float)
	{
		super();

		this.x = x;
		this.y = x;

		autoSize = LEFT;
		selectable = false;

		defaultTextFormat = new TextFormat(AssetManager.getAsset("vcr.ttf", FONT, 'fonts'), 18, 0xFFFFFF);
		text = "";

		addEventListener(Event.ENTER_FRAME, update);
	}

	static final intervalArray:Array<String> = ['KB', 'MB', 'GB', 'TB'];

	var memInterval:Int = 0;
	var memPeakInterval:Int = 0;

	function update(_:Event)
	{
		var now:Float = Timer.stamp();
		times.push(now);
		while (times[0] < now - 1)
			times.shift();

		var mem:Float = System.totalMemory / 1024 / 1024 * 1000;
		// /*
		for (i in 0...intervalArray.length)
		{
			if (mem > Math.pow(1000, i))
				memInterval = i;
		}
		//  */
		mem /= Math.pow(1000, memInterval);
		mem = Math.round(mem * 100) / 100;
		if (mem > memPeak)
		{
			memPeak = mem;
			memPeakInterval = memInterval;
		}

		if (visible)
			text = times.length + " FPS\n" + mem + ' ${intervalArray[memInterval]} / ' + memPeak + ' ${intervalArray[memPeakInterval]}\n';
	}
}

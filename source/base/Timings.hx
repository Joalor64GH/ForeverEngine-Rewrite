package base;

import haxe.ds.StringMap;

typedef Judgement =
{
	var maxMS:Float;
	var ?score:Int;
	var healthMult:Int;
}

class Timings
{
	public static final judgements:StringMap<Judgement> = [
		"sick" => {maxMS: 55, score: 350, healthMult: 100},
		"good" => {maxMS: 80, score: 150, healthMult: 75},
		"shit" => {maxMS: 100, score: -50, healthMult: -150},
		"bad" => {maxMS: 120, healthMult: 25},
		// "miss" => {maxMS: 140, score: -100, healthMult: -175}
	];

	public static function getRating(noteDiff:Float)
	{
		var foundRating:String = 'bad';
		var lowestThreshold:Float = Math.POSITIVE_INFINITY;

		for (rating in judgements.keys())
		{
			var threshold:Float = judgements.get(rating).maxMS;
			if (noteDiff <= threshold && threshold < lowestThreshold)
			{
				foundRating = rating;
				lowestThreshold = threshold;
			}
		}

		return foundRating;
	}
}

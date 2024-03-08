#charset "us-ascii"
//
// nightSkyDebug.t
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

#ifdef __DEBUG

DefineLiteralAction(SetPosition)
	execAction() {
		local ar, sky, str;

		str = getLiteral();
		ar = str.split(R'<space>');
		if(ar.length != 2) {
			reportFailure('Usage: set position &lt;latitude&gt;
				&lt;longitude&gt;');
			exit;
		}
		gSetPosition(toInteger(ar[1]), toInteger(ar[2]));

		sky = gSky;
		"Latitude is now <<toString(sky.latitude)>>, 
			longitude is now <<toString(sky.longitude)>>.\n ";
	}
;

VerbRule(SetPosition)
	'set' 'position' singleLiteral: SetPositionAction
	verbPhrase = 'set/setting position to (what)'
;

DefineSystemAction(DebugSky)
	execSystemAction() {
		local c, l, sky;

		c = gCalendar;
		sky = gSky;

		"It is now <<toString(c.getHour())>>:00 <<c.getMonthName()>>
			<<toString(c.getDay())>>
			<<toString(c.getYear())>>.\n ";
		"Latitude = <<toString(sky.latitude)>>\n ";
		"Longitude = <<toString(sky.longitude)>>\n ";
		"<.p> ";
		"Season: <<c.getSeasonName()>>\n ";
		"Phase of Moon: <<c.getMoonPhaseName()>>\n ";
		"Visible constellations:\n ";
		l = sky.computePositions(nil, nil, true);
		l.forEach(function(o) {
			"\n\t<<o.name>> (<<toString(o.alt)>>,
				<<toString(o.az)>>)\n ";
		});
	}
;
VerbRule(DebugSky) 'debug' 'sky': DebugSkyAction
	verbPhrase = 'debug/debugging the sky'
;

DefineSystemAction(MapSky)
	_size = 20
	_labels = nil
	_initLabels() {
		local i;

		_labels = new Vector();
		for(i = 0; i < 26; i++) _labels.append(makeString(65 + i));
		for(i = 0; i < 26; i++) _labels.append(makeString(97 + i));
	}
	execSystemAction() {
		local buf, i, l, sky, x, y, x0, y0, n, lbl;

		if(_labels == nil)
			_initLabels();

		sky = gSky;

		buf = new Vector(_size);
		for(y = 1; y <= _size; y++) {
			buf[y] = new StringBuffer();
			for(x = 1; x <= _size; x++)
				buf[y].append('.');
		}

		x0 = _size / 2;
		y0 = _size / 2;

		l = sky.computePositions(nil, nil, true);
		lbl = new Vector();
		l.forEach(function(o) {
			n = _size - ((o.alt / 90) * _size);
			x = x0 - toInteger(o.az.degreesToRadians().sine() * n);
			y = y0 - toInteger(o.az.degreesToRadians().cosine() * n);
			if(x < 1) x = 1;
			if(x > _size) x = _size;
			if(y < 1) y = 1;
			if(y > _size) y = _size;
			lbl.append(o);
			buf[y][x] = _labels[lbl.length()];
		});
		i = 1;
		buf.forEach(function(o) {
			"<<o>>";
			if(i <= lbl.length) {
				"   <<_labels[i]>>: <<lbl[i].name>>";
			}
			"\n ";
			i += 1;
		});
	}
;
VerbRule(MapSky) 'map' 'sky': MapSkyAction
	verbPhrase = 'map/mapping the sky'
;

DefineSystemAction(DebugPosition)
	execSystemAction() {
		"Latitude = <<toString(gSky.latitude)>>\n ";
		"Longitude = <<toString(gSky.longitude)>>\n ";
	}
;
VerbRule(DebugPosition) 'debug' 'position': DebugPositionAction
	verbPhrase = 'debug/debugging the position'
;

DefineSystemAction(DebugTick)
	execSystemAction() {
		gCalendar.advanceHour();
		newActorAction(gActor, MapSky);
	}
;
VerbRule(DebugTick) 'debug' 'tick': DebugTickAction
	verbPhrase = 'debug/debugging time tick'
;

#endif // __DEBUG

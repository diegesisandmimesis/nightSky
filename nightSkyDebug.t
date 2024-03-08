#charset "us-ascii"
//
// nightSkyDebug.t
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"
#include "bignum.h"

#ifdef __DEBUG

class Coord: object
	x = nil
	y = nil

	construct(v0?, v1?) {
		x = v0;
		y = v1;
	}
;

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
	// Size of the map, in characters.
	_size = 21
	_radius = 10

	// Constellation labels.
	_labels = nil

	// Create the label list.  It's just A-Z, a-z.
	_initLabels() {
		local i;

		_labels = new Vector();
		for(i = 0; i < 26; i++) _labels.append(makeString(65 + i));
		for(i = 0; i < 26; i++) _labels.append(makeString(97 + i));
	}

	_polarToRect(center, theta, r) {
		local rad, v;

		rad = theta.degreesToRadians();
		v = new Coord(center.x - toInteger(rad.sine() * r),
			center.y - toInteger(rad.cosine() * r));

		if(v.x < 1) v.x = 1;
		if(v.x > _size) v.x = _size;
		if(v.y < 1) v.y = 1;
		if(v.y > _size) v.y = _size;

		return(v);
	}

	execSystemAction() {
		local center, buf, i, l, sky, x, y, n, lbl, v;

		// Create the labels.
		if(_labels == nil)
			_initLabels();

		sky = gSky;

		// Create a vector of string buffers, filling them with
		// the "." character.
		// Each buffer is a line of the map.
		buf = new Vector(_size);
		for(y = 1; y <= _size; y++) {
			buf[y] = new StringBuffer();
			for(x = 1; x <= _size; x++)
				buf[y].append('.');
		}

		center = new Coord(_size / 2 + 1, _size / 2 + 1);

		// Compute the alt-az coordinates of the visible
		// constellations.
		l = sky.computePositions(nil, nil, true);

		// Vector to keep track of what to add to the legend.
		lbl = new Vector();

		// Draw a circle representing the horizon.
		for(i = 0; i < 360; i += 5) {
			n = new BigNumber(i);

			v = _polarToRect(center, n, _radius);
			buf[v.y][v.x] = ':';
		}

		l.forEach(function(o) {
			n = _radius - ((o.alt / 90) * _radius);
			v = _polarToRect(center, o.az, n);
			lbl.append(o);
			buf[v.y][v.x] = _labels[lbl.length()];
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

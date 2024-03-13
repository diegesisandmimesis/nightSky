#charset "us-ascii"
//
// nightSkyDebug.t
//
//	The module's debugging stuff.  Nothing in this file is compiled
//	unless t3make is called with the -d flag.
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
		local ar, str;

		str = getLiteral();
		ar = str.split(R'<space>');
		if(ar.length != 2) {
			reportFailure('Usage: set position &lt;latitude&gt;
				&lt;longitude&gt;');
			exit;
		}
		gSetPosition(toInteger(ar[1]), toInteger(ar[2]));

		"Latitude is now <<toString(gSky.latitude)>>, 
			longitude is now <<toString(gSky.longitude)>>.\n ";
	}
;

VerbRule(SetPosition)
	'set' 'position' singleLiteral: SetPositionAction
	verbPhrase = 'set/setting position to (what)'
;

DefineSystemAction(DebugSky)
	_limit = 26

	execSystemAction() {
		local c, l;

		c = gCalendar;

		"It is now <<toString(c.getHour())>>:00 <<c.getMonthName()>>
			<<toString(c.getDay())>>
			<<toString(c.getYear())>>.\n ";
		"Latitude = <<toString(gSky.latitude)>>\n ";
		"Longitude = <<toString(gSky.longitude)>>\n ";
		"<.p> ";
		"Season: <<c.getSeasonName()>>\n ";
		"Phase of Moon: <<c.getMoonPhaseName()>>\n ";
		"Position of Moon:
			<<toString(gSky.getMoonMeridianPosition())>>\n ";
		"Visible constellations:\n ";
		l = gSky.computePositions(nil, nil, _limit);
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
	//_radius = 10
	_radius = 9

	_sizeX = ((_radius * 4) + 1)
	_sizeY = ((_radius * 2) + 1)

	// Only consider the top this many catalog objects
	_limit = 26

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
		v = new Coord(center.x - toInteger(rad.sine() * r * 2),
			center.y - toInteger(rad.cosine() * r));

		if(v.x < 1) v.x = 1;
		if(v.x > _sizeX) v.x = _sizeX;
		if(v.y < 1) v.y = 1;
		if(v.y > _sizeY) v.y = _sizeY;

		return(v);
	}

	execSystemAction() {
		local center, buf, i, l, x, y, n, v;
		local x0, m, len;

		// Create the labels.
		if(_labels == nil)
			_initLabels();

		// Create a vector of string buffers, filling them with
		// the "." character.
		// Each buffer is a line of the map.
		buf = new Vector(_sizeY);
		for(y = 1; y <= _sizeY; y++) {
			buf[y] = new StringBuffer();
			for(x = 1; x <= _sizeX; x++)
				buf[y].append('.');
		}

		// Center of the ASCII map.
		center = new Coord(_sizeX / 2 + 1, _sizeY / 2 + 1);

		// Compute the alt-az coordinates of the visible
		// constellations.
		l = gSky.computePositions(nil, nil, _limit);

		// If the moon is visible, add it to the list of objects.
		m = gSky.getMoon();
		if(m.alt > 0)
			l.append(m);

		m = gSky.getSun();
		if(m.alt > 0)
			l.append(m);

		l.append(gSky.getPolaris());

		// Draw a circle representing the horizon.
		for(i = 0; i < 360; i += 3) {
			n = new BigNumber(i);

			v = _polarToRect(center, n, _radius);
			buf[v.y][v.x] = '*';
		}

		// Place the map markers.
		// Here we use the abbreviations, roughly centered on
		// the constellation's centroid.
		l.forEach(function(o) {
			// The length of the displacement from the
			// center point.
			n = _radius - ((o.alt / 90) * _radius);

			// Convert the angle and distance to rectangular
			// coordinates.
			v = _polarToRect(center, o.az, n);

			// First, try to offset the label by half its width.
			len = o.abbr.length;
			x0 = v.x - (len / 2);

			// Bounds check.
			if(x0 < 1)
				x0 = v.x;
			if(x0 + len > _sizeX)
				x0 = _sizeX - len;

			// Add the marker.
			buf[v.y].splice(x0, len, o.abbr);
		});

		l.sort(nil, { a, b: a.abbr.compareIgnoreCase(b.abbr) });

		"Time:  <<gCalendar.currentDate.formatDate('%c')>>\n ";

		// Output the map, along with the legend.
		i = 1;
		buf.forEach(function(o) {
			"<<o>>";
			if(i <= l.length) {
				" <<l[i].abbr>>:\t<<l[i].name>>";
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

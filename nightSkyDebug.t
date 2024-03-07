#charset "us-ascii"
//
// nightSkyDebug.t
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

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
		local altAz, c, l, sky;

		c = gCalendar;
		sky = gSky;

		"Date is <<c.getMonthName()>> <<toString(c.getDay())>>
			<<toString(c.getYear())>>.\n ";
		"Latitude = <<toString(sky.latitude)>>\n ";
		"Longitude = <<toString(sky.longitude)>>\n ";
		"<.p> ";
		"Season: <<c.getSeasonName()>>\n ";
		"Phase of Moon: <<c.getMoonPhaseName()>>\n ";
		"Visible constellations:\n ";
		l = sky.computeVisible(nil, nil, true);
		l.forEach(function(o) {
			altAz = sky.raDecToAltAz(o[3], o[4]);
			if(altAz[1] < 0)
				return;
			"\n\t<<o[1]>> (<<toString(altAz[1])>>,
				<<toString(altAz[2])>>)\n ";
		});
	}
;
VerbRule(DebugSky) 'debug' 'sky': DebugSkyAction
	verbPhrase = 'debug/debugging the sky'
;

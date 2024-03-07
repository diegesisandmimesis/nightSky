#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the nightSky library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		local c, h, l, sky, altAz;

		c = new Calendar(1979, 6, 22, 'EST-5EDT');
		sky = new NightSky(42, -71, c);

		h = 23;
		"visible constellations:\n ";
		l = sky.computeVisible(23, h, true);
		l.forEach(function(o) {
			altAz = sky.raDecToAltAz(o[3], o[4], h);
			if(altAz[1] < 0) return;
			"\n\t<<o[1]>> (<<toString(altAz[1])>>,
				<<toString(altAz[2])>>)\n ";
		});
		"\n total = <<toString(l.length)>>\n ";

		"<.p>";

		"Is Draco visible?  <<toString(sky.checkConstellation('draco',
			h))>>\n ";
		"Is Aries visible?  <<toString(sky.checkConstellation('aries',
			h))>>\n ";
	}
;

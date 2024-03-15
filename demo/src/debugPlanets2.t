#charset "us-ascii"
//
// debugPlanets2.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the nightSky library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f debugPlanets2.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "date.h"
#include "nightSky.h"

modify gameEnvironment
	currentDate = new Date(2024, 3, 2, 17, 29, 0, 0, 'PST-8PDT')
	latitude = 42
	longitude = -71
;

versionInfo: GameID;
gameMain: GameMainDef
	_testList = static [
		// year, month, day, timezone, planet, expected RA, expected DEC
		[ 2024, 3, 3, 'UTC', mercury, 23, -7 ],
		[ 2024, 3, 3, 'UTC', venus, 21, -16 ],
		[ 2024, 3, 3, 'UTC', mars, 21, -18 ],
		[ 2024, 3, 3, 'UTC', jupiter, 3, 14 ],
		[ 2024, 3, 3, 'UTC', saturn, 23, -9 ]
	]
	newGame() {
		local d, jd;

		d = new Date(2024, 3, 3, 0, 0, 0, 0, 'UTC');
		jd = d.formatDate('%J');
		jupiter.compute(jd);
		"<<toString(jd)>> RA/DEC = <<toString(jupiter.ra)>> <<toString(jupiter.dec)>>\n ";

		d = new Date(2024, 3, 7, 0, 0, 0, 0, 'UTC');
		jd = d.formatDate('%J');
		jupiter.compute(jd);
		"<<toString(jd)>> RA/DEC = <<toString(jupiter.ra)>> <<toString(jupiter.dec)>>\n ";

		d = new Date(2024, 3, 9, 0, 0, 0, 0, 'UTC');
		jd = d.formatDate('%J');
		jupiter.compute(jd);
		"<<toString(jd)>> RA/DEC = <<toString(jupiter.ra)>> <<toString(jupiter.dec)>>\n ";
	}
;


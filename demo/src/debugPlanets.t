#charset "us-ascii"
//
// debugPlanets.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the nightSky library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f debugPlanets.t3m
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
		local err;

		err = 0;
		_testList.forEach(function(o) {
			if(_runTest(o) != true)
				err += 1;
		});

		if(err == 0)
			"Passed <<toString(_testList.length)>> of
				<<toString(_testList.length)>> tests.\n ";
		else
			"ERROR:  failed <<toString(err)>> of
				<<toString(_testList.length)>> tests.\n ";
	}
	_runTest(o) {
		local d, jd;

		d = new Date(o[1], o[2], o[3], o[4]);
		jd = d.formatDate('%J');
		o[5].computeRADec(jd);
		return((o[5].ra == o[6]) && (o[5].dec == o[7]));
	}
;


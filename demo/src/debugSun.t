#charset "us-ascii"
//
// debugSun.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the nightSky library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f debugSun.t3m
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
	currentDate = new Date(1979, 6, 22, 23, 0, 0, 0, 'EST-5EDT')
	latitude = 42
	longitude = -71
;

versionInfo: GameID;
gameMain: GameMainDef
	_testList = static [
		// year, month, day, timezone, expected RA, expected DEC
		[ 1979, 6, 22, 'UTC', 6, 23 ],
		[ 2021, 1, 1, 'UTC', 19, -23 ]
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
		local d, jd, s;

		d = new Date(o[1], o[2], o[3], o[4]);
		jd = d.formatDate('%J');
		s = gSky.getSun();
		s.compute(jd);

		return((s.ra == o[5]) && (s.dec == o[6]));
	}
;


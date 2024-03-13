#charset "us-ascii"
//
// interactive.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the nightSky library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f interactive.t3m
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

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

startRoom: Room 'Void' "This is a featureless void. ";
+me: Person;

// Set the current time to be June 22, 1979, @ 23:00 Eastern, and
// the location is Cambridge, Mass.
modify gameEnvironment
	currentDate = new Date(1979, 6, 22, 23, 0, 0, 0, 'EST-5EDT')
	latitude = 42
	longitude = -71
;
// Add data for Arcturus.
//+Ephem 'Arcturus' 'ARC' ra = 14 dec = 19 order = 1;

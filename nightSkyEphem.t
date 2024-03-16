#charset "us-ascii"
//
// nightSkyEphem.t
//
//	Utility classes for the nightSky module.
//
//
// NOTE ON THE ORDER PROPERTY
//
//	The order property is a numeric value indicating an semi-arbitrary
//	"noteworthiness".  Lower is more "noteworthy".
//
//	The idea is that a catalog might contain a lot of objects, but in
//	general if you're scanning the sky you're most interested in only
//	the most recognizable/brightest/whatever objects.  So even if Canes
//	Venatici is closer to zenith than Ursa Major at the moment, you're
//	probably still more interested in Ursa Major.
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

#include "bignum.h"

// Class to hold individual objects' ephemeris data.
class Ephem: object
	name = nil		// the object's name
	abbr = nil		// abbreviation.  mostly used for debugging
	ra = nil		// right ascension
	dec = nil		// declination

	order = 99		// catalog "order".  see note at head of file

	alt = nil		// computed altitude
	az = nil		// computed azimuth

	catalog = nil		// catalog we belong to

	construct(n?, a?, r?, d?, m?, a0?, a1?) {
		if(n != nil) name = n;
		if(a != nil) abbr = a;
		if(r != nil) ra = r;
		if(d != nil) dec = d;
		if(m != nil) order = toInteger(m);
		if(a0 != nil)
			alt = new BigNumber(a0);
		if(a1 != nil)
			az = new BigNumber(a1);
	}

	// For fixed stars, we don't have to recacluate anything.
	compute(d) {}

	checkCache(jd) {}

	// Clear computed values.
	clear() {
		alt = nil;
		az = nil;
	}

	// Called at preinit.
	initializeEphem() {
		if(_tryLocation(location, NightSkyCatalog))
			return;
		if(_tryLocation(location, NightSky))
			return;
		if(_tryEnvironment(location))
			return;
	}

	// Check to see if the given object is where we're going to live.
	_tryLocation(obj, cls) {
		if((obj == nil) || !obj.ofKind(cls))
			return(nil);

		obj.addEphem(self);

		return(true);
	}

	// Check to see if our location is the gameEnvironment singleton.
	_tryEnvironment(obj) {
		if((obj == nil) || (obj != gameEnvironment))
			return(nil);

		gSky.addEphem(self);

		return(true);
	}
;

class EphemOrder: object
	order = nil
	initializeEphemOrder() {
		if((location == nil) || !location.ofKind(NightSkyCatalog))
			return;
		location.addEphemOrder(self);
	}
;

// Class for ephemeris entries that don't have a fixed RA and DEC.
class DynamicEphem: Ephem
	// RA in degrees.
	raDeg = nil

	// Date when RA/DEC was computed.
	_julianDate = nil

	// Constants.
	_pi = 3.141592654
	_pi2 = 6.28318530

	// Method called to update the object.
	// The argument is the integer Julian date.
	// By default we compute once per day.
	compute(d) {
		// If the date hasn't changed, we don't need to update.
		if(_julianDate == d)
			return;

		if((skyCacheID != nil) && checkCache(d))
			return;

		// Actually compute the RA and DEC.
		computeRADec(d);

		// Remember the date the computed values are for.
		_julianDate = d;
	}

	// Stub method.
	computeRADec(d) {}

	// atan2 implementation
	atan2(y, x) {
		if(x > 0) {
			return((y / x).arctangent());
		} else if(x < 0) {
			if(y >= 0)
				return((y / x).arctangent() + _pi);
			else
				return((y / x).arctangent() - _pi);
		} else {
			if(y > 0)
				return(_pi / 2);
			else
				return(-(_pi / 2));
		}
	}
;

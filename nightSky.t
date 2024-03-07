#charset "us-ascii"
//
// nightSky.t
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

#include "bignum.h"

// Module ID for the library
nightSkyModuleID: ModuleID {
        name = 'Night Sky Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

class NightSky: object
	// Our viewing position's latitude and longitude, as integer
	// degrees.
	latitude = nil
	longitude = nil

	// The width of the horizon in hours of right ascension.
	// The viewable sky is the current meridian +/- this many
	// hours of right ascension.
	horizonWidth = 5

	// Holds a Calendar instance.
	calendar = nil

	// The viewing position's latitude and lognitude as bignum
	// radians.
	_lat = nil
	_long = nil

	// The sine and cosine of the latitude.
	_latSine = nil
	_latCosine = nil

	// To hold our list of constellations.
	// Supplied by nightSkyData.t
	_constellations = nil

	construct(lat?, long?, cal?) {
		// We arbitrarily default to Greenwich if our location
		// isn't given.
		if(lat == nil)
			lat = 51;
		if(long == nil)
			long = 0;

		// Explicitly call the setter to handle saving
		// the bignum versions.
		setLatitude(lat);
		setLongitude(long);

		if(cal == nil)
			cal = new Calendar();
		calendar = cal;
	}

	setPosition(l0, l1) {
		setLatitude(l0);
		setLongitude(l1);
	}

	// Explicit setters for the latitude and longitude.
	// We convert the arg into an integer and then save a bignum
	// version of the integer not for precision, but because we
	// later want the bignum for computations.
	setLatitude(v) {
		latitude = toInteger(v);
		_lat = new BigNumber(latitude).degreesToRadians();
		_latSine = _lat.sine();
		_latCosine = _lat.cosine();
	}
	setLongitude(v) { 
		longitude = toInteger(v);
		_long = new BigNumber(longitude).degreesToRadians();
	}

	// Returns a list of the currently-visible constellations.
	// First arg is the local hour.
	// Second arg is the width of the horizon, in units of
	// hours of right ascension.  Default is 5, which means
	// that the current meridian +/- 5 hours, or ~11 hours
	// or just under half the total sky is visible.
	computeVisible(h?, width?, short?) {
		local st;

		st = calendar.getLocalSiderealTime(h, longitude);

		if(width == nil)
			width = horizonWidth;

		return(searchConstellations(st, width, short));
	}

	// Same as computeVisible() above, but the first argument is
	// is local sidereal time (instead of local civil time).
	searchConstellations(sTime, width, short?) {
		local v;

		v = new Vector();
		_constellations.forEach(function(o) {
			if((short == true) && ((o.length < 5)
				|| (o[5] != true)))
				return;
			if(isVisible(o, sTime, width))
				v.append(o);
		});

		return(v);
	}

	// Returns boolean true if the given constellation is visible.
	checkConstellation(id, h?, width?) {
		local i, lst, o;

		if(id == nil)
			return(nil);
		id = id.toLower();

		if(h == nil)
			h = 0;

		if(width == nil)
			width = horizonWidth;

		lst = nil;

		for(i = 1; i <= _constellations.length; i++) {
			o = _constellations[i];
			if((id == o[1].toLower()) || (id == o[2].toLower())) {
				if(lst == nil)
					lst = calendar.getLocalSiderealTime(h,
						longitude);
				return(isVisible(o, lst, width));
			}
		}

		return(nil);
	}

	// Make sure a value is between 0 and 23.
	modTime(v) {
		v = v % 24;
		if(v < 0) v += 24;
		return(v);
	}

	// Returns true if the given declination is visible to us.
	// This only depends on our latitude, so we just need the value.
	checkDeclination(v) {
		if(latitude >= 0) {
			// In the northern hemisphere we can see the
			// north celestial pole and everything down
			// (our latitude - 90).
			return((v <= 90) && (v >= (latitude - 90)));
		} else {
			// In the southern hemisphere we can see the
			// south celestial pole and everything up to
			// (90 - our latitude).
			return((v >= -90) && (v <= (90 - latitude)));
		}
	}

	// Returns true if the given right ascension is visible to
	// us.
	// This is more complicated than declination, because we
	// can see the full circle of right ascensions near our
	// celestial pole (the north celestial pole in the northern
	// hemisphere, the south in the southern), but less the
	// further away from the pole we get.
	checkRightAscension(ra, dec, sTime, width) {
		// Instead of trying to be clever, we just split this
		// into a different method for each hemisphere.
		if(latitude >= 0) {
			return(_checkRANorth(ra, dec, sTime, width));
		} else {
			return(_checkRASouth(ra, dec, sTime, width));
		}
	}

	// Method we use if the declination is NOT within our latitude
	// of the pole (if the angular difference between the declination
	// and the pole is less than our latitude, we can see the full
	// circle of ascensions and so we don't have to do any fancy
	// calculations).
	// We're just checking if the right ascension is our local
	// sidereal time +/- the width of our horizon (in hours of
	// right ascension), but we have to do some tap-dancing because
	// we're doing modular arithmetic:  if our LST is 23 and
	// and the horizon is 5 hours wide, then we want RAs between
	// (23 - 5) and (23 + 5).  That means we want the range 18 - 23,
	// but we ALSO want the range less than 4, because
	// (23 - 5) % 24 = 18, but (23 + 5) % 24 = 4.  So we can't just
	// check between 18 and 28, because "hour 28" is hour 04.
	_checkRA(ra, sTime, width) {
		local raMin, raMax;

		// Compute (LST - width) % 24 and (LST + width) % 24.
		raMin = modTime(sTime - width);
		raMax = modTime(sTime + width);

		// Handle the simple case, were we DIDN'T "wrap around",
		// so we've only got a single range.
		if(raMin < raMax)
			return((ra >= raMin) && (ra <= raMax));

		// The "tricky" case, where the range we're checking "wraps
		// around" in the middle.  Then we DON'T check if the ra
		// is between the min and max, we check if it's more than
		// the max or less than the min.  If it is, then it's NOT
		// in the range, otherwise it is.
		// In the example above, raMax would be 4 and raMin
		// would be 18.  So we check if the RA is in the range of
		// 4 and 18, and return false if it is, true if it isn't.
		if((ra > raMax) && (ra < raMin))
			return(nil);

		return(true);
	}

	_checkRANorth(ra, dec, sTime, width) {
		// We can see everything within our latitude of the pole.
		if(dec > (90 - latitude))
			return(true);

		return(_checkRA(ra, sTime, width));
	}

	_checkRASouth(ra, dec, sTime, width) {
		// We can see everything within our latitude of the pole.
		if(dec < (-90 - latitude))
			return(true);

		return(_checkRA(ra, sTime, width));
	}

	// Wrapper for the declination and right ascension checks.
	isVisible(obj, sTime, width) {
		return(checkDeclination(obj[4]) && checkRightAscension(obj[3],
			obj[4], sTime, width));
	}

	// Compute right ascension and declination to altitude and
	// azimuth.
	// Third argument is an optional integer hour, defaulting to
	// local midnight if none is given.
	raDecToAltAz(ra, dec, h?) {
		local a, alt, az, decSine, ha, n, st;

		// Make sure we have a time.
		if(h == nil)
			h = 0;

		// Get the local sidereal time.
		st = calendar.getLocalSiderealTime(h, longitude);

		// Compute the hour angle, making sure it's between
		// 0 and 360.
		// Sidereal time and right ascension are
		// both mod 24, so to convert to degrees we multiply
		// by 15.
		ha = ((st - ra) * 15) % 360;
		while(ha < 0)
			ha += 360;

		// Convert the declination and hour angle, currently
		// integer angles in degrees, into bignum angles in radians.
		dec = new BigNumber(dec).degreesToRadians();
		ha = new BigNumber(ha).degreesToRadians();

		decSine = dec.sine();

		// Compute the sine of the altitude.
		n = (decSine * _latSine)
			+ (dec.cosine() * _latCosine * ha.cosine());

		// Make sure the value is in range.
		while(n <= -1)
			n += 0.000001;
		while(n >= 1)
			n -= 0.000001;

		// Get the altitude in radians.
		alt = n.arcsine();

		// Compute the cosine of the azimuth.
		n = (decSine - (n * _latSine)) / (alt.cosine() * _latCosine);

		// Make sure the value is in range.
		while(n <= -1)
			n += 0.000001;
		while(n >= 1)
			n -= 0.000001;

		// Get the azimuth in radians.
		a = n.arccosine();

		// Convert the azimuth to degrees.
		a = a.radiansToDegrees();

		// Set the range of the azimuth.
		if(ha.sine() < 0)
			az = a;
		else
			az = 360 - a;

		// Convert the altitude to degrees.
		alt = alt.radiansToDegrees();

		// Return the alt-az coordinates.
		return([alt.roundToDecimal(0), az.roundToDecimal(0)]);
	}
;

gameSky: NightSky, PreinitObject
	execute() {
		if(calendar == nil)
			calendar = gCalendar;
		if(latitude == nil)
			setLatitude(51);
		if(longitude = nil)
			setLongitude(0);
	}
;

#charset "us-ascii"
//
// nightSky.t
//
//	A TADS3/adv3 module for computing the constellations visible in
//	the night sky.
//
//	It provides a very simple ephemeris consisting of the IAU
//	designated constellations plus the Pleiades.
//
//	This module depends on the calendar module:
//		https://github.com/diegesisandmimesis/calendar
//
//
// DISCLAIMER:
//
//	The computations are VERY approximate, using integer angles,
//	rounding times to the nearest hour, and so on.  It is only intended
//	to provide a list of constellations visible at an approxiate
//	time, and (optionally) their approximate positions in the sky.
//
//
// USAGE:
//
//	Create a NightSky instance:
//
//		// Create a calendar with the time midnight on June 22, 1979.
//		local c = new Calendar(1979, 6, 22, 'EST-5EDT');
//
//		// Create a NightSky instance centered on Cambridge, Mass.
//		// First two args are latitude and longitude, third is
//		// the calendar instance to use in the NightSky instance.
//		local sky = new NightSky(42, -71, c);
//
//	Get the visible constellations:
//
//		// Returns a list of the visible constellations at
//		// local time 23:00, with a horizon radius of 5 hours
//		// of right ascension (first and second arguments).  The
//		// third argument is an optional numerical limit.  If given,
//		// only catalog objects with a catalog order equal to or
//		// lower than the limit will be used.  In the example below,
//		// only the top 20 objects will be considered.  Note that
//		// this does NOT mean that computeVisible() will return 20
//		// objects, it means that the visible members of the top 20
//		// will be returned.  For more information on the ranking,
//		// see the comments at the top of nightSkyEphem.t
//		local visible = sky.computeVisible(23, 5, 20);
//
//	Get approximate positions of the visible constellations:
//
//		// Returns a list of the visible constellations, including
//		// their approximate positions in local altitude-azimuth
//		// coordinates.
//		// Args are the same as computeVisible() above, with the
//		// addition of the fourth argument, which is a callback
//		// function which will be called with each matching
//		// constellation.  In this case, the fuction checks that
//		// the constellation's computed altitude is positive.  If
//		// the callback does not return true, the constellation will
//		// not be included in the results of computeVisible().
//		local pos = sky.computePositions(23, 5, true, function(o) {
//			return(o.alt >= 0);
//		});
//
//	Determine if the given constellation is visible:
//
//		// Returns boolean true if the constellation is visible,
//		// nil otherwise.
//		// First arg is a string, which will be checked for an
//		// exact, case-insensitive match against the constellation
//		// names and abbreviations.  Second arg is the local hour.
//		local vis = sky.checkConstellation('draco', 23);
//
//
//	In the above examples almost all the arguments are optional (the
//	exception being the search term in checkConstellation()).  If
//	an argument isn't given (or is nil) then local conditions will
//	be used.
//
//
// LUNAR POSITION
//
//	To get the approximate position of the moon relative to the
//	local meridian (the line from north to south passing directly
//	overhead):
//
//		// Get the offset in degrees at 23:00 local time.
//		local off = sky.getMoonMeridianPosition(23);
//
//	The argument is optional.  The return value will be the offset
//	of the lunar position relative to the local meridian, in integer
//	degrees, in the range from -180 to 180.
//
//	The approximate altitude and azimuth of the moon can be obtained
//	via:
//
//		// Get an Ephem instance for the moon, with alt-az
//		// coordinates computed, for local hour 04:00.
//		local moon = sky.getMoon(4);
//
//	The argument is optional.  The return value will be an Ephem
//	instance with the current (for the given hour or the current-for
//	the-sky-instance time if none is given) altitude-azimuth coordinates
//	computed.  The values will be available as moon.alt and moon.az.
//
//
// GLOBAL GAME SKY
//
//	In addition to the usage above (creating standalone NightSky instances)
//	the module supplies a global NightSky instance, gameSky.
//
//	By default it uses the global calendar (gameCalendar) from the
//	calendar module.
//
//	The module provides these macros:
//
//		gSky			returns the global sky object
//		gSetPosition(la, lo)	sets the latitude and longitude of
//						the global sky object
//
//
// GLOBAL GAME ENVIRONMENT
//
//	This module extends the gameEnvironment instance provided by the
//	calendar module to include latitude and longitude.  Example of use:
//
//		// Configures the time to be midnight on June 22, 1979, and
//		// the position to be 42 deg N latitude, 71 deg W longitude.
//		modify gameEnvironment
//			currentDate = new Date(1979, 6, 22, 0, 0, 0, 'EST-5EDT')
//			latitude = 42
//			longitude = -71
//		;
//
//
#include <adv3.h>
#include <en_us.h>

#include "bignum.h"
#include "date.h"

#include "nightSky.h"

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

	// Computed RA of the moon.
	_lunarRADeg = nil

	// Declination of the moon.
	// We use a constant value because computing it is several
	// floating point operations (which are very slow in TADS3)
	// and we really only need the RA to answer the question "is
	// the moon visible" to acceptable accuracy, so eh.
	_lunarDec = 23

	moonEphem = nil
	sunEphem = nil
	polarisEphem = nil

	// To hold our list of constellations.
	// Supplied by nightSkyData.t
	_catalog = nil

	_catalogExtra = nil

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

	// Utility methods for canonicalizing common arguments with
	// possible defaults.
	resolveHour(v?) {
		return((v == nil) ? calendar.getHour() : toInteger(v));
	}
	resolveWidth(v?) {
		return((v == nil) ? horizonWidth : toInteger(v));
	}

	// Convenience method for setting the latitude and longitude.
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

	// Returns a list of the currently-visible constellations (each
	// list element is an Ephem instance).
	// First arg is the local hour.
	// Second arg is the width of the horizon, in units of
	// hours of right ascension.  Default is 5, which means
	// that the current meridian +/- 5 hours, or ~11 hours
	// or just under half the total sky is visible.
	computeVisible(h?, width?, limit?) {
		local lst;

		// Handle defaults.
		h = resolveHour(h);
		width = resolveWidth(width);

		// Get the local sidereal time.
		lst = calendar.getLocalSiderealTime(h, longitude);

		return(searchCatalog(lst, width, limit));
	}

	searchConstellations(lst, width, limit?) {
		return(searchCatalog(lst, width, limit));
	}

	// Same as computeVisible() above, but the first argument is
	// is local sidereal time (instead of local civil time).
	searchCatalog(lst, width, limit?) {
		return(matchCatalogObjects(function(o) {
			if((limit != nil) && (o.order >= limit))
				return(nil);

			o.compute(calendar.getJulianDate());

			// Check if the constellation is visible, and
			// add it to the return list if it is.
			if(isVisible(o, lst, width))
				return(true);

			return(nil);
		}));
	}

	checkConstellation(id, h?, width?) {
		return(checkCatalogObject(id, h, width));
	}

	getCatalogObjectName(id) {
		local i, l, o;

		if(id == nil)
			return(nil);
		id = id.toLower();

		l = getCatalogObjects();

		for(i = 1; i <= l.length; i++) {
			o = l[i];
			if((id == o.name.toLower())
				|| (id == o.abbr.toLower())) {
				return(o.name);
			}
		}

		return(nil);
	}

	// Returns boolean true if the given constellation is visible.
	checkCatalogObject(id, h?, width?) {
		local i, jd, l, lst, o;

		// We need an ID.
		if(id == nil)
			return(nil);

		// Convert to lower case.
		id = id.toLower();

		// Handle defaults.
		h = resolveHour(h);
		width = resolveWidth(width);

		// We compute the local sidereal time only when we
		// have to.
		lst = nil;

		jd = nil;

		l = getCatalogObjects();

		for(i = 1; i <= l.length; i++) {
			o = l[i];

			// Check to see if we've matched a name or
			// abbreviation.
			if((id == o.name.toLower())
				|| (id == o.abbr.toLower())) {

				// See if we have to compute the local
				// sidereal time.
				if(lst == nil)
					lst = calendar.getLocalSiderealTime(h,
						longitude);
				if(jd == nil)
					jd = calendar.getJulianDate();
				o.compute(jd);

				// Check the visibility.
				return(isVisible(o, lst, width));
			}
		}

		return(nil);
	}

	checkMoon(h?, width?) {
		local off;

		off = getMoonMeridianPosition(h);
		width = resolveWidth(width) * 15;
		return((off > -width) && (off < width));
	}

	checkSun(h?, width?) {
		local off;

		off = getSunMeridianPosition(h);
		width = resolveWidth(width) * 15;
		return((off > -width) && (off < width));
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
	checkRightAscension(ra, dec, lst, width) {
		// Instead of trying to be clever, we just split this
		// into a different method for each hemisphere.
		if(latitude >= 0) {
			return(_checkRANorth(ra, dec, lst, width));
		} else {
			return(_checkRASouth(ra, dec, lst, width));
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
	_checkRA(ra, lst, width) {
		local raMin, raMax;

		// Compute (LST - width) % 24 and (LST + width) % 24.
		raMin = modTime(lst - width);
		raMax = modTime(lst + width);

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

	_checkRANorth(ra, dec, lst, width) {
		// We can see everything within our latitude of the pole.
		if(dec > (90 - latitude))
			return(true);

		return(_checkRA(ra, lst, width));
	}

	_checkRASouth(ra, dec, lst, width) {
		// We can see everything within our latitude of the pole.
		if(dec < (-90 - latitude))
			return(true);

		return(_checkRA(ra, lst, width));
	}

	// Wrapper for the declination and right ascension checks.
	isVisible(obj, lst, width) {
		return(checkDeclination(obj.dec) && checkRightAscension(obj.ra,
			obj.dec, lst, width));
	}

	// Computes the alt-az coordinates of the visible constellations,
	// returning them as a list of Ephem instances.
	computePositions(h?, width?, limit?, cb?) {
		local altAz, l, v;

		h = resolveHour(h);
		width = resolveWidth(width);

		l = computeVisible(h, width, limit);
		v = new Vector(l.length);
		l.forEach(function(o) {
			altAz = raDecToAltAz(o.ra, o.dec, h);
			o.alt = altAz[1];
			o.az = altAz[2];
			if((dataTypeXlat(cb) != TypeNil)
				&& (cb(o) != true))
				return;
			v.append(o);
		});

		return(v);
	}

/*
	computePosition(objID, h?) {
		local altAz, obj;

		if((obj = getCatalog().getObjectByID(objID)) == nil)
			return(nil);

		h = resolveHour(h);
		altAz = raDecToAltAz(o.ra, o.dec, h);
		o.alt = altAz[1];
		o.az = altAz[2];

		return(o);
	}
*/

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

	updateEphem(obj, h?) { return(updateDynamicEphem(obj, h)); }

	updateDynamicEphem(obj, h?) {
		local altAz;

		if(obj == nil)
			return(nil);

		// Possibly re-compute the RA.
		obj.compute(calendar.getJulianDate());

		// Canonicalize the time.
		h = resolveHour(h);

		// Get the local alt-az coordinates for the object.
		altAz = raDecToAltAz(obj.ra, obj.dec, h);
		obj.alt = altAz[1];
		obj.az = altAz[2];

		return(obj);
	}

	getMeridianPosition(obj, h?) {
		local lst, r;

		h = resolveHour(h);
		lst = calendar.getLocalSiderealTime(h, longitude);

		if(obj.raDeg) {
			lst *= 15;
			r = lst - obj.raDeg;
		} else {
			r = (lst - obj.ra) * 15;
		}
		while(r < -180) r += 360;
		while(r > 180) r -= 360;

		return(r);
	}

	// Returns an Ephem instance for the current lunar
	// position.
	getMoon(h?) {
		// Create the Ephem instance if it doesn't
		// already exist.
		if(moonEphem == nil)
			moonEphem = new MoonEphem();

		return(updateDynamicEphem(moonEphem, h));
	}

	clearMoon() { getMoon().clear(); }

	// Returns the moons position relative to the local
	// meridian, in degrees.
	getMoonMeridianPosition(h?) {
		return(getMeridianPosition(getMoon(), h));
	}

	getSun(h?) {
		// Create the Ephem instance if it doesn't
		// already exist.
		if(sunEphem == nil)
			sunEphem = new SunEphem();

		return(updateDynamicEphem(sunEphem, h));
	}

	getSunMeridianPosition(h?) { return(getMeridianPosition(getSun(), h)); }

	clearSun() { getSun().clear(); }

	// Polaris is in Ursa Minor and UMi has its own Ephem instance in
	// the main constellation table.
	// The module provides a separate ephemeris object for Polaris because
	// it's a common guide star, and it makes visualization (i.e.
	// via >MAP SKY) easier.
	getPolaris(h?) {
		local altAz;

		if(polarisEphem == nil) {
			polarisEphem = new PolarisEphem();
			altAz = raDecToAltAz(polarisEphem.ra, polarisEphem.dec,
				h);
			polarisEphem.alt = altAz[1];
			polarisEphem.az = altAz[2];
		}

		return(polarisEphem);
	}

	// Add an ephemeris to our catalog.
	addEphem(obj) {
		if((obj == nil) || !obj.ofKind(Ephem))
			return(nil);

		if(_catalogExtra == nil)
			initCatalog();

		_catalogExtra.addEphem(obj);

		return(true);
	}

	// Create a new catalog for ourselves.
	initCatalog() { _catalogExtra = new NightSkyCatalog(); }

	// Make the argument our current catalog.
	setCatalog(obj) {
		// Make sure it's a catalog instance.
		if((obj == nil) || !obj.ofKind(NightSkyCatalog))
			return(nil);

		_catalog = obj;

		return(true);
	}

	setCatalogByID(id) {
		local obj;

		obj = nil;
		forEachInstance(NightSkyCatalog, function(o) {
			if(o.catalogID == id)
				obj = o;
		});
		if(obj == nil)
			return(nil);

		return(setCatalog(obj));
	}

	// Returns our current catalog.  If we don't have one set,
	// use the IAU designated constellations.
	getCatalog() {
		if(_catalog == nil)
			setCatalog(iauConstellations);
		return(_catalog);
	}


	// Returns all the objects in the current catalog.
	getCatalogObjects() {
		local r, v;

		r = getCatalog().getObjects();
		if(_catalogExtra == nil)
			return(r);
		v = _catalogExtra.getObjects();
		return(r + v);
	}

	// Returns a catalog object by its index in the catalog list.
	getCatalogObjectByIndex(idx) {
		return(getCatalog().getObjectByIndex(idx));
	}

	// Returns the named object.
	getCatalogObjectByID(id) {
		local r;

		r = getCatalog().getObjectByID(id);
		if(r != nil)
			return(r);

		if(_catalogExtra == nil)
			return(nil);

		r = _catalogExtra.getObjectByID(id);

		return(r);
	}

	// Returns all the catalog objects matching the given test function.
	matchCatalogObjects(fn) {
		local r, v;

		r = getCatalog().matchObjects(fn);
		if(_catalogExtra == nil)
			return(r);
		v = _catalogExtra.matchObjects(fn);

		return(r + v);
	}
;

// Global NightSky instance tied to the global calendar.
gameSky: NightSky, PreinitObject
	execBeforeMe = static [ gameEnvironment, gameCalendar, nightSkyPreinit ]
	execute() {
		calendar = gCalendar;
		if(latitude == nil)
			latitude = 51;
		if(longitude == nil)
			longitude = 0;

		setLatitude(latitude);
		setLongitude(longitude);

		gameEnvironment.initSkyCache();
	}
;

modify gameEnvironment
	latitude = nil
	longitude = nil

	execute() {
		inherited();
		if(latitude != nil)
			gameSky.latitude = latitude;
		if(longitude != nil)
			gameSky.longitude = longitude;
		//initSkyCache();
	}
;

modify gameCalendar
	// Tell the calendar to update every hour.
	updateInterval = 3600

	clearCache() {
		inherited();
		gameSky.clearMoon();
		gameSky.clearSun();
	}
;

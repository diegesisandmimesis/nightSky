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
	_iauConstellations = nil

	latitude = nil
	_lat = nil
	longitude = nil
	_long = nil

	calendar = nil

	construct(lat?, long?, cal?) {
		if(lat == nil)
			lat = 51;
		if(long == nil)
			long = 0;
		latitude = lat;
		longitude = long;
		if(cal == nil)
			cal = new Calendar();
		calendar = cal;
	}

	computeVisible(h?, width?) {
		local st, z;

		st = calendar.getLocalSiderealTime(h, longitude);
aioSay('\nsidereal time = <<toString(st)>>\n ');

		if(width == nil)
			width = 6;

		z = getZenith(h);

		return(searchConstellations(st, width, z));
	}

	getZenith(h?) {
		return([
			calendar.getLocalSiderealTime(h, longitude),
			latitude
		]);
	}

	modDist(a, b) {
		local d;

		if(b > a) {
			d = b - a;
		} else {
			d = a - b;
		}
		if(d >= 12)
			d = 24 - d;
		if(a < b)
			d = -d;
		return(d);
	}

	searchConstellations(sTime, width, z) {
		local v;

		v = new Vector();
		_iauConstellations.forEach(function(o) {
			if(isVisible(o, sTime, width))
				v.append(o);
		});

		return(v);
	}

	modTime(v) {
		v = v % 24;
		if(v < 0) v += 24;
		return(v);
	}

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

	checkRightAscension(ra, dec, sTime, width) {
		if(latitude >= 0) {
			return(_checkRANorth(ra, dec, sTime, width));
		} else {
			return(_checkRASouth(ra, dec, sTime, width));
		}
	}

	_checkRA(ra, sTime, width) {
		local raMin, raMax;

		// Figure out if ra = sTime +/- width.
		raMin = modTime(sTime - width);
		raMax = modTime(sTime + width);

		if(raMin < raMax)
			return((ra >= raMin) && (ra <= raMax));
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

	isVisible(obj, sTime, width) {
		return(checkDeclination(obj[4]) && checkRightAscension(obj[3],
			obj[4], sTime, width));
	}

	intSin(v) {
		local n;

		n = new BigNumber(v);
		n = n.degreesToRadians();
		return(n.sine());
	}
	intCos(v) {
		local n;

		n = new BigNumber(v);
		n = n.degreesToRadians();
		return(n.cosine());
	}

	raDecToAltAz(ra, dec, h?) {
		local a, alt, az, ha, n, st;

		if(h == nil)
			h = 0;

		st = calendar.getLocalSiderealTime(h, longitude);

		ha = ((st - ra) * 15) % 360;
		while(ha < 0)
			ha += 360;

		dec = new BigNumber(dec).degreesToRadians();
		_lat = new BigNumber(latitude).degreesToRadians();
		ha = new BigNumber(ha).degreesToRadians();

		//n = (intSin(dec) * intSin(latitude)) + (intCos(dec) *
			//intCos(latitude) * intCos(ha));
		n = (dec.sine() * _lat.sine())
			+ (dec.cosine() * _lat.cosine() * ha.cosine());
		alt = n.arcsine();

		//n = (intSin(dec) - (n * intSin(latitude))) /
			//(alt.cosine() * intCos(latitude));
		n = (dec.sine() - (n * _lat.sine()))
			/ (alt.cosine() * _lat.cosine());
		a = n.arccosine();

		a = a.radiansToDegrees();

		if(intSin(ha) < 0)
			az = a;
		else
			az = 360 - a;

		alt = alt.radiansToDegrees();

		return([alt.roundToDecimal(0), az.roundToDecimal(0)]);
	}
;

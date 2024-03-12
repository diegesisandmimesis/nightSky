#charset "us-ascii"
//
// nightSkySun.t
//
//	Comically low precision solar ephemeris.
//
//
#include <adv3.h>
#include <en_us.h>

#include "bignum.h"
#include "date.h"

#include "nightSky.h"

class SunEphem: Ephem
	name = 'Sun'
	abbr = '()'

	// The RA in degrees.
	raDeg = nil

	// Remember the Julian date we computed the RA for.
	_julianDate = nil

	// pi
	_pi = 3.141592654

	compute(d0) {
		if(_julianDate == d0)
			return;

		_computeRA(d0);
		_julianDate = d0;
	}

	_computeRA(jd) {
		local eps, g, l, lambda, n;

//local d = new Date(2021, 1, 1, 'UTC');
//jd = d.formatDate('%J');
// 18:50:12 RA, -22:56:08 DEC

//jd = 2458850;
// 18.76 RA -23.02 DEC

		n = new BigNumber(jd) - 2451545.0;
		l = 280.460 + 0.9856474 * n;
		g = 357.528 + 0.9856003 * n;

		while(l > 360) l -= 360;
		while(l < 0) l += 360;

		while(g > 360) g -= 360;
		while(g < 0) g += 360;

		g = g.degreesToRadians();

		lambda = l + (1.915 * g.sine()) + (0.020 * (2 * g).sine());
		eps = 23.439 - (0.0000004 * n);
		ra = atan2(eps.cosine() * lambda.sine(), lambda.cosine());

		dec = (eps.sine() * lambda.sine()).arcsine();
		dec = toInteger(dec.radiansToDegrees());
		//dec = 18;

		ra = ra.radiansToDegrees();

		while(ra > 360) ra -= 360;
		while(ra < 0) ra += 360;

		raDeg = toInteger(ra);
		ra = toInteger(ra / 15);
	}

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

	clear() {
		alt = nil;
		az = nil;
	}
;

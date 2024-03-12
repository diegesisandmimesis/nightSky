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
		local eps, g, l, lambda, n, x, y;

		n = new BigNumber(jd) - 2451545.0;
		l = 280.460 + 0.9856474 * n;
		g = 357.528 + 0.9856003 * n;

		while(l > 360) l += 360;
		while (l < 0) l += 360;
		while(g > 360) l += 360;
		while(g < 0) g += 360;

		g = g.degreesToRadians();

		lambda = l + (1.915 * g.sine()) + (0.020 * (2 * g).sine());
		eps = 23.439 - (0.0000004 * n);
		y = eps.cosine() * lambda.sine();
		x = lambda.cosine();
		if(x > 0) {
			ra = (y / x).arctangent();
		} else if(x < 0 && (y >= 0)) {
			ra = (y / x).arctangent() + _pi;
		} else if(x < 0 && (y < 0)) {
			ra = (y / x).arctangent() - _pi;
		} else {
			ra = _pi / 2;
		}

		dec = (eps.sine() * lambda.sine()).arcsine();
		dec = toInteger(dec.radiansToDegrees());

		ra = ra.radiansToDegrees();
		raDeg = toInteger(ra);
		ra = toInteger(ra / 15);
	}

	clear() {
		alt = nil;
		az = nil;
	}
;

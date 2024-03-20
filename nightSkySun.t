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

class SunEphem: DynamicEphem
	name = 'Sun'
	abbr = 'Sun'
	symbol = '()'

	computeRADec(jd) {
		local eps, g, l, lambda, n;

		n = new BigNumber(jd) - 2451545.0;
		l = 280.460 + 0.9856474 * n;
		g = 357.528 + 0.9856003 * n;

		while(l > 360) l -= 360;
		while(l < 0) l += 360;

		while(g > 360) g -= 360;
		while(g < 0) g += 360;

		g = g.degreesToRadians();

		lambda = l + (1.915 * g.sine()) + (0.020 * (2 * g).sine());
		lambda = lambda.degreesToRadians();
		eps = 23.439 - (0.0000004 * n);
		eps = eps.degreesToRadians();
		ra = atan2(eps.cosine() * lambda.sine(), lambda.cosine());

		dec = (eps.sine() * lambda.sine()).arcsine();
		dec = toInteger(dec.radiansToDegrees());

		ra = ra.radiansToDegrees();

		while(ra > 360) ra -= 360;
		while(ra < 0) ra += 360;

		raDeg = toInteger(ra);
		ra = toInteger(ra / 15);
	}
;
